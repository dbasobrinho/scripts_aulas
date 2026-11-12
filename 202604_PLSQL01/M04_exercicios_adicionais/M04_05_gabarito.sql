-- =============================================================================
-- MÓDULO 04 - Gabarito 05
-- Tema: Cursor FOR LOOP com cálculo de media salarial por departamento
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   v_count NUMBER;
--   v_soma  NUMBER;
-- BEGIN
--   FOR r_dept IN (SELECT deptno, dname FROM dept ORDER BY deptno) LOOP

--     v_count := 0;
--     v_soma  := 0;

--     FOR r_emp IN (SELECT sal FROM emp WHERE deptno = r_dept.deptno) LOOP
--       v_count := v_count + 1;
--       v_soma  := v_soma + r_emp.sal;
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
-- Resultado esperado (schema EMP padrao):
-- 10 - ACCOUNTING   Func:  3  Media: $2916.67
-- 20 - RESEARCH     Func:  5  Media: $2175.00
-- 30 - SALES        Func:  6  Media: $1566.67
-- 40 - OPERATIONS   Sem funcionarios
