-- ============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- Módulo M04 - Cursores
-- Desafio Final | GABARITO - Fechamento da Folha com Reajuste por Faixa
-- ============================================================================

SET SERVEROUTPUT ON

DECLARE
  -- 1. Cursor de departamentos (percorrido com FOR LOOP)
  CURSOR c_dept IS
    SELECT deptno, dname, loc
    FROM   dept
    ORDER  BY deptno;

  -- 2. Cursor parametrizado com lock nas linhas de EMP
  CURSOR c_emp (p_deptno dept.deptno%TYPE) IS
    SELECT empno, ename, sal
    FROM   emp
    WHERE  deptno = p_deptno
    ORDER  BY sal DESC, ename
    FOR UPDATE OF sal;

  r_emp      c_emp%ROWTYPE;      -- registro com a forma da linha do cursor
  v_pct      NUMBER;             -- percentual da faixa
  v_novo     emp.sal%TYPE;       -- salário reajustado

  -- acumuladores do departamento
  v_lidos    PLS_INTEGER;
  v_reaj     PLS_INTEGER;
  v_antes    NUMBER;
  v_depois   NUMBER;

  -- acumuladores gerais
  v_tot_func PLS_INTEGER := 0;
  v_tot_reaj PLS_INTEGER := 0;
  v_tot_aum  NUMBER      := 0;

  -- conferência final
  v_cur      SYS_REFCURSOR;
  v_folha    NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('FECHAMENTO DA FOLHA - SIMULACAO DE REAJUSTE');
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 52, '='));

  FOR r_dept IN c_dept LOOP
    DBMS_OUTPUT.PUT_LINE('DEPT ' || r_dept.deptno || ' - ' ||
                         r_dept.dname || ' (' || r_dept.loc || ')');
    v_reaj   := 0;
    v_antes  := 0;
    v_depois := 0;

    -- 3. Cursor explícito: OPEN / FETCH / CLOSE
    OPEN c_emp(r_dept.deptno);
    LOOP
      FETCH c_emp INTO r_emp;
      EXIT WHEN c_emp%NOTFOUND;          -- logo após o FETCH!

      -- 4. Regra da faixa
      CASE
        WHEN r_emp.sal < 1500 THEN v_pct := 10;
        WHEN r_emp.sal < 3000 THEN v_pct := 5;
        ELSE                       v_pct := 0;
      END CASE;

      v_novo := r_emp.sal * (1 + v_pct / 100);

      -- 5. Atualiza a linha corrente do cursor
      IF v_pct > 0 THEN
        UPDATE emp
        SET    sal = v_novo
        WHERE  CURRENT OF c_emp;
        v_reaj := v_reaj + SQL%ROWCOUNT;  -- cursor implícito do UPDATE
      END IF;

      v_antes  := v_antes  + r_emp.sal;
      v_depois := v_depois + v_novo;

      -- 6. Linha do funcionário
      DBMS_OUTPUT.PUT_LINE('  ' ||
        RPAD(INITCAP(r_emp.ename), 10) ||
        LPAD(TO_CHAR(r_emp.sal, 'FM99990.00'), 9) || ' -> ' ||
        LPAD(TO_CHAR(v_novo,    'FM99990.00'), 9) || '  ' ||
        CASE WHEN v_pct > 0 THEN '+' || v_pct || '%' ELSE 'sem reajuste' END);
    END LOOP;

    -- 7. %ROWCOUNT só pode ser lido com o cursor ABERTO
    v_lidos := c_emp%ROWCOUNT;
    CLOSE c_emp;

    IF v_lidos = 0 THEN
      DBMS_OUTPUT.PUT_LINE('  (sem funcionarios)');
    ELSE
      DBMS_OUTPUT.PUT_LINE('  Funcionarios: ' || v_lidos ||
                           ' | Reajustados: ' || v_reaj);
      DBMS_OUTPUT.PUT_LINE('  Folha antes: ' || TO_CHAR(v_antes, 'FM99990.00') ||
                           ' | depois: '     || TO_CHAR(v_depois, 'FM99990.00') ||
                           ' | aumento: '    || TO_CHAR(v_depois - v_antes, 'FM99990.00'));
    END IF;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 52, '-'));

    v_tot_func := v_tot_func + v_lidos;
    v_tot_reaj := v_tot_reaj + v_reaj;
    v_tot_aum  := v_tot_aum  + (v_depois - v_antes);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Total de funcionarios : ' || v_tot_func);
  DBMS_OUTPUT.PUT_LINE('Total reajustados     : ' || v_tot_reaj);
  DBMS_OUTPUT.PUT_LINE('Aumento total da folha: ' || TO_CHAR(v_tot_aum, 'FM99990.00'));

  -- 8. Desfaz tudo (e libera os locks do FOR UPDATE)
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('ROLLBACK executado - nada foi gravado.');

  -- Conferência com REF CURSOR
  OPEN v_cur FOR SELECT SUM(sal) FROM emp;
  FETCH v_cur INTO v_folha;
  CLOSE v_cur;
  DBMS_OUTPUT.PUT_LINE('Folha atual (REF CURSOR): ' || TO_CHAR(v_folha, 'FM99990.00'));
