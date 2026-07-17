-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_04  |  Slide 06
-- Tema: WHILE LOOP - condição avaliada antes de cada iteração
-- Versão: 1.0  |  2026-04-26
-- =============================================================================

SET SERVEROUTPUT ON

-- Calculo de fatorial com WHILE
DECLARE
  v_n   NUMBER := 1;
  v_fat NUMBER := 1;
  v_lim CONSTANT NUMBER := 10;
BEGIN
  WHILE v_n <= v_lim LOOP
    v_fat := v_fat * v_n;
    DBMS_OUTPUT.PUT_LINE(v_n || '! = ' || v_fat);
    v_n := v_n + 1;
  END LOOP;
END;
/

-- Exemplo: WHILE com condicao falsa desde o inicio (executa 0 vezes)
DECLARE
  v_x NUMBER := 100;
BEGIN
  WHILE v_x < 10 LOOP
    DBMS_OUTPUT.PUT_LINE('Esta linha nunca aparece');
    v_x := v_x + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Loop nao executou. v_x = ' || v_x);
END;
/
