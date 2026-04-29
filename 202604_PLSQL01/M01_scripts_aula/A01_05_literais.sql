-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_05 | Literais em PL/SQL

-- ============================================================================
-- Objetivo: demonstrar os quatro tipos de literais em PL/SQL.
-- ============================================================================
-- Literais correspondem a representacao explicita de um valor. 
-- Tipos: NUMERO, CARACTER, STRING, BOLEANO
-- ============================================================================

SET SERVEROUTPUT ON

DECLARE
   -- -------------------------------------------------------------------------
   -- NUMERO 
   -- Inteiros: {3, 100, 017, -125, +096}
   -- Reais:    {12.5, +020.30, .78, 17., -05.32}
   -- Notacao cientifica: 12E3 (= 12*10^3 = 12000), 500e-4 (= 500/10000 = .05)
   -- -------------------------------------------------------------------------
   v_inteiro    NUMBER := 100;
   v_real       NUMBER := 12.5;
   v_negativo   NUMBER := -125;
   v_cientifico NUMBER := 12E3;      -- 12000
   v_cient2     NUMBER := 500e-4;    -- 0.05

   -- -------------------------------------------------------------------------
   -- CARACTER 
   -- Um unico caracter entre apostrofos. PL/SQL e sensivel a forma.
   -- 'A' e 'a' sao diferentes.
   -- -------------------------------------------------------------------------
   v_char1      CHAR(1) := '$';
   v_char2      CHAR(1) := 'S';
   v_char3      CHAR(1) := '8';

   -- -------------------------------------------------------------------------
   -- STRING 
   -- Sequencia de zero ou mais caracteres entre apostrofos.
   -- -------------------------------------------------------------------------
   v_string1    VARCHAR2(20) := 'abc';
   v_string2    VARCHAR2(20) := 'ABC';
   v_string3    VARCHAR2(30) := '$5.000,00';
   v_string4    VARCHAR2(40) := 'aspas " duplas';

   -- -------------------------------------------------------------------------
   -- BOLEANO 
   -- Valores TRUE, FALSE e NULL.
   -- -------------------------------------------------------------------------
   v_bool_true  BOOLEAN := TRUE;
   v_bool_false BOOLEAN := FALSE;
   v_bool_null  BOOLEAN := NULL;

BEGIN
   DBMS_OUTPUT.PUT_LINE('--- LITERAIS NUMERICOS ---');
   DBMS_OUTPUT.PUT_LINE('Inteiro     : ' || v_inteiro);
   DBMS_OUTPUT.PUT_LINE('Real        : ' || v_real);
   DBMS_OUTPUT.PUT_LINE('Negativo    : ' || v_negativo);
   DBMS_OUTPUT.PUT_LINE('12E3        : ' || v_cientifico);
   DBMS_OUTPUT.PUT_LINE('500e-4      : ' || v_cient2);

   DBMS_OUTPUT.PUT_LINE('--- LITERAIS CARACTER ---');
   DBMS_OUTPUT.PUT_LINE('Char1 ($)   : ' || v_char1);
   DBMS_OUTPUT.PUT_LINE('Char2 (S)   : ' || v_char2);
   DBMS_OUTPUT.PUT_LINE('Char3 (8)   : ' || v_char3);

   DBMS_OUTPUT.PUT_LINE('--- LITERAIS STRING ---');
   DBMS_OUTPUT.PUT_LINE('String1     : ' || v_string1);
   DBMS_OUTPUT.PUT_LINE('String2     : ' || v_string2);
   DBMS_OUTPUT.PUT_LINE('String3     : ' || v_string3);
   DBMS_OUTPUT.PUT_LINE('String4     : ' || v_string4);

   DBMS_OUTPUT.PUT_LINE('--- LITERAIS BOLEANOS ---');
   -- BOOLEAN nao pode ser concatenado diretamente com VARCHAR2.
   -- Usamos IF para exibir.
   IF v_bool_true  THEN DBMS_OUTPUT.PUT_LINE('v_bool_true  : TRUE');  END IF;
   IF NOT v_bool_false THEN DBMS_OUTPUT.PUT_LINE('v_bool_false : FALSE (NOT e TRUE)'); END IF;
   IF v_bool_null IS NULL THEN DBMS_OUTPUT.PUT_LINE('v_bool_null  : NULL'); END IF;
END;
/
