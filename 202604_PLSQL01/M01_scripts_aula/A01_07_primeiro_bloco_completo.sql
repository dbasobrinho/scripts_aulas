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

-- ----------------------------------------------------------------------------
-- Bloco completo usando conceitos do M01
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
