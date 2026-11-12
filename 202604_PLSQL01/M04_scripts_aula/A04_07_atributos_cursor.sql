-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_07  |  Slide 10
-- Tema: Atributos de Cursor - %FOUND, %NOTFOUND, %ROWCOUNT, %ISOPEN
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, Schema EMP
-- =============================================================================
-- Atributos disponíveis para cursores explícitos e para SQL (implícito):
--   %FOUND    : TRUE se o último FETCH trouxe uma linha / DML afetou >= 1 linha
--   %NOTFOUND : TRUE se o último FETCH não trouxe linha / DML afetou 0 linhas
--   %ROWCOUNT : número de linhas FETCHadas até agora / linhas afetadas pelo DML
--   %ISOPEN   : TRUE se o cursor está aberto (só para explícito)
-- =============================================================================

SET SERVEROUTPUT ON

-- ------------------------------------------------------------
-- EXEMPLO 1: Todos os atributos do cursor explícito em ação
-- ------------------------------------------------------------
DECLARE
  CURSOR c_emp IS
    SELECT empno, ename, sal
    FROM   emp
    WHERE  deptno = 20
    ORDER  BY empno;

  v_empno emp.empno%TYPE;
  v_ename emp.ename%TYPE;
  v_sal   emp.sal%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('ANTES do OPEN:');
  DBMS_OUTPUT.PUT_LINE('  %ISOPEN  = ' || CASE WHEN c_emp%ISOPEN THEN 'TRUE' ELSE 'FALSE' END);

  OPEN c_emp;

  DBMS_OUTPUT.PUT_LINE('APOS o OPEN (antes do FETCH):');
  DBMS_OUTPUT.PUT_LINE('  %ISOPEN  = ' || CASE WHEN c_emp%ISOPEN THEN 'TRUE' ELSE 'FALSE' END);
  DBMS_OUTPUT.PUT_LINE('  %ROWCOUNT= ' || c_emp%ROWCOUNT);

  LOOP
    FETCH c_emp INTO v_empno, v_ename, v_sal;
    EXIT WHEN c_emp%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      'FETCH #' || c_emp%ROWCOUNT || ': ' ||
      RPAD(INITCAP(v_ename), 12) ||
      '%FOUND=' || CASE WHEN c_emp%FOUND THEN 'T' ELSE 'F' END ||
      '  %ROWCOUNT=' || c_emp%ROWCOUNT
    );
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('APOS o loop:');
  DBMS_OUTPUT.PUT_LINE('  %NOTFOUND= ' || CASE WHEN c_emp%NOTFOUND THEN 'TRUE' ELSE 'FALSE' END);
  DBMS_OUTPUT.PUT_LINE('  %ROWCOUNT= ' || c_emp%ROWCOUNT || ' (total de linhas lidas)');

  CLOSE c_emp;

  DBMS_OUTPUT.PUT_LINE('APOS o CLOSE:');
  DBMS_OUTPUT.PUT_LINE('  %ISOPEN  = ' || CASE WHEN c_emp%ISOPEN THEN 'TRUE' ELSE 'FALSE' END);
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 2: Guardando %ROWCOUNT após fechar o cursor
-- Após CLOSE, os atributos (exceto %ISOPEN) lançam INVALID_CURSOR
-- Por isso guarde em variável antes do CLOSE se precisar depois
-- ------------------------------------------------------------
DECLARE
  CURSOR c_all IS SELECT empno FROM emp;
  v_empno   emp.empno%TYPE;
  v_total   NUMBER;
BEGIN
  OPEN c_all;
  LOOP
    FETCH c_all INTO v_empno;
    EXIT WHEN c_all%NOTFOUND;
  END LOOP;
  v_total := c_all%ROWCOUNT;
  CLOSE c_all;

  DBMS_OUTPUT.PUT_LINE('Total de funcionarios: ' || v_total);
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 3: %ISOPEN como protecao antes de fechar
-- ------------------------------------------------------------
DECLARE
  CURSOR c_dept IS SELECT deptno, dname FROM dept;
  v_rec c_dept%ROWTYPE;
BEGIN
  OPEN c_dept;
  FETCH c_dept INTO v_rec;
  DBMS_OUTPUT.PUT_LINE('Primeiro dept: ' || v_rec.dname);

  IF c_dept%ISOPEN THEN
    CLOSE c_dept;
    DBMS_OUTPUT.PUT_LINE('Cursor fechado com seguranca.');
  END IF;
END;
/
