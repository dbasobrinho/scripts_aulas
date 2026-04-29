-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_03 | e 3.03 - Palavras Reservadas

-- ============================================================================
-- Objetivo: demonstrar que palavras reservadas nao podem ser usadas como
--           nomes de variaveis em PL/SQL.
-- ============================================================================
-- Palavras reservadas sao identificadores com significado especial em PL/SQL
-- e nao devem ser utilizadas na declaracao de variaveis. 
-- ============================================================================

SET SERVEROUTPUT ON

-- ----------------------------------------------------------------------------
Palavras reservadas 
-- O uso de END como nome de variavel causa erros de compilacao.
-- Execute para ver os erros gerados - .
-- ----------------------------------------------------------------------------

-- OBS: bloco abaixo gera erros proposital 
DECLARE
   END         VARCHAR2(10);    -- ERRO: END e palavra reservada
   END_CASA    VARCHAR2(20);
BEGIN
   END         := 'RUA A';
   END_CASA    := 'RUA B S/N.';
END;
/

-- Resultado esperado ( p.252):
-- ORA-06550: PLS-00103: Encontrado o simbolo "END" quando um dos seguintes
-- simbolos era esperado: begin function package pragma procedure subtype...

-- ----------------------------------------------------------------------------
Identificadores com aspas 
-- Alternativa: palavras reservadas PODEM ser usadas entre aspas duplas.
-- Essa forma nao e encorajada pela Oracle. 
-- ----------------------------------------------------------------------------

DECLARE
   "END"       VARCHAR2(10);
   END_CASA    VARCHAR2(20);
BEGIN
   "END"       := 'RUA A';
   END_CASA    := 'RUA B S/N.';
   DBMS_OUTPUT.PUT_LINE('"END"    = ' || "END");
   DBMS_OUTPUT.PUT_LINE('END_CASA = ' || END_CASA);
END;
/

-- Resultado esperado ( p.253):
-- Procedimento PL/SQL concluído com sucesso.

-- ----------------------------------------------------------------------------
-- Observacao: o sufixo END_CASA nao causa problema porque END aparece
-- apenas como parte do nome, nao como palavra reservada isolada.
-- ----------------------------------------------------------------------------
