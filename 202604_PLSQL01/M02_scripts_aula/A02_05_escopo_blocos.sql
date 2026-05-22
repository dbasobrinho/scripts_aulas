-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_05  |  Slide 07
-- Tema: Escopo de variáveis e blocos aninhados
-- Versão: 1.0  |  2026-04-26
-- Pré-req: A02_01
-- =============================================================================
-- O QUE DEMONSTRA:
--   Variáveis do bloco externo são visíveis no bloco interno.
--   Variáveis do bloco interno NÃO são visíveis no bloco externo.
--   Nome duplicado: bloco interno usa a variável local.
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_escopo   VARCHAR2(20) := 'externo';
  v_contador NUMBER       := 10;
BEGIN
  DBMS_OUTPUT.PUT_LINE('-- BLOCO EXTERNO --');
  DBMS_OUTPUT.PUT_LINE('v_escopo   = ' || v_escopo);
  DBMS_OUTPUT.PUT_LINE('v_contador = ' || v_contador);

  -- Bloco interno
  DECLARE
    v_interno  VARCHAR2(20) := 'interno';
    v_contador NUMBER       := 99;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('-- BLOCO INTERNO --');
    DBMS_OUTPUT.PUT_LINE('v_escopo   = ' || v_escopo);
    DBMS_OUTPUT.PUT_LINE('v_interno  = ' || v_interno);
    DBMS_OUTPUT.PUT_LINE('v_contador = ' || v_contador);
  END;

  DBMS_OUTPUT.PUT_LINE('-- DE VOLTA AO EXTERNO --');
  DBMS_OUTPUT.PUT_LINE('v_escopo   = ' || v_escopo);
  DBMS_OUTPUT.PUT_LINE('v_contador = ' || v_contador);

  -- v_interno aqui causaria: PLS-00201: identifier 'V_INTERNO' must be declared
  -- DBMS_OUTPUT.PUT_LINE(v_interno);
END;
/
