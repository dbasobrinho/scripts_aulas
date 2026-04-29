-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_06 | Literais Numericos e Notacao Cientifica

-- ============================================================================

-- RESPOSTAS:
--   a = 12000      (12E3 = 12 * 10^3 = 12000)
--   b = .05        (500e-4 = 500 * 10^-4 = 500/10000 = .05)
--   c = -5.32
--   d = 17
--
-- Referencia :
-- "12E3 (= 12*10^3 = 12000) ou 500e-4 (= 500*10^-4 = 500/10000 = .05)"

SET SERVEROUTPUT ON

DECLARE
   v_a   NUMBER := 12E3;
   v_b   NUMBER := 500e-4;
   v_c   NUMBER := -05.32;
   v_d   NUMBER := 17.;
BEGIN
   DBMS_OUTPUT.PUT_LINE('a = ' || v_a);
   DBMS_OUTPUT.PUT_LINE('b = ' || v_b);
   DBMS_OUTPUT.PUT_LINE('c = ' || v_c);
   DBMS_OUTPUT.PUT_LINE('d = ' || v_d);
END;
/
