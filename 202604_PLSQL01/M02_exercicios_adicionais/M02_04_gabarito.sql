-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_04 | Literais Numericos e Notacao Cientifica
-- ============================================================
--
-- RESPOSTA CORRETA: A
--
-- CALCULOS:
-- V_A = 2E3   = 2 * 10^3  = 2 * 1000    = 2000
-- V_B = 5e-2  = 5 * 10^-2 = 5 / 100     = 0.05
-- V_C = 15E0  = 15 * 10^0 = 15 * 1      = 15
-- V_D = 1E2+5 = 100 + 5                  = 105
-- ============================================================

-- DECLARE
  V_A NUMBER := 2E3;
  V_B NUMBER := 5e-2;
  V_C NUMBER := 15E0;
  V_D NUMBER := 1E2 + 5;
-- BEGIN
--   DBMS_OUTPUT.PUT_LINE('V_A = 2E3   = ' || V_A);
--   DBMS_OUTPUT.PUT_LINE('V_B = 5e-2  = ' || V_B);
--   DBMS_OUTPUT.PUT_LINE('V_C = 15E0  = ' || V_C);
--   DBMS_OUTPUT.PUT_LINE('V_D = 1E2+5 = ' || V_D);
-- END;
/
-- Saida esperada:
-- V_A = 2E3   = 2000
-- V_B = 5e-2  = .05
-- V_C = 15E0  = 15
-- V_D = 1E2+5 = 105
-- ============================================================
