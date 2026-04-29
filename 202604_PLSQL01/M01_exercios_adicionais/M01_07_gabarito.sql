-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_07 | Comentarios em PL/SQL

-- ============================================================================

-- RESPOSTA CORRETA: B

-- EXPLICACAO:
-- "Como restricao, temos que nao podemos embutir um comentario em outro"
-- Na Opcao 2, o compilador encontra /* e procura o primeiro */,
-- que esta no meio da frase. O texto "ainda comentado */" fica fora
-- do comentario, causando erro de sintaxe.
-- Opcao 1: correta - dois estilos validos de comentario de linha.
-- Opcao 3: correta - /* */ pode ser usado em qualquer ponto,
--          inclusive inline em declaracoes.

SET SERVEROUTPUT ON

-- Demonstracao da Opcao 3 (valida):
DECLARE
   VALOR    VARCHAR2(10);
   END_CASA VARCHAR2(20);
BEGIN
   VALOR    := -- A atribuicao sera feita na outra linha
              'RUA A';
   END_CASA := /* a atribuicao vira a seguir */ 'RUA B S/N';
   DBMS_OUTPUT.PUT_LINE(VALOR);
   DBMS_OUTPUT.PUT_LINE(END_CASA);
END;
/
