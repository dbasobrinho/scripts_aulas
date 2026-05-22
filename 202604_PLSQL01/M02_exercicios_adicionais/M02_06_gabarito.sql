-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_06 | Comentarios e Restricoes de Aninhamento
-- ============================================================
--
-- RESPOSTA CORRETA: B
--
-- JUSTIFICATIVA:
-- O Trecho B tenta aninhar comentarios de bloco: /* ... /* ... */ */
-- O compilador interpreta o PRIMEIRO */ como o fechamento do
-- comentario externo, e o segundo */ fica sem par, gerando erro.
-- PL/SQL nao suporta comentarios aninhados.
--
-- Trechos A e C: comentarios de linha validos.
-- Trecho D: comentario de bloco multilinhas e valido.
-- ============================================================

-- Trecho A: valido
-- DECLARE
  V_X NUMBER := 10; -- valor inicial
-- BEGIN
  NULL;
-- END;
/

-- Trecho C: valido
-- DECLARE
  V_X NUMBER := 10;
-- BEGIN
  -- comentario de linha simples
  NULL;
-- END;
/

-- Trecho D: valido - comentario de bloco multilinhas
-- DECLARE
  V_X NUMBER := /* inicio do comentario
                   continua na proxima linha */ 10;
-- BEGIN
--   DBMS_OUTPUT.PUT_LINE('V_X = ' || V_X);
-- END;
/
-- Saida: V_X = 10

-- Trecho B: INVALIDO (descomente para ver o erro):
-- DECLARE
--   V_X NUMBER := /* valor /* aninhado */ */ 10;
-- BEGIN
--   NULL;
-- END;
-- /
-- ERRO: o compilador fecha o comentario no primeiro */
-- e o segundo */ fica sem correspondencia.
-- ============================================================
