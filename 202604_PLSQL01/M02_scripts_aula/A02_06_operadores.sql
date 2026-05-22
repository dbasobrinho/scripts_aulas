-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_06  |  Slide 08
-- Tema: Operadores e expressões
-- Versão: 1.0  |  2026-04-26
-- Pré-req: A02_01
-- =============================================================================
-- O QUE DEMONSTRA:
--   Operadores de atribuição, comparação, aritmética, concatenação e lógicos.
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_a      NUMBER := 10;
  v_b      NUMBER := 3;
  v_texto  VARCHAR2(50) := 'Oracle';
  v_flag   BOOLEAN;
  v_result NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== ARITMETICOS ===');
  DBMS_OUTPUT.PUT_LINE('a + b = ' || (v_a + v_b));
  DBMS_OUTPUT.PUT_LINE('a - b = ' || (v_a - v_b));
  DBMS_OUTPUT.PUT_LINE('a * b = ' || (v_a * v_b));
  DBMS_OUTPUT.PUT_LINE('a / b = ' || ROUND(v_a / v_b, 4));
  DBMS_OUTPUT.PUT_LINE('a**2  = ' || (v_a ** 2));
  DBMS_OUTPUT.PUT_LINE('MOD   = ' || MOD(v_a, v_b));

  DBMS_OUTPUT.PUT_LINE('=== CONCATENACAO ===');
  DBMS_OUTPUT.PUT_LINE(v_texto || ' ' || TO_CHAR(v_a));
  DBMS_OUTPUT.PUT_LINE('Versao: ' || v_texto || ' 19c');

  DBMS_OUTPUT.PUT_LINE('=== COMPARACAO ===');
  IF v_a > v_b THEN
    DBMS_OUTPUT.PUT_LINE('a maior que b');
  END IF;
  IF v_a <> v_b THEN
    DBMS_OUTPUT.PUT_LINE('a diferente de b');
  END IF;
  IF v_a BETWEEN 5 AND 15 THEN
    DBMS_OUTPUT.PUT_LINE('a entre 5 e 15');
  END IF;

  DBMS_OUTPUT.PUT_LINE('=== LOGICOS ===');
  v_flag := (v_a > 0) AND (v_b > 0);
  IF v_flag THEN
    DBMS_OUTPUT.PUT_LINE('ambos positivos');
  END IF;
  IF NOT (v_a = v_b) THEN
    DBMS_OUTPUT.PUT_LINE('nao sao iguais');
  END IF;
END;
/
