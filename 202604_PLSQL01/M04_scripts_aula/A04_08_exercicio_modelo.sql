-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_08  |  Slide 14
-- Tema: Exercício da aula - Relatório de departamentos com cursor FOR LOOP
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, M04, Schema EMP/DEPT
-- =============================================================================
-- DESAFIO:
-- Crie um bloco anônimo que:
--   1. Percorra todos os departamentos da tabela DEPT usando cursor FOR LOOP
--   2. Para cada departamento, exiba: número, nome e localização
--   3. Dentro de cada dept, liste os funcionários (ename, job, sal) ordenados por SAL DESC
--   4. Exiba a média salarial do departamento
--   5. Se o departamento não tiver funcionários, exiba "(sem funcionários)"
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_total_func NUMBER := 0;
  v_soma_sal   NUMBER;
  v_count_emp  NUMBER;
BEGIN
  FOR r_dept IN (SELECT deptno, dname, loc FROM dept ORDER BY deptno) LOOP

    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('DEPT ' || r_dept.deptno || ' - ' || r_dept.dname || ' (' || r_dept.loc || ')');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');

    v_soma_sal  := 0;
    v_count_emp := 0;

    FOR r_emp IN (
      SELECT ename, job, sal
      FROM   emp
      WHERE  deptno = ...
      ORDER  BY sal DESC
    ) LOOP
      v_count_emp := ...;
      v_soma_sal  := ...;
      DBMS_OUTPUT.PUT_LINE(
        '  ' || RPAD(INITCAP(r_emp.ename), 12) ||
        RPAD(r_emp.job, 12) ||
        TO_CHAR(r_emp.sal, 'FM$99990.00')
      );
    END LOOP;

    IF v_count_emp = 0 THEN
      DBMS_OUTPUT.PUT_LINE('  (sem funcionarios)');
    ELSE
      DBMS_OUTPUT.PUT_LINE('  Media: ' || TO_CHAR(v_soma_sal / v_count_emp, 'FM$99990.00'));
      v_total_func := v_total_func + v_count_emp;
    END IF;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('============================================');
  DBMS_OUTPUT.PUT_LINE('Total de funcionarios: ' || v_total_func);
END;
/
