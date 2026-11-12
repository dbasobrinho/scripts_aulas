-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_01  |  Slide 04
-- Tema: Cursor Implícito - atributos SQL%FOUND, SQL%NOTFOUND, SQL%ROWCOUNT
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, Schema EMP
-- =============================================================================
-- O cursor implícito é aberto e fechado automaticamente pelo Oracle em cada
-- comando DML (INSERT, UPDATE, DELETE) e em SELECT INTO de linha única.
-- Os atributos ficam disponíveis LOGO APÓS o comando - não depois de outro DML.
-- =============================================================================

SET SERVEROUTPUT ON
SET DEFINE ON

-- ------------------------------------------------------------
-- EXEMPLO 1: SQL%ROWCOUNT e SQL%FOUND após UPDATE
-- ------------------------------------------------------------
-- VALORES PARA TESTAR (digite um DEPTNO quando o script pedir):
--   10 -> UPDATE afetou 3 linha(s)
--   20 -> UPDATE afetou 5 linha(s)
--   30 -> UPDATE afetou 6 linha(s)
--   40 -> Nenhum funcionário encontrado (SQL%FOUND = FALSE)
-- ------------------------------------------------------------
DECLARE
  v_linhas NUMBER;
BEGIN
  UPDATE emp
  SET    sal = sal * 1.10
  WHERE  deptno = &&dept_upd;   -- duplo e-comercial: pede o valor uma vez só

  v_linhas := SQL%ROWCOUNT;

  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('UPDATE afetou ' || v_linhas || ' linha(s) no dept &dept_upd..');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Nenhum funcionario encontrado no dept &dept_upd..');
  END IF;

  ROLLBACK;
END;
/
UNDEFINE dept_upd

-- ------------------------------------------------------------
-- EXEMPLO 2: SQL%NOTFOUND após DELETE
-- ------------------------------------------------------------
DECLARE
BEGIN
  DELETE FROM emp WHERE empno = 9999;

  IF SQL%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nenhuma linha deletada (EMPNO 9999 nao existe).');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Linha deletada: ' || SQL%ROWCOUNT);
  END IF;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 3: SQL%ROWCOUNT após INSERT
-- ------------------------------------------------------------
DECLARE
BEGIN
  INSERT INTO emp (empno, ename, job, deptno, sal, hiredate)
  VALUES (9001, 'TESTE', 'CLERK', 10, 1500, SYSDATE);

  DBMS_OUTPUT.PUT_LINE('INSERT: ' || SQL%ROWCOUNT || ' linha inserida.');
  ROLLBACK;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 4: Cursor implícito com SELECT INTO
-- SQL%ISOPEN é sempre FALSE fora do cursor - o Oracle fecha automaticamente
-- ------------------------------------------------------------
DECLARE
  v_ename emp.ename%TYPE;
BEGIN
  SELECT ename INTO v_ename
  FROM   emp
  WHERE  empno = 7839;

  DBMS_OUTPUT.PUT_LINE('Funcionario: ' || v_ename);
  DBMS_OUTPUT.PUT_LINE('SQL%ISOPEN apos SELECT INTO: ' || CASE WHEN SQL%ISOPEN THEN 'TRUE' ELSE 'FALSE' END);
END;
/
