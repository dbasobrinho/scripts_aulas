-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_07 | Primeiro Bloco PL/SQL Completo

-- ============================================================================
-- Objetivo: consolidar os conceitos do M01 em um bloco PL/SQL completo,
--           usando a estrutura DECLARE/BEGIN/EXCEPTION/END apresentada
--           na   e os conceitos de variaveis e literais.
-- ============================================================================
-- Pre-requisito: SET SERVEROUTPUT ON
-- ============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF

-- ----------------------------------------------------------------------------
-- PARTE 1: Bloco com valores fixos (hardcoded)
-- ----------------------------------------------------------------------------
DECLARE
   -- variaveis com literais numericos e string 
   v_linguagem    VARCHAR2(30)  := 'PL/SQL';
   v_versao       VARCHAR2(10)  := 'Oracle 19c';
   v_ano          NUMBER        := 2025;
   v_fator        NUMBER        := 12E2;         -- notacao cientifica = 1200
   v_ativo        BOOLEAN       := TRUE;

   -- identificador com sublinhado (valido conforme p.252)
   v_msg_saida    VARCHAR2(200);

BEGIN
   -- montando mensagem (caracter string - p.253)
   v_msg_saida := 'Bem-vindo ao curso de ' || v_linguagem
                  || ' - ' || v_versao
                  || ' (' || v_ano || ')';

   DBMS_OUTPUT.PUT_LINE(v_msg_saida);
   DBMS_OUTPUT.PUT_LINE('Fator (12E2): ' || v_fator);

   -- boleano nao concatena diretamente
   IF v_ativo THEN
      DBMS_OUTPUT.PUT_LINE('Status: ATIVO');
   END IF;

   -- bloco aninhado (p.250: "cada bloco pode conter outros blocos")
   DECLARE
      v_sub   VARCHAR2(50) := 'Bloco aninhado executado com sucesso.';
   BEGIN
      DBMS_OUTPUT.PUT_LINE(v_sub);
   END;

   DBMS_OUTPUT.PUT_LINE('Bloco principal encerrado.');

EXCEPTION
   WHEN OTHERS THEN
      -- parte de tratamento de erros
      DBMS_OUTPUT.PUT_LINE('Erro capturado: ' || SQLERRM);
END;
/


-- ----------------------------------------------------------------------------
-- PARTE 2: Mesmo bloco com & — o usuario informa os valores na execucao
-- ----------------------------------------------------------------------------
-- Ao executar no SQL*Plus, sera solicitado:
--   "Enter value for seu_nome:"
--   "Enter value for sua_versao:"
-- O SQL*Plus substitui &variavel ANTES de enviar o bloco ao Oracle.
-- ----------------------------------------------------------------------------

PROMPT
PROMPT === AGORA COM VARIAVEL DE SUBSTITUICAO ===
PROMPT

ACCEPT v_nome_aluno  CHAR    PROMPT 'Seu nome: '
ACCEPT v_versao_db   CHAR    DEFAULT 'Oracle 19c' PROMPT 'Versao do banco [Oracle 19c]: '

DECLARE
   v_linguagem    VARCHAR2(30)  := 'PL/SQL';
   v_versao       VARCHAR2(30)  := '&v_versao_db';
   v_nome         VARCHAR2(50)  := '&v_nome_aluno';
   v_msg_saida    VARCHAR2(200);
BEGIN
   v_msg_saida := 'Ola, ' || v_nome || '! Bem-vindo ao curso de '
                  || v_linguagem || ' - ' || v_versao || '.';

   DBMS_OUTPUT.PUT_LINE(v_msg_saida);
   DBMS_OUTPUT.PUT_LINE('Bloco com substituicao executado com sucesso!');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
/
