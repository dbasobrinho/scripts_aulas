-- ============================================================================
-- M04 TEST RUNNER - dbasobrinho.com.br
-- USO:
--   sqlplus sys/oracle@192.168.56.131:1521/pbin.dbasobrinho.com AS SYSDBA @M04_TEST_RUNNER.sql
--   (lab lnxora26ai131: CDB bin / PDB PBIN. Validado em 09/11/2026.)
-- ============================================================================
-- Executa em sequência todos os scripts da aula M04 (A04_01 .. A04_07, A04_09)
-- e, no fim, o gabarito do desafio final.
-- A04_08 (exercício modelo) NÃO roda aqui: é um esqueleto com "..." para o
-- aluno completar e não compila de propósito.
-- Todos os scripts consultam EMP/DEPT: rodam com CURRENT_SCHEMA = SCOTT.
-- Todo DML dos scripts termina em ROLLBACK: a SCOTT.EMP não é alterada.
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE ON
SET VERIFY OFF
SET ECHO OFF
SET PAUSE OFF
SET LINESIZE 200
WHENEVER SQLERROR CONTINUE

-- ----------------------------------------------------------------------------
-- VALORES PADRÃO para os scripts interativos (A04_01, A04_05, A04_06).
-- Já definidos aqui para o runner executar TUDO sem parar pedindo digitação.
-- Com a variável já DEFINEd, o & usa o valor sem perguntar.
-- Troque à vontade para testar outros cenários.
-- ----------------------------------------------------------------------------
DEFINE dept_upd    = 30      -- A04_01 ex.1: UPDATE afeta 6 linhas (40 -> 0)
DEFINE dept_filtro = 30      -- A04_05 ex.2: dept 30 ...
DEFINE sal_min     = 1500    --              ... com sal >= 1500 -> 3 linhas
DEFINE tipo        = ALTO    -- A04_06 ex.1: ALTO (5 linhas) ou BAIXO (9)

PROMPT
PROMPT ============================================================
PROMPT   M04 - Cursores  |  dbasobrinho.com.br
PROMPT ============================================================
PROMPT   Pressione ENTER para avancar entre os scripts.
PROMPT ============================================================
PROMPT

PAUSE Pronto? Pressione ENTER para comecar...

ALTER SESSION SET CURRENT_SCHEMA = SCOTT;

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [1/9]  A04_01_cursor_implicito.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_01_cursor_implicito.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [2/9]  A04_02_cursor_explicito.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_02_cursor_explicito.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [3/9]  A04_03_rowtype.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_03_rowtype.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [4/9]  A04_04_cursor_for_loop.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_04_cursor_for_loop.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [5/9]  A04_05_cursor_parametrizado.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_05_cursor_parametrizado.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [6/9]  A04_06_ref_cursor.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_06_ref_cursor.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [7/9]  A04_07_atributos_cursor.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_07_atributos_cursor.sql
SET ECHO OFF

PAUSE Pressione ENTER para o proximo script...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [8/9]  A04_09_for_update.sql
PROMPT ============================================================
PROMPT
SET ECHO ON
@@A04_09_for_update.sql
SET ECHO OFF

PAUSE Pressione ENTER para o desafio final...

-- ============================================================
PROMPT
PROMPT ============================================================
PROMPT   [9/9]  Desafio final - GABARITO
PROMPT ============================================================
PROMPT
SET ECHO ON
@@../M04_desafio_final_aula/M04_desafio_final_gabarito.sql
SET ECHO OFF

ALTER SESSION SET CURRENT_SCHEMA = SYS;

PROMPT
PROMPT ============================================================
PROMPT   M04 TEST RUNNER - concluido!
PROMPT   Confira as saidas com os paineis verdes do deck M04.
PROMPT   dbasobrinho.com.br
PROMPT ============================================================
PROMPT
