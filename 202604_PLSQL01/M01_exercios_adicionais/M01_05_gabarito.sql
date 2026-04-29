-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_05 | Identificadores com Aspas

-- ============================================================================

-- RESPOSTA CORRETA: B

-- EXPLICACAO:
-- "quando declaramos uma variavel entre aspas, seu uso passa a ser
--  sensivel a forma de escrever, ou seja, ficamos limitados a forma
--  como declaramos a variavel em relacao as maiusculas e minusculas."
-- "Cod Func" (C maiusculo, restante minusculo) e diferente de
-- "COD FUNC" (tudo maiusculo). O compilador gera erro igual ao
-- do erro: PLS-00201: o identificador deve ser declarado.
-- Observe que C esta errada: espacos sao PERMITIDOS quando o
-- identificador e colocado entre aspas duplas .

SET SERVEROUTPUT ON

-- Demonstracao do erro (comentado)
-- DECLARE
--    "Cod Func" NUMBER;
-- BEGIN
--    "COD FUNC" := 999;   -- PLS-00201
-- END;
-- /

-- Versao correta: usar exatamente o mesmo case da declaracao
DECLARE
   "Cod Func"   NUMBER;
BEGIN
   "Cod Func"   := 999;
   DBMS_OUTPUT.PUT_LINE('"Cod Func" = ' || "Cod Func");
END;
/
