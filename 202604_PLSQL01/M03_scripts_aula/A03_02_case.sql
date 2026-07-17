-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_02  |  Slide 04
-- Tema: CASE simples e CASE pesquisado
-- Versão: 1.0  |  2026-04-26
-- =============================================================================

SET SERVEROUTPUT ON
SET DEFINE ON

-- PARTE 1: CASE simples
-- -----------------------------------------------------------------------------
-- VALORES PARA TESTAR (digite um EMPNO quando pedir "emp_cargo"):
--   7839  KING   -> PRESIDENT
--   7698  BLAKE  -> MANAGER
--   7788  SCOTT  -> ANALYST
--   7369  SMITH  -> CLERK
--   7499  ALLEN  -> SALESMAN
-- -----------------------------------------------------------------------------
DECLARE
  v_job  emp.job%TYPE;
  v_desc VARCHAR2(30);
BEGIN
  SELECT job INTO v_job FROM emp WHERE empno = &emp_cargo;
  CASE v_job
    WHEN 'PRESIDENT' THEN v_desc := 'Presidente da empresa';
    WHEN 'MANAGER'   THEN v_desc := 'Gerente de equipe';
    WHEN 'ANALYST'   THEN v_desc := 'Analista tecnico';
    WHEN 'CLERK'     THEN v_desc := 'Assistente operacional';
    WHEN 'SALESMAN'  THEN v_desc := 'Representante comercial';
    ELSE                  v_desc := 'Cargo nao mapeado';
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Cargo    : ' || v_job);
  DBMS_OUTPUT.PUT_LINE('Descricao: ' || v_desc);
END;
/

-- PARTE 2: CASE pesquisado
-- -----------------------------------------------------------------------------
-- VALORES PARA TESTAR (digite um EMPNO quando pedir "emp_bonus"):
--   7839  KING   sal 5000  -> bonus 8%
--   7698  BLAKE  sal 2850  -> bonus 10%
--   7499  ALLEN  sal 1600  -> bonus 12%
--   7369  SMITH  sal  800  -> bonus 15%
-- -----------------------------------------------------------------------------
DECLARE
  v_sal   emp.sal%TYPE;
  v_bonus NUMBER(10,2);
BEGIN
  SELECT sal INTO v_sal FROM emp WHERE empno = &emp_bonus;
  CASE
    WHEN v_sal > 4000 THEN v_bonus := v_sal * 0.08;
    WHEN v_sal > 2500 THEN v_bonus := v_sal * 0.10;
    WHEN v_sal > 1500 THEN v_bonus := v_sal * 0.12;
    ELSE                   v_bonus := v_sal * 0.15;
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Salario: ' || TO_CHAR(v_sal,   'FM99990.00'));
  DBMS_OUTPUT.PUT_LINE('Bonus  : ' || TO_CHAR(v_bonus, 'FM99990.00'));
END;
/
