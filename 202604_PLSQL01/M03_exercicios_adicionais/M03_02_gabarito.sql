-- =============================================================================
-- MÓDULO 03 - Gabarito 02
-- Tema: Comportamento do contador no FOR LOOP
-- =============================================================================

-- Resposta: B
--
-- O contador do FOR LOOP é implicitamente declarado como CONSTANT.
-- Qualquer tentativa de atribuição gera erro em tempo de compilação:
-- PLS-00363: expression 'I' cannot be used as an assignment target
--
-- Para iterar com passo diferente de 1, use um WHILE LOOP com variável auxiliar.

-- SET SERVEROUTPUT ON

-- Solução para passo 2 usando WHILE LOOP:
-- DECLARE
--   v_i NUMBER := 1;
-- BEGIN
--   WHILE v_i <= 10 LOOP
--     DBMS_OUTPUT.PUT_LINE('Valor: ' || v_i);
--     v_i := v_i + 2;  -- passo de 2
--   END LOOP;
-- END;
-- /
