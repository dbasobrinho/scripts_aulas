-- =============================================================================
-- MÓDULO 04 - Exercício 10 (Integrador)
-- Tema: SYS_REFCURSOR - retorno de conjunto de dados dinâmico
-- Tipo: Código
-- Nível: Avançado
-- Schema: EMP
-- =============================================================================
-- TAREFA:
-- Escreva um bloco anônimo que:
--   1. Declare uma procedure local RELATORIO_DEPT com p_deptno IN e p_cur OUT SYS_REFCURSOR
--   2. A procedure abre o cursor para SELECT ename, job, sal WHERE deptno = p_deptno
--   3. No bloco principal, chame a procedure para dept 20 e dept 30
--   4. Percorra cada cursor recebido e exiba os dados
--   5. Feche cada cursor após o loop
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
--       WHERE  deptno = ...
--       ORDER  BY ename;
--   END relatorio_dept;

-- BEGIN
--   relatorio_dept(..., v_cur1);
--   relatorio_dept(..., v_cur2);

--   DBMS_OUTPUT.PUT_LINE('=== DEPT 20 ===');
--   LOOP
--     FETCH v_cur1 INTO ...;
--     EXIT WHEN v_cur1%NOTFOUND;
--     DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_ename), 12) || RPAD(v_job, 12) || TO_CHAR(v_sal, 'FM$99990.00'));
--   END LOOP;
--   CLOSE ...;

--   DBMS_OUTPUT.PUT_LINE('=== DEPT 30 ===');
--   LOOP
--     FETCH v_cur2 INTO ...;
--     EXIT WHEN v_cur2%NOTFOUND;
--     DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_ename), 12) || RPAD(v_job, 12) || TO_CHAR(v_sal, 'FM$99990.00'));
--   END LOOP;
--   CLOSE ...;
-- END;
-- /
