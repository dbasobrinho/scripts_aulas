-- =============================================================================
-- MÓDULO 04 - Gabarito 04
-- Tema: Cursor explícito com OPEN/FETCH/CLOSE
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_dept20 IS
--     SELECT empno, ename, job, sal
--     FROM   emp
--     WHERE  deptno = 20
--     ORDER  BY ename;

--   v_empno  emp.empno%TYPE;
--   v_ename  emp.ename%TYPE;
--   v_job    emp.job%TYPE;
--   v_sal    emp.sal%TYPE;
-- BEGIN
--   OPEN c_dept20;

--   LOOP
--     FETCH c_dept20 INTO v_empno, v_ename, v_job, v_sal;
--     EXIT WHEN c_dept20%NOTFOUND;

--     DBMS_OUTPUT.PUT_LINE(
--       LPAD(v_empno, 6) || '  ' ||
--       RPAD(INITCAP(v_ename), 12) ||
--       RPAD(v_job, 12) ||
--       TO_CHAR(v_sal, 'FM$99990.00')
--     );
--   END LOOP;

--   DBMS_OUTPUT.PUT_LINE('---');
--   DBMS_OUTPUT.PUT_LINE('Total lido: ' || c_dept20%ROWCOUNT || ' linha(s).');

--   CLOSE c_dept20;
-- END;
-- /
-- Resultado esperado: Adams, Ford, Jones, Scott, Smith (5 linhas)
