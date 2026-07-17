-- ============================================================================
-- M03 TEST RUNNER - dbasobrinho.com.br
-- USO:
--   sqlplus sys/oracle@192.168.56.110:1521/pbin.dbasobrinho.com AS SYSDBA @M03_TEST_RUNNER.sql
-- ============================================================================
-- Executa em sequencia todos os scripts da aula M03 (A03_01 .. A03_08).
-- Scripts que consultam a tabela EMP rodam com CURRENT_SCHEMA = SCOTT.
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET ECHO OFF
SET PAUSE OFF
WHENEVER SQLERROR CONTINUE

PROMPT
PROMPT ============================================================
PROMPT   M03 - Estruturas de Controle  |  dbasobrinho.com.br
PROMPT ============================================================
PROMPT   Pressione ENTER para avancar entre os scripts.
PROMPT ============================================================
PROMPT

PAUSE Pronto? Pressione ENTER para comecar...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [1/8]  A03_01_if_elsif_else.sql  (requer schema SCOTT)
PROMPT ============================================================
PROMPT
ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
SET ECHO ON
@@A03_01_if_elsif_else.sql
SET ECHO OFF
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [2/8]  A03_02_case.sql  (requer schema SCOTT)
PROMPT ============================================================
PROMPT
ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
SET ECHO ON
@@A03_02_case.sql
SET ECHO OFF
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [3/8]  A03_03_loop_exit.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A03_03_loop_exit.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [4/8]  A03_04_while_loop.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A03_04_while_loop.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [5/8]  A03_05_for_loop.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A03_05_for_loop.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [6/8]  A03_06_loops_aninhados.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A03_06_loops_aninhados.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [7/8]  A03_07_exemplo_completo.sql  (requer schema SCOTT)
PROMPT ============================================================
PROMPT
ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
SET ECHO ON
@@A03_07_exemplo_completo.sql
SET ECHO OFF
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PAUSE Pressione ENTER para o ultimo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [8/8]  A03_08_exercicio_modelo.sql  (requer schema SCOTT)
PROMPT ============================================================
PROMPT
ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
SET ECHO ON
@@A03_08_exercicio_modelo.sql
SET ECHO OFF
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PROMPT
PROMPT ============================================================
PROMPT   M03 TEST RUNNER - concluido com sucesso!
PROMPT   dbasobrinho.com.br
PROMPT ============================================================
PROMPT
