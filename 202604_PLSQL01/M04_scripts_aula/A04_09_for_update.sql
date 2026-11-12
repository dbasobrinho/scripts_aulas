-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_09  |  Slide 11
-- Tema: FOR UPDATE e WHERE CURRENT OF
-- Versão: 1.0  |  2026-04-27
-- Pré-req: A04_02, A04_04, Schema EMP
-- =============================================================================
-- Ref: Oracle PL/SQL Language Reference 19c, Cap "Cursor FOR UPDATE"
--      Oracle Intro SQL/PL/SQL Vol2, Cap 22 (Cursor Explícito Avançado)
--      1Z0-149 Topic 6: FOR UPDATE clause / WHERE CURRENT OF clause
-- =============================================================================
-- O QUE DEMONSTRA:
--   1. FOR UPDATE: bloqueia as linhas selecionadas para atualização exclusiva
--   2. OF coluna: variante que bloqueia apenas quando a coluna específica pertence
--      a uma tabela específica (em joins)
--   3. NOWAIT / WAIT n: comportamento quando há lock de outro usuário
--   4. WHERE CURRENT OF cursor: UPDATE/DELETE na linha atual do cursor
--      sem repetir a condição WHERE
-- =============================================================================

SET SERVEROUTPUT ON

-- ============================================================
-- SEÇÃO 1: FOR UPDATE - CONCEITO E USO BÁSICO
-- ============================================================
-- Por que usar FOR UPDATE?
-- Quando você ABRE um cursor, as linhas não ficam bloqueadas.
-- Outro usuário pode alterar ou deletar a mesma linha enquanto
-- você ainda está iterando. FOR UPDATE evita esse problema:
-- bloqueia as linhas selecionadas no momento do OPEN.
--
-- Sintaxe:
--   CURSOR c IS
--     SELECT ... FROM tabela
--     FOR UPDATE [OF coluna] [NOWAIT | WAIT n];
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO 1: FOR UPDATE básico - bloquear linhas para reajuste
-- ------------------------------------------------------------
-- Cenário: reajustar salário dos analistas do departamento 20
-- com lock explícito para evitar conflito com outra sessão.
-- ------------------------------------------------------------
DECLARE
  CURSOR c_analistas IS
    SELECT empno, ename, sal
    FROM   emp
    WHERE  job    = 'ANALYST'
    AND    deptno = 20
    FOR UPDATE;                -- bloqueia as linhas no OPEN

  v_novo_sal emp.sal%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Reajuste Analistas - Dept 20 ===');

  FOR r IN c_analistas LOOP
    v_novo_sal := r.sal * 1.15;  -- 15% de aumento

    -- WHERE CURRENT OF referencia exatamente a linha atual do cursor
    -- sem precisar repetir WHERE empno = r.empno
    UPDATE emp
    SET    sal = v_novo_sal
    WHERE  CURRENT OF c_analistas;

    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(r.ename), 12)
      || 'SAL: ' || r.sal || ' -> ' || v_novo_sal);
  END LOOP;

  ROLLBACK;  -- desfaz para não alterar dados de teste
  DBMS_OUTPUT.PUT_LINE('ROLLBACK aplicado - dados restaurados.');
END;
/

-- ============================================================
-- SEÇÃO 2: FOR UPDATE OF coluna (em joins e tabelas múltiplas)
-- ============================================================
-- Quando o cursor envolve mais de uma tabela (JOIN), o FOR UPDATE
-- sem OF bloqueia linhas em TODAS as tabelas.
-- FOR UPDATE OF coluna bloqueia apenas a tabela que possui aquela
-- coluna. Mais preciso e menos restritivo para outras sessões.
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO 2: FOR UPDATE OF em cursor com JOIN
-- ------------------------------------------------------------
-- Cenário: cursor que une EMP e DEPT, mas só precisamos bloquear
-- EMP (para atualizar sal). DEPT não deve ser bloqueada.
-- ------------------------------------------------------------
DECLARE
  CURSOR c_emp_dept IS
    SELECT e.empno, e.ename, e.sal, d.dname
    FROM   emp  e
    JOIN   dept d ON d.deptno = e.deptno
    WHERE  e.sal < 2000
    FOR UPDATE OF e.sal;          -- bloqueia apenas linhas em EMP

  v_reajuste NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Reajuste - salarios abaixo de 2000 ===');

  FOR r IN c_emp_dept LOOP
    v_reajuste := r.sal * 1.10;

    UPDATE emp
    SET    sal = v_reajuste
    WHERE  CURRENT OF c_emp_dept;

    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(r.ename), 12)
      || RPAD(r.dname, 12)
      || TO_CHAR(r.sal, 'FM9990.00') || ' -> '
      || TO_CHAR(v_reajuste, 'FM9990.00'));
  END LOOP;

  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('ROLLBACK aplicado.');
