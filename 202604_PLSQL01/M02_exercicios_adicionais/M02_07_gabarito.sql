-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_07 | Tipos Escalares: BINARY_INTEGER vs NUMBER
-- ============================================================
--
-- RESPOSTA CORRETA: C
--
-- JUSTIFICATIVA:
-- BINARY_INTEGER (linha A): quando o resultado ultrapassa o
-- limite maximo, o valor e atribuido ao NUMBER sem erro, pois
-- BINARY_INTEGER usa library arithmetic e converte para NUMBER.
-- WNUM recebe 2147483648 com sucesso.
--
-- PLS_INTEGER (linha B): usa machine arithmetic e detecta
-- overflow imediatamente, gerando:
-- ORA-01426: esgotamento numerico
-- mesmo que o destino (WNUM) seja NUMBER e tenha capacidade.
--
-- RECOMENDACAO ORACLE: usar PLS_INTEGER nas novas aplicacoes
-- para ganhos de performance.
-- ============================================================

-- Demonstracao da linha A (BINARY_INTEGER - sem erro):
-- DECLARE
  WNUM  NUMBER;
  WBIN  BINARY_INTEGER := 2147483647;
-- BEGIN
  WNUM := WBIN + 1;
--   DBMS_OUTPUT.PUT_LINE('WBIN + 1 = ' || WNUM);
-- END;
/
-- Saida: WBIN + 1 = 2147483648

-- Demonstracao da linha B (PLS_INTEGER - gera overflow):
-- Descomente para ver o erro ORA-01426:
-- DECLARE
--   WNUM  NUMBER;
--   WPLS  PLS_INTEGER := 2147483647;
-- BEGIN
--   WNUM := WPLS + 1;
--   DBMS_OUTPUT.PUT_LINE('WPLS + 1 = ' || WNUM);
-- END;
-- /
-- ERRO: ORA-01426: esgotamento numerico
-- ============================================================
