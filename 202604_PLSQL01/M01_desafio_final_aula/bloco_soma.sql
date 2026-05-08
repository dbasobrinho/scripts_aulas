-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Desafio Final de Aula | bloco_soma.sql
-- ============================================================================

-- CONTEXTO:
-- Voce acabou de aprender a estrutura do bloco PL/SQL anonimo:
--   DECLARE ... BEGIN ... EXCEPTION ... END;
-- Agora e hora de colocar em pratica!
-- O PL/SQL permite declarar variaveis, executar logica e tratar erros
-- tudo dentro de um unico bloco. Neste desafio voce vai usar
-- as tres secoes do bloco juntas pela primeira vez.

-- DESAFIO:
-- Escreva um bloco PL/SQL anonimo que:
--
--   1. Declare tres variaveis numericas: v_a, v_b e v_soma
--   2. Atribua o valor 10 a v_a e 20 a v_b (na secao DECLARE ou no BEGIN)
--   3. Calcule a soma de v_a + v_b e armazene em v_soma
--   4. Exiba no console a mensagem: 'Soma: 30'
--   5. Inclua uma secao EXCEPTION com WHEN OTHERS que exiba o erro
--
-- DICAS:
--   - Use DBMS_OUTPUT.PUT_LINE para exibir o resultado
--   - Use o operador de concatenacao || para montar a mensagem
--   - Execute SET SERVEROUTPUT ON antes de rodar o bloco
--   - Termine o bloco com a barra (/) para que o SQL*Plus execute
--
-- RESULTADO ESPERADO:
--   Soma: 30
-- ============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF

-- -----------------------------------------------------------------------
-- VERSAO A: valores fixos (hardcoded) — complete o bloco abaixo
-- -----------------------------------------------------------------------

DECLARE
   -- 1. Declare suas variaveis aqui
BEGIN
   -- 2. Calcule e exiba o resultado
   NULL;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END;
/


-- -----------------------------------------------------------------------
-- VERSAO B: valores dinamicos com & — o usuario informa ao executar
-- Dica: para NUMBER nao use aspas; para VARCHAR2 use aspas ao redor do &
-- -----------------------------------------------------------------------

ACCEPT v_num_a  NUMBER  PROMPT 'Informe o primeiro numero: '
ACCEPT v_num_b  NUMBER  PROMPT 'Informe o segundo numero : '

DECLARE
   -- declare suas variaveis usando &v_num_a e &v_num_b
BEGIN
   -- calcule e exiba a soma
   NULL;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END;
/
