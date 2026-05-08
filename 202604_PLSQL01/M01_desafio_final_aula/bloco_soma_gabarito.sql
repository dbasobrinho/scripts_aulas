-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito | bloco_soma.sql
-- ============================================================================

-- SOLUCAO COMENTADA:
--
-- O bloco declara v_a e v_b ja com valores iniciais na secao DECLARE,
-- usando o operador de atribuicao (:=). Essa e a forma mais direta
-- e idiomatica em PL/SQL para variaveis com valores conhecidos.
--
-- v_soma recebe o resultado de v_a + v_b no BEGIN.
-- O DBMS_OUTPUT.PUT_LINE usa || para concatenar o texto com o numero.
-- O PL/SQL converte NUMBER para VARCHAR2 automaticamente na concatenacao.
--
-- A secao EXCEPTION com WHEN OTHERS garante que qualquer erro
-- inesperado sera capturado e exibido, em vez de abortar silenciosamente.
-- SQLERRM retorna a mensagem de erro do Oracle.
-- ============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF

-- -----------------------------------------------------------------------
-- VERSAO A: valores fixos (hardcoded)
-- -----------------------------------------------------------------------

DECLARE
   v_a    NUMBER := 10;
   v_b    NUMBER := 20;
   v_soma NUMBER;
BEGIN
   v_soma := v_a + v_b;
   DBMS_OUTPUT.PUT_LINE('Soma: ' || v_soma);
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;
/

-- Resultado esperado:
-- Soma: 30


-- -----------------------------------------------------------------------
-- VERSAO B: valores dinamicos com & (usuario informa ao executar)
-- -----------------------------------------------------------------------
-- O SQL*Plus substitui &v_num_a e &v_num_b ANTES de enviar ao Oracle.
-- Para NUMBER: sem aspas simples ao redor do &.
-- ACCEPT garante prompt amigavel e validacao de tipo.
-- -----------------------------------------------------------------------

ACCEPT v_num_a  NUMBER  PROMPT 'Informe o primeiro numero: '
ACCEPT v_num_b  NUMBER  PROMPT 'Informe o segundo numero : '

DECLARE
   v_a    NUMBER := &v_num_a;
   v_b    NUMBER := &v_num_b;
   v_soma NUMBER;
BEGIN
   v_soma := v_a + v_b;
   DBMS_OUTPUT.PUT_LINE('Soma de ' || v_a || ' + ' || v_b || ' = ' || v_soma);
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;
/

-- Exemplo de execucao (usuario informa 15 e 35):
-- Soma de 15 + 35 = 50

-- PONTOS DE ATENCAO:
-- 1. := no DECLARE inicializa com o valor substituido pelo SQL*Plus.
--    O Oracle recebe o bloco ja com o numero embutido.
-- 2. Para VARCHAR2 use aspas: v_nome VARCHAR2(50) := '&v_nome';
--    Para NUMBER nao use aspas: v_n NUMBER := &v_n;
-- 3. O operador || converte NUMBER para VARCHAR2 implicitamente.
--    Em producao prefira TO_CHAR(v_soma) para controlar formato.
-- 4. WHEN OTHERS captura qualquer excecao. Em producao prefira
--    capturar excecoes especificas antes do WHEN OTHERS.
-- 5. SQLERRM retorna a mensagem de erro Oracle do SQLCODE atual.
