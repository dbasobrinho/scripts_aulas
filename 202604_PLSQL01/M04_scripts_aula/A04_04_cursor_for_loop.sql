-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_04  |  Slide 07
-- Tema: Cursor FOR LOOP - a forma mais simples de usar cursores explícitos
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, Schema EMP
-- =============================================================================
-- O Cursor FOR LOOP automatiza todo o ciclo:
--   - OPEN, FETCH e CLOSE são feitos pelo Oracle automaticamente.
--   - A variável de registro é declarada implicitamente.
--   - Loop termina quando não há mais linhas (%NOTFOUND automático).
-- =============================================================================

SET SERVEROUTPUT ON

-- ------------------------------------------------------------
-- EXEMPLO 1: FOR LOOP com cursor nomeado
-- ------------------------------------------------------------
DECLARE
  CURSOR c_emp IS
    SELECT ename, job, sal, deptno
    FROM   emp
    ORDER  BY deptno, sal DESC;
BEGIN
  FOR rec IN c_emp LOOP
    DBMS_OUTPUT.PUT_LINE(
      'DEPT ' || LPAD(rec.deptno, 2, '0') || '  ' ||
      RPAD(INITCAP(rec.ename), 12) ||
      RPAD(rec.job, 12) ||
      TO_CHAR(rec.sal, 'FM$99990.00')
    );
  END LOOP;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 2: FOR LOOP com subquery inline (sem declarar cursor)
-- Forma mais concisa - o SELECT vai diretamente no FOR
-- ------------------------------------------------------------
BEGIN
  FOR rec IN (SELECT ename, sal FROM emp WHERE sal > 2500 ORDER BY sal DESC) LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(rec.ename), 12) || TO_CHAR(rec.sal, 'FM$99990.00'));
  END LOOP;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 3: FOR LOOP com acumulador - folha por departamento
-- ------------------------------------------------------------
DECLARE
  v_total NUMBER := 0;
  v_count NUMBER := 0;

  CURSOR c_dept20 IS
    SELECT ename, sal
    FROM   emp
    WHERE  deptno = 20;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Departamento 20 ===');

  FOR rec IN c_dept20 LOOP
    v_total := v_total + rec.sal;
    v_count := v_count + 1;
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(rec.ename), 12) || TO_CHAR(rec.sal, 'FM$99990.00'));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('---');
  DBMS_OUTPUT.PUT_LINE('Funcionarios: ' || v_count);
  DBMS_OUTPUT.PUT_LINE('Folha total : ' || TO_CHAR(v_total, 'FM$99990.00'));
  IF v_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Media salar.: ' || TO_CHAR(v_total / v_count, 'FM$99990.00'));
  END IF;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 4: FOR LOOP aninhado - dept x funcionários
-- ------------------------------------------------------------
BEGIN
  FOR r_dept IN (SELECT deptno, dname FROM dept ORDER BY deptno) LOOP
    DBMS_OUTPUT.PUT_LINE('== ' || r_dept.dname || ' (' || r_dept.deptno || ') ==');
    FOR r_emp IN (SELECT ename, sal FROM emp WHERE deptno = r_dept.deptno ORDER BY ename) LOOP
      DBMS_OUTPUT.PUT_LINE('   ' || RPAD(INITCAP(r_emp.ename), 12) || TO_CHAR(r_emp.sal, 'FM$99990.00'));
    END LOOP;
  END LOOP;
END;
/
