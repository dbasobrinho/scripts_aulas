-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_06  |  Slide 08
-- Tema: Laços aninhados e labels
-- Versão: 1.0  |  2026-04-26
-- =============================================================================

SET SERVEROUTPUT ON

-- Loops aninhados com labels
BEGIN
  <<externo>>
  FOR linha IN 1..3 LOOP
    <<interno>>
    FOR col IN 1..4 LOOP
      IF col = 3 THEN
        CONTINUE externo;  -- pula col 3 e 4 e vai para proxima linha
      END IF;
      DBMS_OUTPUT.PUT_LINE('Linha ' || linha || ' | Col ' || col);
    END LOOP interno;
  END LOOP externo;
END;
/

-- EXIT com label - sai do loop externo a partir do interno
DECLARE
  v_encontrado BOOLEAN := FALSE;
BEGIN
  <<busca>>
  FOR i IN 1..5 LOOP
    FOR j IN 1..5 LOOP
      IF i = 3 AND j = 2 THEN
        DBMS_OUTPUT.PUT_LINE('Encontrado em i=' || i || ' j=' || j);
        EXIT busca;  -- sai de ambos os loops
      END IF;
    END LOOP;
  END LOOP busca;
  DBMS_OUTPUT.PUT_LINE('Busca concluida.');
END;
/
