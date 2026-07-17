-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_08  |  Script base do exercício da aula
-- Tema: Relatório de funcionários por faixa salarial com contadores
-- Versão: 1.0  |  2026-04-26
-- =============================================================================
-- TAREFA:
--   1. Use FOR LOOP com cursor implícito para percorrer EMP
--   2. Use CASE pesquisado para classificar: SENIOR(>4000), PLENO(2500-4000), JUNIOR(<2500)
--   3. Acumule contadores separados para cada faixa
--   4. Exiba ao final: total de SENIOR, PLENO e JUNIOR
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_senior NUMBER := 0;
  v_pleno  NUMBER := 0;
  v_junior NUMBER := 0;
  v_class  VARCHAR2(10);
BEGIN
  FOR r IN (SELECT ename, sal FROM emp) LOOP
    CASE
      WHEN r.sal > 4000 THEN ...
      WHEN r.sal >= 2500 THEN ...
      ELSE ...
    END CASE;

    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(r.ename),12) || ' | ' || r.sal || ' | ' || v_class);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('=== Totais ===');
  DBMS_OUTPUT.PUT_LINE('SENIOR : ' || v_senior);
  DBMS_OUTPUT.PUT_LINE('PLENO  : ' || v_pleno);
  DBMS_OUTPUT.PUT_LINE('JUNIOR : ' || v_junior);
END;
/
