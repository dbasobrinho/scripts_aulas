-- =============================================================================
-- MÓDULO 04 - Gabarito 10 (Integrador)
-- Tema: SYS_REFCURSOR - retorno de conjunto de dados dinâmico
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   v_cur1  SYS_REFCURSOR;
--   v_cur2  SYS_REFCURSOR;
--   v_ename emp.ename%TYPE;
--   v_job   emp.job%TYPE;
--   v_sal   emp.sal%TYPE;

--   PROCEDURE relatorio_dept (p_deptno IN NUMBER, p_cur OUT SYS_REFCURSOR) IS
--   BEGIN
--     OPEN p_cur FOR
--       SELECT ename, job, sal
--       FROM   emp
--       WHERE  deptno = p_deptno
--       ORDER  BY ename;
--   END relatorio_dept;

-- BEGIN
--   relatorio_dept(20, v_cur1);
--   relatorio_dept(30, v_cur2);

--   DBMS_OUTPUT.PUT_LINE('=== DEPT 20 ===');
--   LOOP
--     FETCH v_cur1 INTO v_ename, v_job, v_sal;
--     EXIT WHEN v_cur1%NOTFOUND;
--     DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_ename), 12) || RPAD(v_job, 12) || TO_CHAR(v_sal, 'FM$99990.00'));
--   END LOOP;
--   CLOSE v_cur1;

--   DBMS_OUTPUT.PUT_LINE('=== DEPT 30 ===');
--   LOOP
--     FETCH v_cur2 INTO v_ename, v_job, v_sal;
--     EXIT WHEN v_cur2%NOTFOUND;
--     DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_ename), 12) || RPAD(v_job, 12) || TO_CHAR(v_sal, 'FM$99990.00'));
--   END LOOP;
--   CLOSE v_cur2;
-- END;
-- /
-- Resultado esperado (dept 20): Adams, Ford, Jones, Scott, Smith
-- Resultado esperado (dept 30): Allen, Blake, James, Martin, Turner, Ward
