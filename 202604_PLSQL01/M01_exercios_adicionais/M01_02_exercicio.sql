-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Exercicio M01_02 | Estrutura do Bloco PL/SQL

-- ============================================================================

-- CONTEXTO:
-- A estrutura basica do bloco PL/SQL apresenta as tres partes de um bloco PL/SQL.
-- PERGUNTA:
-- Analise o bloco abaixo e identifique o erro:
--   BEGIN
--      v_nome VARCHAR2(20) := 'Oracle';
--      DBMS_OUTPUT.PUT_LINE(v_nome);
--   END;
--   /
-- Qual e o problema e como corrigi-lo?
--   A) Falta a barra (/) apos END. Adicionar / resolve.
--   B) A declaracao da variavel v_nome esta na secao BEGIN,
--      mas variaveis devem ser declaradas na secao DECLARE,
--      antes do BEGIN.
--   C) O comando DBMS_OUTPUT.PUT_LINE nao e valido em PL/SQL.
--   D) A palavra reservada END nao pode ser usada como nome de variavel.
-- ============================================================================

-- Escreva sua resposta aqui:
-- Resposta: ___

-- Bloco corrigido:
-- (escreva a versao correta abaixo)

-- DECLARE
--    ...
-- BEGIN
--    ...
-- END;
-- /
