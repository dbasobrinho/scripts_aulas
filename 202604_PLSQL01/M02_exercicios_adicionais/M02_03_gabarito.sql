-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_03 | Palavras Reservadas
-- ============================================================
--
-- RESPOSTA CORRETA: B (apenas IF)
--
-- JUSTIFICATIVA:
-- IF e uma palavra reservada de PL/SQL e nao pode ser usada
-- como identificador sem aspas duplas.
--
-- END_DATE: END e parte do nome, nao e a palavra reservada -> OK
-- V_BEGIN:  BEGIN e parte do nome com prefixo V_ -> OK
-- LOOP_COUNT: LOOP e parte do nome, nao e exato -> OK
-- IF: uso exato da palavra reservada -> ERRO
--
-- PLS-00103: Encontrado o simbolo "IF" quando um dos seguintes
-- simbolos era esperado: begin function package pragma...
--
-- BONUS - Correcao com aspas duplas (nao recomendado pela Oracle):
-- "IF" VARCHAR2(10);
-- ============================================================

-- Declaracoes validas:
-- DECLARE
  END_DATE   DATE;
  V_BEGIN    NUMBER;
  LOOP_COUNT NUMBER;
-- BEGIN
  END_DATE   := SYSDATE;
  V_BEGIN    := 1;
  LOOP_COUNT := 0;
--   DBMS_OUTPUT.PUT_LINE('END_DATE: '   || TO_CHAR(END_DATE, 'DD/MM/YYYY'));
--   DBMS_OUTPUT.PUT_LINE('V_BEGIN: '    || V_BEGIN);
--   DBMS_OUTPUT.PUT_LINE('LOOP_COUNT: ' || LOOP_COUNT);
-- END;
/

-- Declaracao invalida (descomente para ver o erro):
-- DECLARE
--   IF VARCHAR2(10);
-- BEGIN
--   NULL;
-- END;
-- /

-- Alternativa com aspas (nao recomendada):
-- DECLARE
  "IF" VARCHAR2(10);
-- BEGIN
  "IF" := 'teste';
--   DBMS_OUTPUT.PUT_LINE('IF: ' || "IF");
-- END;
/
-- ============================================================
