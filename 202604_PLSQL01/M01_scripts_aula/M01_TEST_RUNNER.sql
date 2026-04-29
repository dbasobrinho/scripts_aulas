-- ============================================================================
-- M01 TEST RUNNER - dbasobrinho.com.br
-- USO:
--   sqlplus scott/oracle@192.168.56.110:1521/pbin.dbasobrinho.com @M01_TEST_RUNNER.sql
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET ECHO OFF
SET PAUSE OFF
WHENEVER SQLERROR CONTINUE

PROMPT
PROMPT ============================================================
PROMPT   M01 - Introducao ao PL/SQL  |  dbasobrinho.com.br
PROMPT ============================================================
PROMPT   Pressione ENTER para avancar entre os scripts.
PROMPT ============================================================
PROMPT

PAUSE Pronto? Pressione ENTER para comecar...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [1/8]  A01_01_sintaxe_bloco.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_01_sintaxe_bloco.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [2/8]  A01_02_identificadores.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_02_identificadores.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [3/8]  A01_03_palavras_reservadas.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_03_palavras_reservadas.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [4/8]  A01_04_comentarios.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_04_comentarios.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [5/8]  A01_05_literais.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_05_literais.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [6/8]  A01_06_fim_de_linha.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_06_fim_de_linha.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [7/8]  A01_07_primeiro_bloco_completo.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_07_primeiro_bloco_completo.sql
SET ECHO OFF

PAUSE Pressione ENTER para o ultimo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [8/8]  A01_08_performance_1bloco.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A01_08_performance_1bloco.sql
SET ECHO OFF

PROMPT
PROMPT ============================================================
PROMPT   M01 TEST RUNNER - concluido com sucesso!
PROMPT   dbasobrinho.com.br
PROMPT ============================================================
PROMPT
