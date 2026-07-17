-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_01  |  Slide 03
-- Tema: IF / ELSIF / ELSE - condicional em PL/SQL
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, Schema EMP
-- =============================================================================

SET SERVEROUTPUT ON
SET DEFINE ON

-- -----------------------------------------------------------------------------
-- VALORES PARA TESTAR (digite um EMPNO quando o script pedir):
--   7839  KING   sal 5000  -> SENIOR
--   7788  SCOTT  sal 3000  -> PLENO
--   7698  BLAKE  sal 2850  -> JUNIOR
--   7369  SMITH  sal  800  -> TRAINEE
-- Rode varias vezes trocando o EMPNO e veja a classe mudar.
-- -----------------------------------------------------------------------------

DECLARE
  v_sal    emp.sal%TYPE;
  v_nome   emp.ename%TYPE;
  v_classe VARCHAR2(10);
BEGIN
  SELECT sal, ename INTO v_sal, v_nome
  FROM emp WHERE empno = &empno;

  IF v_sal > 5000 THEN
    v_classe := 'SENIOR';
  ELSIF v_sal >= 3000 THEN
    v_classe := 'PLENO';
  ELSIF v_sal >= 1500 THEN
    v_classe := 'JUNIOR';
  ELSE
    v_classe := 'TRAINEE';
  END IF;

  DBMS_OUTPUT.PUT_LINE('Funcionario: ' || INITCAP(v_nome));
  DBMS_OUTPUT.PUT_LINE('Salario    : ' || TO_CHAR(v_sal, 'FM99990.00'));
  DBMS_OUTPUT.PUT_LINE('Classe     : ' || v_classe);
END;
/
