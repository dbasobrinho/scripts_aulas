-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_05  |  Slide 07
-- Tema: FOR LOOP numérico - contador automático
-- Versão: 1.0  |  2026-04-26
-- =============================================================================

SET SERVEROUTPUT ON

-- FOR LOOP normal
BEGIN
  FOR i IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE('Iteracao ' || i || ' de 5');
  END LOOP;
END;
/

-- FOR LOOP com REVERSE
BEGIN
  FOR i IN REVERSE 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE('Contagem regressiva: ' || i);
  END LOOP;
END;
/

-- FOR LOOP com calculo
DECLARE
  v_quadrado NUMBER;
BEGIN
  FOR n IN 1..10 LOOP
    v_quadrado := n * n;
    DBMS_OUTPUT.PUT_LINE(LPAD(n,2) || ' ^ 2 = ' || LPAD(v_quadrado,4));
  END LOOP;
END;
/
