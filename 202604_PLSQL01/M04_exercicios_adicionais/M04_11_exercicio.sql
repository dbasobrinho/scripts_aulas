-- =============================================================================
-- MÓDULO 04 - Exercício 11
-- Tema: FOR UPDATE e WHERE CURRENT OF - reajuste salarial com lock
-- Tipo: Código
-- Nível: Intermediário
-- Schema: EMP
-- Ref: 1Z0-149 Topic 6 - FOR UPDATE / WHERE CURRENT OF
-- =============================================================================
-- TAREFA:
-- Escreva um bloco anônimo que:
--   1. Declare um cursor que selecione EMPNO, ENAME, SAL e DEPTNO de EMP
--      apenas para funcionários cujo SAL esteja entre 1000 e 3000
--      Use FOR UPDATE OF sal com NOWAIT
--   2. Itere sobre o cursor usando cursor FOR loop
--   3. Para cada linha, aplique o seguinte reajuste usando WHERE CURRENT OF:
--      - SAL < 1500: reajuste de 20%
--      - SAL entre 1500 e 2500: reajuste de 10%
--      - SAL > 2500: reajuste de 5%
--   4. Exiba o nome, salário original e novo salário de cada funcionário
--   5. Ao final, exiba quantos funcionários foram reajustados por faixa
--   6. Aplique ROLLBACK ao final para não alterar os dados de teste
-- =============================================================================
-- DICAS:
--   - Use um cursor FOR loop (não precisa de OPEN/FETCH/CLOSE explícito)
--   - FOR UPDATE OF sal bloqueia apenas a tabela EMP, não DEPT
--   - WHERE CURRENT OF dispensa o WHERE empno = r.empno no UPDATE
--   - Declare contadores separados para cada faixa salarial
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_reajuste IS
--     SELECT empno, ename, sal, deptno
--     FROM   emp
--     WHERE  sal BETWEEN ... AND ...
--     FOR UPDATE OF sal NOWAIT;

--   v_novo_sal  emp.sal%TYPE;
--   v_cnt_baixo NUMBER := 0;
--   v_cnt_medio NUMBER := 0;
--   v_cnt_alto  NUMBER := 0;
-- BEGIN
--   DBMS_OUTPUT.PUT_LINE('=== Reajuste Salarial por Faixa ===');
--   DBMS_OUTPUT.PUT_LINE(RPAD('Nome',       12) ||
--                        RPAD('Sal Atual',  12) ||
--                        RPAD('Sal Novo',   12) ||
--                        'Faixa');

--   FOR r IN c_reajuste LOOP

--     IF r.sal < 1500 THEN
--       v_novo_sal := ...;  -- 20%
--       v_cnt_baixo := v_cnt_baixo + 1;
--     ELSIF r.sal <= 2500 THEN
--       v_novo_sal := ...;  -- 10%
--       v_cnt_medio := v_cnt_medio + 1;
--     ELSE
--       v_novo_sal := ...;  -- 5%
--       v_cnt_alto := v_cnt_alto + 1;
--     END IF;

--     UPDATE emp
--     SET    sal = v_novo_sal
--     WHERE  CURRENT OF ...;

--     DBMS_OUTPUT.PUT_LINE(
--       RPAD(INITCAP(r.ename), 12) ||
--       RPAD(TO_CHAR(r.sal,       'FM9990.00'), 12) ||
--       RPAD(TO_CHAR(v_novo_sal,  'FM9990.00'), 12) ||
--       CASE WHEN r.sal < 1500  THEN 'Baixo (20%)'
--            WHEN r.sal <= 2500 THEN 'Medio (10%)'
--            ELSE                    'Alto  (5%)'
--       END
--     );
--   END LOOP;

--   DBMS_OUTPUT.PUT_LINE('');
--   DBMS_OUTPUT.PUT_LINE('Resumo:');
--   DBMS_OUTPUT.PUT_LINE('  Faixa Baixo (<1500):        ' || v_cnt_baixo || ' funcionario(s)');
--   DBMS_OUTPUT.PUT_LINE('  Faixa Medio (1500-2500):    ' || v_cnt_medio || ' funcionario(s)');
--   DBMS_OUTPUT.PUT_LINE('  Faixa Alto  (>2500):        ' || v_cnt_alto  || ' funcionario(s)');

--   ROLLBACK;
--   DBMS_OUTPUT.PUT_LINE('');
--   DBMS_OUTPUT.PUT_LINE('ROLLBACK aplicado - dados restaurados.');
-- END;
-- /
