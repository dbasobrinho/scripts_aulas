-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_05 | Literais Booleanos e Atribuicao Invalida
-- ============================================================
--
-- RESPOSTA CORRETA: C
--
-- JUSTIFICATIVA:
-- O tipo BOOLEAN nao pode ser convertido implicitamente para
-- VARCHAR2. A atribuicao "V_TEXTO := V_ATIVO" gera o erro:
-- PLS-00382: a expressao e do tipo incorreto
--
-- A solucao e usar IF/THEN/ELSE para converter manualmente.
-- ============================================================

-- Versao com erro (descomente para ver):
-- DECLARE
--   V_ATIVO BOOLEAN := TRUE;
--   V_TEXTO VARCHAR2(10);
-- BEGIN
--   V_TEXTO := V_ATIVO;  -- PLS-00382
--   DBMS_OUTPUT.PUT_LINE('Ativo: ' || V_TEXTO);
-- END;
-- /

-- Versao correta com IF:
-- DECLARE
  V_ATIVO BOOLEAN := TRUE;
  V_TEXTO VARCHAR2(10);
-- BEGIN
--   IF V_ATIVO THEN
    V_TEXTO := 'TRUE';
--   ELSIF V_ATIVO IS NULL THEN
    V_TEXTO := 'NULL';
--   ELSE
    V_TEXTO := 'FALSE';
--   END IF;
--   DBMS_OUTPUT.PUT_LINE('Ativo: ' || V_TEXTO);
-- END;
/
-- Saida: Ativo: TRUE
-- ============================================================