END;
/

-- ============================================================
-- SEÇÃO 3: NOWAIT e WAIT n - comportamento sob contenção
-- ============================================================
-- Por padrão, FOR UPDATE espera indefinidamente se outra sessão
-- já mantiver lock na linha (comportamento bloqueante).
--
-- NOWAIT:  levanta ORA-00054 imediatamente se não conseguir lock
-- WAIT n:  espera até n segundos; se não conseguir, ORA-30006
--
-- Em produção, NOWAIT ou WAIT com tratamento de exceção é
-- essencial para evitar que blocos PL/SQL fiquem suspensos.
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO 3: FOR UPDATE NOWAIT com tratamento de exceção
-- ------------------------------------------------------------
DECLARE
  CURSOR c_sal IS
    SELECT empno, ename, sal
    FROM   emp
    WHERE  deptno = 10
    FOR UPDATE NOWAIT;     -- falha imediatamente se bloqueado

  v_rows NUMBER := 0;
BEGIN
  BEGIN
    FOR r IN c_sal LOOP
      UPDATE emp
      SET    sal = r.sal + 100
      WHERE  CURRENT OF c_sal;
      v_rows := v_rows + 1;
    END LOOP;

    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Atualizadas ' || v_rows || ' linha(s). ROLLBACK aplicado.');

  EXCEPTION
    WHEN OTHERS THEN
      -- ORA-00054: resource busy and acquire with NOWAIT specified
      -- ORA-30006: resource busy; acquire with WAIT timeout expired
      IF SQLCODE IN (-54, -30006) THEN
        DBMS_OUTPUT.PUT_LINE('AVISO: Linhas bloqueadas por outra sessao.');
        DBMS_OUTPUT.PUT_LINE('SQLCODE = ' || SQLCODE);
        ROLLBACK;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 3b: FOR UPDATE WAIT n - onde aparecem os n segundos
-- ------------------------------------------------------------
-- O n fica escrito no próprio cursor: FOR UPDATE WAIT 5 = até 5 segundos.
-- Para ver a espera numa sessão só, o bloco:
--   1. bloqueia o dept 10 com um UPDATE (transação principal, sem COMMIT);
--   2. chama uma procedure local com PRAGMA AUTONOMOUS_TRANSACTION.
--      Ela é uma transação SEPARADA, como se fosse outra sessão;
--   3. o cursor dela tenta travar as mesmas linhas com WAIT 5,
--      espera 5 segundos e recebe ORA-30006.
-- A saída mostra o tempo que ela ficou esperando.
-- Para demonstrar com DUAS sessões: na sessão A rode
--   UPDATE emp SET sal = sal WHERE deptno = 10;   (sem COMMIT)
-- e na sessão B abra um cursor com FOR UPDATE WAIT 5 no dept 10.
-- Depois, ROLLBACK na sessão A.
-- ------------------------------------------------------------
DECLARE
  PROCEDURE tenta_travar IS
    PRAGMA AUTONOMOUS_TRANSACTION;   -- outra transação: não enxerga o lock como dela
    CURSOR c_sal IS
      SELECT empno, ename, sal
      FROM   emp
      WHERE  deptno = 10
      FOR UPDATE WAIT 5;             -- <== aqui está o n: espera até 5 segundos
    v_inicio TIMESTAMP := SYSTIMESTAMP;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Abrindo cursor com FOR UPDATE WAIT 5...');
    OPEN c_sal;                      -- o lock é pedido no OPEN: é aqui que espera
    CLOSE c_sal;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Conseguiu o lock (ninguem estava segurando as linhas).');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -30006 THEN
        DBMS_OUTPUT.PUT_LINE('ORA-30006 depois de '
          || TO_CHAR(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_inicio)), 'FM990.00')
          || ' segundos de espera.');
        ROLLBACK;
      ELSE
        ROLLBACK;
        RAISE;
      END IF;
  END tenta_travar;
BEGIN
  UPDATE emp SET sal = sal WHERE deptno = 10;   -- trava as linhas do dept 10
  DBMS_OUTPUT.PUT_LINE('Transacao principal travou ' || SQL%ROWCOUNT || ' linha(s) do dept 10.');

  tenta_travar;

  ROLLBACK;                                      -- libera o lock da transação principal
  DBMS_OUTPUT.PUT_LINE('ROLLBACK aplicado - lock liberado.');
