-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_03  |  Slide 05
-- Tema: LOOP / EXIT WHEN - loop básico com saída condicional
-- Versão: 1.0  |  2026-04-26
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_contador NUMBER := 1;
  v_soma     NUMBER := 0;
BEGIN
  LOOP
    v_soma := v_soma + v_contador;
    DBMS_OUTPUT.PUT_LINE('Passo ' || v_contador || ' | Soma = ' || v_soma);
    v_contador := v_contador + 1;
    EXIT WHEN v_contador > 5;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Total acumulado: ' || v_soma);
END;
/
