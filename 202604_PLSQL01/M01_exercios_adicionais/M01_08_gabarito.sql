-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_08 | Fim de Linha e a Barra (/) no SQL*Plus

-- ============================================================================

-- POR QUE TRAVOU:
-- O SQL*Plus, ao reconhecer um bloco PL/SQL, para de usar o ; como
-- indicador de fim de entrada. Ele aguarda a barra (/) em uma linha
-- separada para saber que o bloco terminou.
-- O aluno digitou END; mas sem a barra, o SQL*Plus continua aguardando.
--
-- SOLUCAO: digitar / em uma linha separada e pressionar Enter.
--
-- Referencia :
-- "Para concluirmos a digitacao de um programa, deveremos utilizar a
--  barra (/) para encerrar e executar."

SET SERVEROUTPUT ON

-- Bloco correto com a barra:
BEGIN
   DBMS_OUTPUT.PUT_LINE('Ola mundo');
END;
/
-- Resultado: Ola mundo

-- OBS: o ponto (.) encerra sem executar.
-- Util quando voce quer cancelar a entrada sem rodar o bloco.
