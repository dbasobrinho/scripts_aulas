-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_03  |  Slide 06
-- Tema: %ROWTYPE - ancora ao tipo de uma linha inteira da tabela ou cursor
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, Schema EMP
-- =============================================================================
-- %ROWTYPE cria um registro com um campo para cada coluna da tabela/cursor.
-- Acessar: variavel.nome_coluna
-- Vantagem: não precisa declarar cada coluna individualmente.
--           Adapta automaticamente se a tabela mudar (DDL).
-- =============================================================================

SET SERVEROUTPUT ON

-- ------------------------------------------------------------
-- EXEMPLO 1: %ROWTYPE com SELECT INTO (linha única)
-- ------------------------------------------------------------
DECLARE
  v_emp emp%ROWTYPE;
BEGIN
  SELECT * INTO v_emp
  FROM   emp
  WHERE  empno = 7839;

  DBMS_OUTPUT.PUT_LINE('EMPNO    : ' || v_emp.empno);
  DBMS_OUTPUT.PUT_LINE('ENAME    : ' || INITCAP(v_emp.ename));
  DBMS_OUTPUT.PUT_LINE('JOB      : ' || v_emp.job);
  DBMS_OUTPUT.PUT_LINE('SAL      : ' || TO_CHAR(v_emp.sal, 'FM$99990.00'));
  DBMS_OUTPUT.PUT_LINE('DEPTNO   : ' || v_emp.deptno);
  DBMS_OUTPUT.PUT_LINE('HIREDATE : ' || TO_CHAR(v_emp.hiredate, 'DD/MM/YYYY'));
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 2: %ROWTYPE com cursor explícito
-- ------------------------------------------------------------
DECLARE
  CURSOR c_emp IS
    SELECT empno, ename, sal, deptno
    FROM   emp
    WHERE  deptno = 30
    ORDER  BY sal DESC;

  v_rec c_emp%ROWTYPE;
BEGIN
  OPEN c_emp;

  LOOP
    FETCH c_emp INTO v_rec;
    EXIT WHEN c_emp%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      RPAD(INITCAP(v_rec.ename), 12) ||
      'SAL: ' || TO_CHAR(v_rec.sal, 'FM$99990.00') ||
      '  DEPT: ' || v_rec.deptno
    );
  END LOOP;

  CLOSE c_emp;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 3: %ROWTYPE com dept - exibe linha completa
-- ------------------------------------------------------------
DECLARE
  v_dept dept%ROWTYPE;
BEGIN
  SELECT * INTO v_dept
  FROM   dept
  WHERE  deptno = 20;

  DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_dept.deptno || ' - ' || v_dept.dname);
  DBMS_OUTPUT.PUT_LINE('Localizacao : ' || v_dept.loc);
END;
/
