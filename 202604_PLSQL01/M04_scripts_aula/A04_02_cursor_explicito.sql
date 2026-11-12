-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_02  |  Slide 05
-- Tema: Cursor Explícito - DECLARE, OPEN, FETCH INTO, CLOSE
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, Schema EMP
-- =============================================================================
-- Ciclo de vida obrigatório:
--   1. DECLARE: define a query (não executa ainda)
--   2. OPEN:    executa a query e posiciona antes da primeira linha
--   3. FETCH:   avança uma linha e carrega nas variáveis destino
--   4. CLOSE:   libera recursos - deve sempre ser chamado
-- =============================================================================

SET SERVEROUTPUT ON

-- ------------------------------------------------------------
-- EXEMPLO 1: Cursor simples - listar funcionários do dept 20
-- ------------------------------------------------------------
DECLARE
  CURSOR c_emp IS
    SELECT empno, ename, sal
    FROM   emp
    WHERE  deptno = 20
    ORDER  BY sal DESC;

  v_empno emp.empno%TYPE;
  v_ename emp.ename%TYPE;
  v_sal   emp.sal%TYPE;
BEGIN
  OPEN c_emp;

  LOOP
    FETCH c_emp INTO v_empno, v_ename, v_sal;
    EXIT WHEN c_emp%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      LPAD(v_empno, 6) || '  ' ||
      RPAD(INITCAP(v_ename), 12) ||
      TO_CHAR(v_sal, 'FM99990.00')
    );
  END LOOP;

  CLOSE c_emp;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 2: Cursor com WHILE - demonstra verificação antecipada
-- ------------------------------------------------------------
DECLARE
  CURSOR c_dept10 IS
    SELECT ename, job, sal
    FROM   emp
    WHERE  deptno = 10
    ORDER  BY ename;

  v_ename emp.ename%TYPE;
  v_job   emp.job%TYPE;
  v_sal   emp.sal%TYPE;
BEGIN
  OPEN c_dept10;
  FETCH c_dept10 INTO v_ename, v_job, v_sal;

  WHILE c_dept10%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(INITCAP(v_ename), 12) ||
      RPAD(v_job, 12) ||
      TO_CHAR(v_sal, 'FM$99990.00')
    );
    FETCH c_dept10 INTO v_ename, v_job, v_sal;
  END LOOP;

  CLOSE c_dept10;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 3: Cursor com contador manual
-- ------------------------------------------------------------
DECLARE
  CURSOR c_all IS
    SELECT ename, sal FROM emp ORDER BY sal DESC;

  v_ename emp.ename%TYPE;
  v_sal   emp.sal%TYPE;
  v_count NUMBER := 0;
  v_total NUMBER := 0;
BEGIN
  OPEN c_all;

  LOOP
    FETCH c_all INTO v_ename, v_sal;
    EXIT WHEN c_all%NOTFOUND;

    v_count := v_count + 1;
    v_total := v_total + v_sal;
    DBMS_OUTPUT.PUT_LINE(
      LPAD(v_count, 2) || '. ' ||
      RPAD(INITCAP(v_ename), 12) ||
      TO_CHAR(v_sal, 'FM$99990.00')
    );
  END LOOP;

  CLOSE c_all;

  DBMS_OUTPUT.PUT_LINE('---');
  DBMS_OUTPUT.PUT_LINE('Total funcionarios: ' || v_count);
  DBMS_OUTPUT.PUT_LINE('Folha total       : ' || TO_CHAR(v_total, 'FM$99990.00'));
END;
/
