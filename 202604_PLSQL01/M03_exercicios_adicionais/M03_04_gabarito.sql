-- =============================================================================
-- MÓDULO 03 - Gabarito 04
-- Tema: FOR LOOP com EMP - tabela de aumentos
-- =============================================================================

-- SET SERVEROUTPUT ON

-- BEGIN
--   DBMS_OUTPUT.PUT_LINE(
--     RPAD('Nome',12) || ' | ' || LPAD('Atual',8) || ' | ' || LPAD('+10%',7) || ' | ' || LPAD('Novo',8));
--   DBMS_OUTPUT.PUT_LINE(RPAD('-', 46, '-'));

--   FOR r IN (SELECT ename, sal FROM emp ORDER BY ename) LOOP
--     DBMS_OUTPUT.PUT_LINE(
--       RPAD(INITCAP(r.ename), 12) || ' | ' ||
--       LPAD(TO_CHAR(r.sal,        'FM9990.00'), 8) || ' | ' ||
--       LPAD(TO_CHAR(r.sal * 0.10, 'FM9990.00'), 7) || ' | ' ||
--       LPAD(TO_CHAR(r.sal * 1.10, 'FM9990.00'), 8));
--   END LOOP;
-- END;
-- /
