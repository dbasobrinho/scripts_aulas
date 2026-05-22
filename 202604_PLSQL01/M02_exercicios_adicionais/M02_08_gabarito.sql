-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_08 | Atributo %TYPE: Vantagens e Comportamento
-- ============================================================
--
-- RESPOSTA CORRETA: B
--
-- JUSTIFICATIVA:
-- W_VAR e declarada com V_BASE%TYPE. Como V_BASE e uma variavel
-- LOCAL declarada com NOT NULL, a restricao NOT NULL TAMBEM e
-- copiada para W_VAR. Portanto, a atribuicao:
--   W_VAR := NULL;
-- gera erro de compilacao:
-- ORA-06550: PLS-00382: a expressao e do tipo incorreto
--
-- BONUS: Sim, W_VAR poderia receber NULL.
-- Motivo: quando %TYPE e baseado em uma COLUNA do banco de dados,
-- apenas o tipo e o tamanho sao copiados. A restricao NOT NULL
-- da coluna NAO e transferida para a variavel PL/SQL.
-- ============================================================

-- Demonstracao: %TYPE de variavel local copia NOT NULL
-- (descomente para ver o erro):
-- DECLARE
--   V_BASE DATE NOT NULL := SYSDATE;
--   W_VAR  V_BASE%TYPE;
-- BEGIN
--   W_VAR := NULL;  -- ERRO: PLS-00382
-- END;
-- /

-- Correto: declarar sem NOT NULL ou dar valor nao nulo:
-- DECLARE
  V_BASE DATE NOT NULL := SYSDATE;
  W_VAR  V_BASE%TYPE := SYSDATE;  -- inicializa com valor valido
-- BEGIN
--   DBMS_OUTPUT.PUT_LINE('W_VAR = ' || TO_CHAR(W_VAR, 'DD/MM/YYYY'));
  -- W_VAR := NULL;  -- isso geraria erro pois NOT NULL foi copiado
-- END;
/

-- Demonstracao: %TYPE de coluna NAO copia NOT NULL
-- (assumindo tabela EMPLOYEES com HIRE_DATE NOT NULL)
-- DECLARE
--   W_DATA EMPLOYEES.HIRE_DATE%TYPE;
-- BEGIN
--   W_DATA := NULL;  -- OK: NOT NULL da coluna nao foi copiado
--   DBMS_OUTPUT.PUT_LINE('W_DATA aceita NULL: OK');
-- END;
-- /
-- ============================================================