END;
/

-- ============================================================================
-- SAÍDA ESPERADA (schema SCOTT.EMP padrão, 14 funcionários)
-- O ORDER BY sal DESC, ename deixa a ordem deterministica (Ford antes de
-- Scott, Martin antes de Ward).
--
-- FECHAMENTO DA FOLHA - SIMULACAO DE REAJUSTE
-- ====================================================
-- DEPT 10 - ACCOUNTING (NEW YORK)
--   King        5000.00 ->   5000.00  sem reajuste
--   Clark       2450.00 ->   2572.50  +5%
--   Miller      1300.00 ->   1430.00  +10%
--   Funcionarios: 3 | Reajustados: 2
--   Folha antes: 8750.00 | depois: 9002.50 | aumento: 252.50
-- ----------------------------------------------------
-- DEPT 20 - RESEARCH (DALLAS)
--   Ford        3000.00 ->   3000.00  sem reajuste
--   Scott       3000.00 ->   3000.00  sem reajuste
--   Jones       2975.00 ->   3123.75  +5%
--   Adams       1100.00 ->   1210.00  +10%
--   Smith        800.00 ->    880.00  +10%
--   Funcionarios: 5 | Reajustados: 3
--   Folha antes: 10875.00 | depois: 11213.75 | aumento: 338.75
-- ----------------------------------------------------
-- DEPT 30 - SALES (CHICAGO)
--   Blake       2850.00 ->   2992.50  +5%
--   Allen       1600.00 ->   1680.00  +5%
--   Turner      1500.00 ->   1575.00  +5%
--   Martin      1250.00 ->   1375.00  +10%
--   Ward        1250.00 ->   1375.00  +10%
--   James        950.00 ->   1045.00  +10%
--   Funcionarios: 6 | Reajustados: 6
--   Folha antes: 9400.00 | depois: 10042.50 | aumento: 642.50
-- ----------------------------------------------------
-- DEPT 40 - OPERATIONS (BOSTON)
--   (sem funcionarios)
-- ----------------------------------------------------
-- Total de funcionarios : 14
-- Total reajustados     : 11
-- Aumento total da folha: 1233.75
-- ROLLBACK executado - nada foi gravado.
-- Folha atual (REF CURSOR): 29025.00
-- ============================================================================
-- RESPOSTAS DAS PERGUNTAS:
--   a) Depois do CLOSE, ler c_emp%ROWCOUNT (ou %FOUND/%NOTFOUND) dispara
--      INVALID_CURSOR (ORA-01001). Só %ISOPEN pode ser lido com o cursor
--      fechado. Por isso o valor vai para v_lidos antes do CLOSE.
--   b) O bloco nem compila: WHERE CURRENT OF exige cursor declarado com
--      FOR UPDATE -> PLS-00404.
--   c) No ROLLBACK (ou COMMIT). O CLOSE fecha o cursor mas NÃO libera os
--      locks: as linhas de EMP ficam presas até o fim da transação.
-- ============================================================================
