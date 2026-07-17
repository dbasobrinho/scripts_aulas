-- =============================================================================
-- MÓDULO 03 - Gabarito 09  |  Labels em loops aninhados
-- =============================================================================

-- Resposta: B
--
-- EXIT externo sai do loop rotulado como <<externo>>.
-- Executará: i=1 j=1..5 (completo), depois i=2 j=1 e j=2.
-- Quando i=2 e j=3 a condição é true: EXIT externo encerra AMBOS os loops.
-- Próxima instrução executada é o DBMS_OUTPUT.PUT_LINE('Fim').

-- SET SERVEROUTPUT ON

-- BEGIN
--   <<externo>>
--   FOR i IN 1..3 LOOP
--     FOR j IN 1..5 LOOP
--       IF i = 2 AND j = 3 THEN EXIT externo; END IF;
--       DBMS_OUTPUT.PUT_LINE('i=' || i || ' j=' || j);
--     END LOOP;
--   END LOOP externo;
--   DBMS_OUTPUT.PUT_LINE('Fim');
-- END;
-- /