END;
/

-- ============================================================
-- SEÇÃO 4: WHERE CURRENT OF vs WHERE chave_primaria
-- ============================================================
-- Qual a diferença prática?
--
-- WHERE empno = r.empno          <- precisa da chave, mais código
-- WHERE CURRENT OF cursor_nome   <- referencia direta, mais limpo
--
-- WHERE CURRENT OF:
--   + mais simples e legivel
--   + não precisa conhecer a chave primária da tabela
--   + garante que atualiza exatamente a linha que o cursor aponta
--   - só funciona com cursores que tenham FOR UPDATE
--   - não funciona em cursors baseados em views complexas
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO 4: DELETE com WHERE CURRENT OF
-- ------------------------------------------------------------
-- Cenário: remover os funcionários com comissão negativa (dado inválido)
-- sem precisar referenciar a PK no DELETE.
-- ATENÇÃO: DELETE ... WHERE CURRENT OF apaga a LINHA INTEIRA do funcionário,
-- não só a comissão. Para zerar apenas a comissão seria:
--   UPDATE emp SET comm = NULL WHERE CURRENT OF c_comm_negativa;
-- Na SCOTT.EMP padrão não há comissão negativa. Por isso o bloco primeiro CRIA
-- o dado inválido (MARTIN com comm = -100) e só depois abre o cursor.
-- O ROLLBACK no fim desfaz tudo: o UPDATE de preparação e o DELETE.
-- ------------------------------------------------------------
DECLARE
  CURSOR c_comm_negativa IS
    SELECT empno, ename, comm
    FROM   emp
    WHERE  comm IS NOT NULL
    AND    comm < 0
    FOR UPDATE OF comm;

  v_deleted NUMBER := 0;
BEGIN
  -- Preparação do teste: gera uma comissão inválida (desfeita pelo ROLLBACK)
  UPDATE emp SET comm = -100 WHERE empno = 7654;
  DBMS_OUTPUT.PUT_LINE('Preparando o teste: MARTIN agora tem comm = -100');

  -- O FOR abre o cursor AQUI, depois do UPDATE: a mesma transação já enxerga a mudança
  FOR r IN c_comm_negativa LOOP
    DBMS_OUTPUT.PUT_LINE('Removendo funcionario com comissao invalida: ' || r.ename
      || ' (comm=' || r.comm || ')');

    DELETE FROM emp
    WHERE  CURRENT OF c_comm_negativa;

    v_deleted := v_deleted + 1;
  END LOOP;

  IF v_deleted = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Nenhuma comissao invalida encontrada.');
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_deleted || ' linha(s) removida(s).');
  END IF;

  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('ROLLBACK aplicado.');
END;
/

-- ============================================================
-- SEÇÃO 5: PEGADINHAS E PONTOS DE ATENÇÃO
-- ============================================================

-- PEGADINHA 1: FOR UPDATE não pode ser usado com DISTINCT, GROUP BY,
-- agregações, ou subconsultas na cláusula FROM.
-- O bloco abaixo ilustra o erro se tentado:
/*
CURSOR c_errado IS
  SELECT deptno, AVG(sal) AS media
  FROM   emp
  GROUP  BY deptno
  FOR UPDATE;  -- ORA-01786: FOR UPDATE of this query expression is not allowed
*/

-- PEGADINHA 2: Cursor FOR loop com FOR UPDATE - o loop fecha o cursor
-- automaticamente, mas o lock só é liberado no COMMIT ou ROLLBACK.
-- Não assuma que o CLOSE libera o lock!

-- PEGADINHA 3: WHERE CURRENT OF requer que o cursor seja
-- declarado com FOR UPDATE. Sem FOR UPDATE, o bloco nem compila:
-- PLS-00404: cursor 'C_SEM_LOCK' must be declared with FOR UPDATE to use with CURRENT OF
/*
DECLARE
  CURSOR c_sem_lock IS SELECT empno FROM emp;
BEGIN
  FOR r IN c_sem_lock LOOP
    UPDATE emp SET sal = 9999 WHERE CURRENT OF c_sem_lock; -- PLS-00404
  END LOOP;
END;
/
*/

-- PEGADINHA 4: Em ambiente RAC (Real Application Clusters),
-- FOR UPDATE pode causar bloqueios entre nós se a sessão migrar.
-- Prefira transações curtas com COMMIT rápido.

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
-- Verificar que todos os rollbacks foram aplicados
SELECT empno, ename, sal, comm
FROM   emp
WHERE  deptno IN (10, 20)
ORDER  BY deptno, ename;
