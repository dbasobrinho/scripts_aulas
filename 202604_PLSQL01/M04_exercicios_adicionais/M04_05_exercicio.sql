-- =============================================================================
-- MÓDULO 04 - Exercício 05
-- Tema: Cursor FOR LOOP com cálculo de media salarial por departamento
-- Tipo: Código
-- Nível: Intermediário
-- Schema: EMP, DEPT
-- =============================================================================
-- TAREFA:
-- Escreva um bloco anônimo que:
--   1. Percorra todos os departamentos (DEPT) com cursor FOR LOOP
--   2. Para cada departamento, calcule a media salarial dos funcionários (EMP)
--      usando um segundo cursor FOR LOOP aninhado
--   3. Exiba: DEPTNO, DNAME, quantidade de funcionários e media salarial
--   4. Se o departamento não tiver funcionários, exiba "Sem funcionários"
--   5. Use apenas cursor FOR LOOP (sem OPEN/FETCH/CLOSE manual)
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   v_count NUMBER;
--   v_soma  NUMBER;
-- BEGIN
--   FOR r_dept IN (SELECT deptno, dname FROM dept ORDER BY deptno) LOOP

--     v_count := 0;
--     v_soma  := 0;

--     FOR r_emp IN (SELECT sal FROM emp WHERE deptno = ...) LOOP
--       v_count := ...;
--       v_soma  := ...;
--     END LOOP;

--     IF v_count = 0 THEN
--       DBMS_OUTPUT.PUT_LINE(r_dept.deptno || ' - ' || RPAD(r_dept.dname, 12) || ' Sem funcionarios');
--     ELSE
--       DBMS_OUTPUT.PUT_LINE(
--         r_dept.deptno || ' - ' || RPAD(r_dept.dname, 12) ||
--         ' Func: ' || LPAD(v_count, 2) ||
--         '  Media: ' || TO_CHAR(v_soma / v_count, 'FM$99990.00')
--       );
--     END IF;

--   END LOOP;
-- END;
-- /
