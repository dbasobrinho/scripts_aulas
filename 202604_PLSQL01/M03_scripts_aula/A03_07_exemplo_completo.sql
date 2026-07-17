-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_07  |  Slide 09
-- Tema: Exemplo prático - relatório de funcionários com IF, CASE e FOR LOOP
-- Versão: 1.0  |  2026-04-26
-- Pré-req: Schema EMP
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_aum   NUMBER(10,2);
  v_class VARCHAR2(10);
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('Nome',       12) || ' | ' ||
                       LPAD('Salario', 8) || ' | ' ||
                       RPAD('Classe', 7)  || ' | Aumento');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));

  FOR r IN (SELECT ename, sal, deptno FROM emp ORDER BY sal DESC) LOOP
    CASE
      WHEN r.sal > 4000 THEN v_class := 'SENIOR'; v_aum := r.sal * 0.08;
      WHEN r.sal > 2500 THEN v_class := 'PLENO';  v_aum := r.sal * 0.10;
      ELSE                   v_class := 'JUNIOR';  v_aum := r.sal * 0.15;
    END CASE;

    DBMS_OUTPUT.PUT_LINE(
      RPAD(INITCAP(r.ename), 12) || ' | ' ||
      LPAD(TO_CHAR(r.sal, 'FM9990.00'), 8) || ' | ' ||
      RPAD(v_class, 7) || ' | +' ||
      TO_CHAR(v_aum, 'FM9990.00'));
  END LOOP;
END;
/
