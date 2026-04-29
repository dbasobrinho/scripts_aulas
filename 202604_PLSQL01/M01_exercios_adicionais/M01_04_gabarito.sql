-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_04 | Identificadores - Regras

-- ============================================================================

-- IDENTIFICADORES VALIDOS: 1, 3, 5, 8
--
--   1)  v_salario      VALIDO: letra + sublinhado + letras
--   2)  1_nome         INVALIDO: comeca com numero (regra: deve comecar com letra)
--   3)  DEPT#CODE      VALIDO: letra + letras + # (permitido)
--   4)  emp-nome       INVALIDO: hifen (-) nao e permitido
--   5)  v$valor        VALIDO: letra + $ (permitido) + letras
--   6)  _descricao     INVALIDO: comecar com _ nao e "letra" - deve comecar com letra
--   7)  cod_func...    INVALIDO: ultrapassa 30 caracteres
--   8)  VNome          VALIDO: maiusculas e minusculas sao equivalentes (nao sensivel a forma)
--
-- Referencia :
-- "Um identificador consiste em uma letra seguida de outras letras,
--  numeros, $ (dolar), _ (sublinhado) e # (simbolo numerico).
--  Possui um limite maximo de 30 caracteres."

SET SERVEROUTPUT ON

DECLARE
   v_salario   NUMBER := 1000;
   DEPT_CODE   VARCHAR2(10) := 'TI';   -- equivalente a DEPT#CODE (sem #)
   v_valor     NUMBER := 500;
   VNome       VARCHAR2(20) := 'Oracle';
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_salario || ' | ' || DEPT_CODE || ' | ' || v_valor || ' | ' || VNome);
END;
/
