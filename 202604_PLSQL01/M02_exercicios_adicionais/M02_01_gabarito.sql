-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_01 | Regras de Nomenclatura de Identificadores
-- ============================================================
--
-- RESPOSTA CORRETA: B
--
-- JUSTIFICATIVA:
-- Um identificador PL/SQL deve COMECAR com uma letra.
-- O identificador "1_CODIGO" comeca com o digito 1, o que
-- viola a regra basica de nomenclatura e causa erro de compilacao.
--
-- As demais opcoes sao validas:
-- A) V_NOME      -> letra + sublinhado + letras -> OK
-- C) V$SALARIO   -> letra + $ + letras         -> OK ($ e permitido)
-- D) V_NOME_FUNC -> letras, sublinhado, 25 chars -> OK
--
-- DEMONSTRACAO:
-- ============================================================

-- Declaracoes validas:
-- DECLARE
  V_NOME      VARCHAR2(30);
  V$SALARIO   NUMBER(10,2);
  V_NOME_FUNC VARCHAR2(100);
-- BEGIN
  V_NOME      := 'Oracle';
  V$SALARIO   := 5000.00;
  V_NOME_FUNC := 'Roberto Sobrinho';
--   DBMS_OUTPUT.PUT_LINE('Nome: '      || V_NOME);
--   DBMS_OUTPUT.PUT_LINE('Salario: '   || V$SALARIO);
--   DBMS_OUTPUT.PUT_LINE('Nome func: ' || V_NOME_FUNC);
-- END;
/

-- Declaracao invalida (descomente para ver o erro):
-- DECLARE
--   1_CODIGO NUMBER;
-- BEGIN
--   NULL;
-- END;
-- /
-- ERRO esperado: PLS-00103: Encontrado o simbolo "1"
-- ============================================================
