-- ============================================================================
-- M02 TEST RUNNER - dbasobrinho.com.br
-- USO:
--   sqlplus sys/oracle@192.168.56.110:1521/pbin.dbasobrinho.com AS SYSDBA @M02_TEST_RUNNER.sql
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET ECHO OFF
SET PAUSE OFF
WHENEVER SQLERROR CONTINUE

PROMPT
PROMPT ============================================================
PROMPT   M02 - Fundamentos da Linguagem  |  dbasobrinho.com.br
PROMPT ============================================================
PROMPT   Pressione ENTER para avancar entre os scripts.
PROMPT ============================================================
PROMPT

PAUSE Pronto? Pressione ENTER para comecar...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [1/9]  A02_01_declaracao_basica.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A02_01_declaracao_basica.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [2/9]  A02_02_tipos_escalares.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A02_02_tipos_escalares.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [3/9]  A02_03_atributo_type.sql  (requer schema SCOTT)
PROMPT ============================================================
PROMPT
ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
SET ECHO ON
@@A02_03_atributo_type.sql
SET ECHO OFF
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [4/9]  A02_04_not_null_constant.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A02_04_not_null_constant.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [5/9]  A02_05_escopo_blocos.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A02_05_escopo_blocos.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [6/9]  A02_06_operadores.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A02_06_operadores.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [7/9]  A02_07_funcoes_sql.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A02_07_funcoes_sql.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [8/9]  A02_08_exercicio_modelo.sql  (requer schema SCOTT)
PROMPT ============================================================
PROMPT
ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
SET ECHO ON
@@A02_08_exercicio_modelo.sql
SET ECHO OFF
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PAUSE Pressione ENTER para o ultimo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [9/9]  A02_09_sequencias_transacoes.sql  (requer schema SCOTT)
PROMPT ============================================================
PROMPT
ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
SET ECHO ON
@@A02_09_sequencias_transacoes.sql
SET ECHO OFF
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PROMPT
PROMPT ============================================================
PROMPT   M02 TEST RUNNER - concluido com sucesso!
PROMPT   dbasobrinho.com.br
PROMPT ============================================================
PROMPT
