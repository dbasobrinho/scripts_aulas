-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_10 | Declaracao: "A, B NUMBER" Causa Erro
-- ============================================================
--
-- PERGUNTA 1: RESPOSTA CORRETA: C (Blocos 2 e 3)
--
-- JUSTIFICATIVA:
-- Bloco 1: PL/SQL NAO permite declaracao multipla separada por
-- virgula. Gera erro de compilacao: PLS-00103.
-- Bloco 2: Declaracoes unitarias - forma correta.
-- Bloco 3: Declaracoes unitarias com valor inicial usando outra
-- variavel ja declarada - tambem valido.
--
-- PERGUNTA 2: RESPOSTA CORRETA: B
-- PLS-00103: Encontrado o simbolo "," quando um dos seguintes
-- simbolos era esperado: constant exception <identificador>
--
-- PERGUNTA 3: Sim, valido. Imprime 2.
-- A := 1 e B := A + 1 = 2. E possivel usar A no valor inicial
-- de B pois A ja foi declarado ANTES de B.
-- ============================================================

-- Bloco 1: invalido (descomente para ver o erro):
-- DECLARE
--   A, B, C NUMBER;   -- PLS-00103: Encontrado ","
-- BEGIN
--   A := 0;
-- END;
-- /

-- Bloco 2: valido
-- DECLARE
  A NUMBER;
  B NUMBER;
  C NUMBER;
-- BEGIN
  A := 0;
  B := 0;
  C := 0;
--   DBMS_OUTPUT.PUT_LINE('A=' || A || ' B=' || B || ' C=' || C);
-- END;
/
-- Saida: A=0 B=0 C=0

-- Bloco 3: valido - usa variavel ja declarada no valor inicial
-- DECLARE
  A NUMBER := 1;
  B NUMBER := A + 1;
-- BEGIN
--   DBMS_OUTPUT.PUT_LINE('B = ' || B);
-- END;
/
-- Saida: B = 2

-- ATENCAO: referencia a variavel nao declarada ainda causa erro:
-- DECLARE
--   A NUMBER := B + 1;  -- ERRO: B nao foi declarado ainda
--   B NUMBER := 0;
-- BEGIN NULL; END;
-- /
-- PLS-00320: a declaracao do tipo desta expressao esta incorreta
-- ============================================================
