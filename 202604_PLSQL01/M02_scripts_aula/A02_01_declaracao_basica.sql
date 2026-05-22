-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_01  |  Slide 03
-- Tema: Declaração de variáveis - sintaxe e regras
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01 concluído, SET SERVEROUTPUT ON
-- =============================================================================
-- O QUE DEMONSTRA:
--   Sintaxe completa de declaração de variáveis no DECLARE.
--   Identificadores válidos e inicialização com := e DEFAULT.
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_nome       VARCHAR2(50);
  v_salario    NUMBER(10,2) := 0;
  v_data       DATE         := SYSDATE;
  v_ativo      BOOLEAN      := TRUE;
  v_departamento CHAR(10)   := 'VENDAS';
  c_pi         CONSTANT NUMBER := 3.14159;
BEGIN
  v_nome    := 'Roberto';
  v_salario := 4500.75;

  DBMS_OUTPUT.PUT_LINE('Nome       : ' || v_nome);
  DBMS_OUTPUT.PUT_LINE('Salario    : ' || v_salario);
  DBMS_OUTPUT.PUT_LINE('Dept       : ' || v_departamento);
  DBMS_OUTPUT.PUT_LINE('Pi         : ' || c_pi);
  DBMS_OUTPUT.PUT_LINE('Data       : ' || TO_CHAR(v_data, 'DD/MM/YYYY'));

  IF v_ativo THEN
    DBMS_OUTPUT.PUT_LINE('Status     : Ativo');
  END IF;
END;
/
