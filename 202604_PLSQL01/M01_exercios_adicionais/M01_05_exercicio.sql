-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Exercicio M01_05 | Identificadores com Aspas

-- ============================================================================

-- CONTEXTO:
-- Ao declarar um identificador entre aspas duplas,
-- o uso passa a ser SENSIVEL A FORMA (case-sensitive).
-- PERGUNTA:
-- O bloco abaixo vai executar com sucesso ou gerar erro? Explique.
--   DECLARE
--      "Cod Func"   NUMBER;
--   BEGIN
--      "COD FUNC"  := 999;
--   END;
--   /
--   A) Executa com sucesso, pois PL/SQL nao e sensivel a forma.
--   B) Gera erro: ao usar aspas duplas, a linguagem passa a ser
--      sensivel a forma. "Cod Func" (inicial maiuscula) e diferente
--      de "COD FUNC" (tudo maiusculo).
--   C) Gera erro: nao e permitido usar espacos em identificadores.
--   D) Executa com sucesso, pois o compilador converte para maiusculas.
-- ============================================================================

-- Escreva sua resposta aqui:
-- Resposta: ___
