-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_01 |  - Estrutura do Bloco PL/SQL

-- ============================================================================
-- Objetivo: apresentar a estrutura basica de um bloco PL/SQL
--           conforme  .
-- ============================================================================

SET SERVEROUTPUT ON

-- ----------------------------------------------------------------------------
--  - Bloco de PL/SQL 
--
-- Um bloco PL/SQL e composto de tres partes:
--
--   [ DECLARE
--       declaracoes de variaveis, constantes, cursores ]
--   BEGIN
--       logica do bloco (comandos SQL e PL/SQL)
--       [ blocos subordinados (embutidos) ]
--   [ EXCEPTION
--       tratamento de erros ]
--   END;
--   /
--
-- Partes obrigatorias: BEGIN ... END;
-- Partes opcionais:    DECLARE  e  EXCEPTION
-- ----------------------------------------------------------------------------

-- Exemplo 1: bloco minimo (apenas BEGIN/END - sem DECLARE nem EXCEPTION)
BEGIN
   NULL;
END;
/

-- Exemplo 2: bloco com secao DECLARE
DECLARE
   v_nome   VARCHAR2(30) := 'PL/SQL';
BEGIN
   DBMS_OUTPUT.PUT_LINE('Linguagem: ' || v_nome);
END;
/

-- Exemplo 3: bloco completo com DECLARE, BEGIN e EXCEPTION
DECLARE
   v_valor   NUMBER := 10;
BEGIN
   DBMS_OUTPUT.PUT_LINE('Valor: ' || v_valor);
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- Observacao sobre FIM DE LINHA :
-- A indicacao de fim de comando em PL/SQL e feita com ponto-e-virgula (;).
-- No SQL*Plus:
--   - A barra (/) em linha separada encerra E executa o bloco.
--   - O ponto (.) em linha separada encerra sem executar.
-- ----------------------------------------------------------------------------
