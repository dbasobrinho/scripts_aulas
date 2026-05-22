-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_02 | Identificadores com Aspas Duplas
-- ============================================================
--
-- RESPOSTA CORRETA: C
--
-- JUSTIFICATIVA:
-- Quando um identificador e declarado entre aspas duplas,
-- seu uso passa a ser sensivel a maiusculas e minusculas.
-- "id de func" (minusculas) e "ID DE FUNC" (maiusculas)
-- sao identificadores DIFERENTES para o compilador PL/SQL.
-- O erro gerado sera: PLS-00201: identificador 'ID DE FUNC'
-- deve ser declarado.
--
-- BONUS - Uso correto: manter a mesma forma da declaracao.
-- ============================================================

-- DECLARE
  "id de func" NUMBER;
-- BEGIN
  "id de func" := 100;
--   DBMS_OUTPUT.PUT_LINE('Valor: ' || "id de func");
-- END;
/
-- Resultado: Valor: 100
-- ============================================================
