-- =============================================================================
-- MÓDULO 03 - Gabarito 07  |  Diferença LOOP vs WHILE
-- =============================================================================

-- Resposta: A
--
-- LOOP/EXIT WHEN: a condição de saída é verificada DENTRO do loop.
-- O bloco sempre executa pelo menos 1 vez antes de testar a condição.
--
-- WHILE LOOP: a condição é verificada ANTES da primeira iteração.
-- Se for falsa de imediato, o corpo não executa nenhuma vez.
--
-- B) ERRADO: desempenho é equivalente
-- C) ERRADO: LOOP aceita EXIT WHEN normalmente
-- D) ERRADO: WHILE pode ter EXIT dentro do corpo

-- SET SERVEROUTPUT ON

-- DECLARE v_x NUMBER := 100;
-- BEGIN
--   WHILE v_x < 10 LOOP
--     DBMS_OUTPUT.PUT_LINE('Nunca executa');
--   END LOOP;
--   DBMS_OUTPUT.PUT_LINE('WHILE: 0 iteracoes pois v_x ja era 100');
-- END;
-- /
