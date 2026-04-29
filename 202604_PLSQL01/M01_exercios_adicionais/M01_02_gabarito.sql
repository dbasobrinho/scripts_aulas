-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_02 | Estrutura do Bloco PL/SQL

-- ============================================================================

-- RESPOSTA CORRETA: B

-- EXPLICACAO:
-- Em PL/SQL, variaveis so podem ser declaradas na secao DECLARE,
-- que precede o BEGIN. Dentro do BEGIN so cabem comandos executaveis.
-- Estrutura do bloco:
-- "Uma parte declarativa, onde definimos as variaveis locais aquele bloco."
-- "Uma parte de logica, onde definimos a acao que aquele bloco deve realizar."
-- Bloco corrigido:

SET SERVEROUTPUT ON

DECLARE
   v_nome VARCHAR2(20) := 'Oracle';
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_nome);
END;
/

-- Resultado: Oracle
