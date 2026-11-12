-- =============================================================================
-- MÓDULO 04 - Gabarito 09
-- Tema: Cursor parametrizado por departamento e cargo
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_filtro (p_deptno NUMBER, p_job VARCHAR2) IS
--     SELECT empno, ename, sal
--     FROM   emp
--     WHERE  deptno = p_deptno
--     AND    job    = p_job
--     ORDER  BY ename;

--   v_rec c_filtro%ROWTYPE;

--   PROCEDURE exibe_grupo (p_deptno NUMBER, p_job VARCHAR2) IS
--   BEGIN
--     DBMS_OUTPUT.PUT_LINE('=== DEPT ' || p_deptno || ' / ' || p_job || ' ===');
--     OPEN c_filtro(p_deptno, p_job);
--     LOOP
--       FETCH c_filtro INTO v_rec;
--       EXIT WHEN c_filtro%NOTFOUND;
--       DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_rec.ename), 12) || TO_CHAR(v_rec.sal, 'FM$99990.00'));
--     END LOOP;
--     CLOSE c_filtro;
--   END exibe_grupo;

-- BEGIN
--   exibe_grupo(30, 'SALESMAN');
--   exibe_grupo(10, 'MANAGER');
-- END;
-- /
