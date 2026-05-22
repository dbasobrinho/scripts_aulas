-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_02  |  Slide 04
-- Tema: Tipos escalares - NUMBER, VARCHAR2, CHAR, DATE, BOOLEAN
-- Versão: 1.0  |  2026-04-26
-- Pré-req: A02_01
-- =============================================================================
-- O QUE DEMONSTRA:
--   Comportamento específico de cada tipo escalar.
--   Diferença entre VARCHAR2 e CHAR.
--   BOOLEAN existe somente em PL/SQL, não como coluna SQL.
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_num1   NUMBER(10,2) := 1234.56;
  v_num2   NUMBER       := 3.14159265358979;
  v_int    INTEGER      := 42;

  v_var    VARCHAR2(20) := 'Oracle';
  v_char   CHAR(10)     := 'Oracle';

  v_data   DATE         := TO_DATE('01/01/2024', 'DD/MM/YYYY');
  v_hoje   DATE         := SYSDATE;

  v_flag   BOOLEAN      := TRUE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== NUMBER ===');
  DBMS_OUTPUT.PUT_LINE('NUMBER(10,2) : ' || v_num1);
  DBMS_OUTPUT.PUT_LINE('NUMBER       : ' || v_num2);
  DBMS_OUTPUT.PUT_LINE('INTEGER      : ' || v_int);

  DBMS_OUTPUT.PUT_LINE('=== VARCHAR2 vs CHAR ===');
  DBMS_OUTPUT.PUT_LINE('VARCHAR2(20) length: ' || LENGTH(v_var));
  DBMS_OUTPUT.PUT_LINE('CHAR(10)     length: ' || LENGTH(v_char));

  DBMS_OUTPUT.PUT_LINE('=== DATE ===');
  DBMS_OUTPUT.PUT_LINE('Data fixa : ' || TO_CHAR(v_data, 'DD/MM/YYYY'));
  DBMS_OUTPUT.PUT_LINE('Hoje      : ' || TO_CHAR(v_hoje, 'DD/MM/YYYY HH24:MI:SS'));

  DBMS_OUTPUT.PUT_LINE('=== BOOLEAN ===');
  IF v_flag = TRUE THEN
    DBMS_OUTPUT.PUT_LINE('Boolean   : TRUE');
  END IF;
  IF v_flag IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('Boolean nao e NULL');
  END IF;
END;
/

-- =============================================================================
-- OBSERVACOES IMPORTANTES
-- =============================================================================
-- CHAR(10) sempre ocupa 10 caracteres com espacos a direita.
-- VARCHAR2(20) ocupa apenas o tamanho real da string.
-- BOOLEAN so existe em PL/SQL. Nao pode ser usado em colunas SQL.
-- BOOLEAN aceita tres valores: TRUE, FALSE e NULL.
-- =============================================================================
