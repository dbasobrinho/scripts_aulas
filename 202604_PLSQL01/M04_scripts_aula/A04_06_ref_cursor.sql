-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_06  |  Slide 09
-- Tema: REF CURSOR (SYS_REFCURSOR) - cursor dinâmico e reutilizável
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, Schema EMP
-- =============================================================================
-- REF CURSOR é um ponteiro para um cursor - a query é associada no OPEN FOR.
-- SYS_REFCURSOR: tipo fraco (weak) predefinido pelo Oracle - aceita qualquer SELECT.
-- Uso típico: passagem de resultsets entre procedures/aplicação.
-- Ciclo: DECLARE tipo REF CURSOR -> OPEN ... FOR SELECT -> FETCH -> CLOSE
-- =============================================================================

SET SERVEROUTPUT ON
SET DEFINE ON

-- ------------------------------------------------------------
-- EXEMPLO 1: SYS_REFCURSOR básico - abrir para query diferente por condição
-- ------------------------------------------------------------
-- VALORES PARA TESTAR (digite o TIPO quando o script pedir):
--   ALTO  -> sal > 2500, do maior para o menor  (5 linhas: King ... Blake)
--   BAIXO -> sal <= 2500, do menor para o maior (9 linhas: Smith ... Clark)
-- A MESMA variável v_cur aponta para queries diferentes.
-- ------------------------------------------------------------
DECLARE
  v_cur    SYS_REFCURSOR;
  v_ename  emp.ename%TYPE;
  v_sal    emp.sal%TYPE;
  v_deptno emp.deptno%TYPE;
  v_tipo   VARCHAR2(10) := UPPER('&tipo');
BEGIN
  IF v_tipo = 'ALTO' THEN
    OPEN v_cur FOR
      SELECT ename, sal, deptno FROM emp WHERE sal > 2500 ORDER BY sal DESC;
  ELSE
    OPEN v_cur FOR
      SELECT ename, sal, deptno FROM emp WHERE sal <= 2500 ORDER BY sal;
  END IF;

  LOOP
    FETCH v_cur INTO v_ename, v_sal, v_deptno;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(
      RPAD(INITCAP(v_ename), 12) ||
      TO_CHAR(v_sal, 'FM$99990.00') ||
      '  DEPT ' || v_deptno
    );
  END LOOP;

  CLOSE v_cur;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 2: SYS_REFCURSOR com query dinâmica (string SQL)
-- ------------------------------------------------------------
DECLARE
  v_cur   SYS_REFCURSOR;
  v_ename emp.ename%TYPE;
  v_sal   emp.sal%TYPE;
  v_sql   VARCHAR2(200);
  v_dept  NUMBER := 20;
BEGIN
  v_sql := 'SELECT ename, sal FROM emp WHERE deptno = :1 ORDER BY sal DESC';

  OPEN v_cur FOR v_sql USING v_dept;

  DBMS_OUTPUT.PUT_LINE('Funcionarios do dept ' || v_dept || ':');
  LOOP
    FETCH v_cur INTO v_ename, v_sal;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_ename), 12) || TO_CHAR(v_sal, 'FM$99990.00'));
  END LOOP;

  CLOSE v_cur;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 3: Procedure que retorna SYS_REFCURSOR (pattern comum)
-- Simula o que seria passado a uma aplicação
-- ------------------------------------------------------------
DECLARE
  v_cur   SYS_REFCURSOR;
  v_ename emp.ename%TYPE;
  v_job   emp.job%TYPE;
  v_sal   emp.sal%TYPE;

  PROCEDURE busca_dept (p_deptno IN NUMBER, p_cur OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_cur FOR
      SELECT ename, job, sal
      FROM   emp
      WHERE  deptno = p_deptno
      ORDER  BY sal DESC;
  END busca_dept;

BEGIN
  busca_dept(30, v_cur);

  DBMS_OUTPUT.PUT_LINE('=== Dept 30 via REF CURSOR ===');
  LOOP
    FETCH v_cur INTO v_ename, v_job, v_sal;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(
      RPAD(INITCAP(v_ename), 12) ||
      RPAD(v_job, 12) ||
      TO_CHAR(v_sal, 'FM$99990.00')
    );
  END LOOP;

  CLOSE v_cur;
END;
/
