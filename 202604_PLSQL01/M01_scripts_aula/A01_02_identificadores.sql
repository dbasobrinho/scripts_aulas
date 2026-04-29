-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_02 | - Identificadores

-- ============================================================================
-- Objetivo: demonstrar o comportamento de identificadores em PL/SQL,
--           incluindo identificadores entre aspas duplas (quoted identifiers).
-- ============================================================================
-- Regras de identificadores :
--   - Letra seguida de letras, numeros, $ (dolar), _ (sublinhado), # (num.)
--   - Limite maximo de 30 caracteres
--   - Nao sensivel a forma (maiusculas = minusculas) - exceto quando entre aspas
--   - Com aspas: pode usar outros caracteres; passa a ser sensivel a forma
-- ============================================================================

SET SERVEROUTPUT ON

-- ----------------------------------------------------------------------------
Identificadores 
-- 
-- Observe: "ABC DEF" na linha 8 causa erro porque foi declarado como "abc def"
-- (com aspas, a linguagem passa a ser sensivel a forma).
-- ----------------------------------------------------------------------------

-- OBS: execute apenas para ver o comportamento do compilador.
-- O bloco abaixo gera erro proposital .

DECLARE
   WTESTE        NUMBER;
   "ID DE FUNC"  NUMBER;
   "abc def"     NUMBER;
BEGIN
   WTESTE        := 10;
   "ID DE FUNC"  := 20;
   "ABC DEF"     := 30;   -- ERRO: declarado como "abc def" (minusculas)
END;
/

-- Resultado esperado ( p.252):
-- "ABC DEF"     := 30;
-- *
-- ERRO na linha 8:
-- ORA-06550: linha 8, coluna 3:
-- PLS-00201: o identificador 'ABC DEF' deve ser declarado

-- ----------------------------------------------------------------------------
-- Versao corrigida: usando exatamente o mesmo case da declaracao
-- ----------------------------------------------------------------------------
DECLARE
   WTESTE        NUMBER;
   "ID DE FUNC"  NUMBER;
   "abc def"     NUMBER;
BEGIN
   WTESTE        := 10;
   "ID DE FUNC"  := 20;
   "abc def"     := 30;   -- correto: mesmo case da declaracao
   DBMS_OUTPUT.PUT_LINE('WTESTE    = ' || WTESTE);
   DBMS_OUTPUT.PUT_LINE('ID DE FUNC = ' || "ID DE FUNC");
   DBMS_OUTPUT.PUT_LINE('abc def   = ' || "abc def");
END;
/
