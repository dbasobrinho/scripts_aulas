-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_06 | Fim de Linha e Comportamento do SQL*Plus

-- ============================================================================
-- Objetivo: demonstrar como o SQL*Plus se comporta ao encontrar um bloco
--           PL/SQL e como indicar fim de entrada.
-- ============================================================================
-- FIM DE LINHA em PL/SQL :
-- "A indicacao de fim de linha de comando em PL/SQL e feita com um
--  ponto-e-virgula (;). Observe que o comportamento do SQL*Plus mudara
--  quando encontrar o primeiro comando de PL/SQL, pois nao aguardara
--  mais o ponto-e-virgula (;) para indicacao de fim de comando."
--
-- Para concluir a digitacao de um programa no SQL*Plus:
--   /  (barra)  - encerra E executa o bloco
--   .  (ponto)  - encerra sem executar
-- ============================================================================

SET SERVEROUTPUT ON

-- ----------------------------------------------------------------------------
-- Demonstracao 1: ponto-e-virgula termina cada COMANDO dentro do bloco,
-- nao o bloco inteiro. O bloco so executa com a barra (/) abaixo.
-- ----------------------------------------------------------------------------
DECLARE
   v_x   NUMBER := 10;
   v_y   NUMBER := 20;
   v_z   NUMBER;
BEGIN
   v_z := v_x + v_y;   -- ponto-e-virgula encerra este comando
   DBMS_OUTPUT.PUT_LINE('Soma: ' || v_z);
END;
/
-- A barra acima, em linha separada, encerra e executa o bloco.

-- ----------------------------------------------------------------------------
-- Demonstracao 2: bloco aninhado
-- Cada bloco interno tambem termina com END;
-- O bloco externo termina com END; e depois a barra /
-- ----------------------------------------------------------------------------
BEGIN
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Bloco interno executado.');
   END;   -- fim do bloco interno
   DBMS_OUTPUT.PUT_LINE('Bloco externo continuando.');
END;
/

-- ----------------------------------------------------------------------------
-- ATENCAO: erros comuns relacionados a fim de linha
--
-- Erro 1: esquecer o ponto-e-virgula apos END
--   BEGIN NULL END    <-- falta ; -> erro de compilacao
--
-- Erro 2: esquecer a barra (/) no SQL*Plus
--   BEGIN NULL; END;  <-- sem / o SQL*Plus aguarda mais entrada
--   (o cursor fica aguardando; o bloco nao executa)
-- ----------------------------------------------------------------------------
