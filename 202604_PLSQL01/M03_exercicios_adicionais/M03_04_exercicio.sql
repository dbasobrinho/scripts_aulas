-- =============================================================================
-- MÓDULO 03 - Exercício 04
-- Tema: FOR LOOP com EMP - tabela de aumentos
-- Tipo: Código
-- Nível: Básico
-- Requer: Schema EMP
-- =============================================================================
-- TAREFA:
-- Use FOR LOOP com cursor implícito para percorrer EMP.
-- Para cada funcionário exiba:
--   Nome, Salário atual, Aumento de 10%, Novo salário
-- Inclua cabeçalho formatado com RPAD/LPAD.
-- =============================================================================

-- SET SERVEROUTPUT ON

-- BEGIN
--   DBMS_OUTPUT.PUT_LINE(
--     RPAD('Nome',12) || ' | ' || LPAD('Atual',8) || ' | ' || LPAD('+10%',7) || ' | ' || LPAD('Novo',8));
--   DBMS_OUTPUT.PUT_LINE(RPAD('-', 46, '-'));

--   FOR r IN (...) LOOP
--     DBMS_OUTPUT.PUT_LINE(
--       RPAD(INITCAP(r.ename), 12) || ' | ' ||
--       LPAD(TO_CHAR(r.sal,'FM9990.00'), 8) || ' | ' ||
--       LPAD(TO_CHAR(...), 7) || ' | ' ||
--       LPAD(TO_CHAR(...), 8));
--   END LOOP;
-- END;
-- /
