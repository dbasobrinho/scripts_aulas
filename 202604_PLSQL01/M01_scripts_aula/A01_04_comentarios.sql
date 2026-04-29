-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_04 | - Comentarios em PL/SQL

-- ============================================================================
-- Objetivo: demonstrar as duas formas de comentario em PL/SQL.
-- ============================================================================
-- Regras de comentarios :
--   1. Dois hifens (--)  : tornam o restante da linha comentario.
--   2. /* ... */         : marcam uma regiao inteira como comentario.
--
-- Restricoes:
--   - Nao se pode embutir um comentario em outro.
--   - Nao usar -- em blocos processados dinamicamente por Oracle Precompiler,
--     pois os caracteres de fim de linha sao ignorados. Usar /* */ nesses casos.
-- ============================================================================

SET SERVEROUTPUT ON

-- ----------------------------------------------------------------------------
Comentarios 
-- 
-- ----------------------------------------------------------------------------

DECLARE
   VALOR      VARCHAR2(10);
   END_CASA   VARCHAR2(20);
BEGIN
   VALOR    := -- A atribuicao sera feita na outra linha
              'RUA A';
   END_CASA := /* a atribuicao vira a seguir */ 'RUA B S/N';
   DBMS_OUTPUT.PUT_LINE('VALOR    = ' || VALOR);
   DBMS_OUTPUT.PUT_LINE('END_CASA = ' || END_CASA);
END;
/

-- Resultado esperado ( p.254):
-- Procedimento PL/SQL concluído com sucesso.
-- VALOR    = RUA A
-- END_CASA = RUA B S/N

-- ----------------------------------------------------------------------------
-- Demonstracao adicional: comentario de bloco nao pode ser aninhado
-- O trecho abaixo causaria erro se descomentado:
--
-- BEGIN
--    /* comentario externo /* aninhado */ ainda externo */  -- ERRO!
--    NULL;
-- END;
-- /
-- ----------------------------------------------------------------------------
