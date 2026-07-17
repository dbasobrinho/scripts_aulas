-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 03  |  Aula: A03_02  |  Slide 04
-- Tema: CASE simples e CASE pesquisado
-- Versão: 1.0  |  2026-04-26
-- =============================================================================

SET SERVEROUTPUT ON

-- PARTE 1: CASE simples
DECLARE
  v_job  emp.job%TYPE;
  v_desc VARCHAR2(30);
BEGIN
  SELECT job INTO v_job FROM emp WHERE empno = 7839;
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
DECLARE
  v_sal   emp.sal%TYPE;
  v_bonus NUMBER(10,2);
BEGIN
  SELECT sal INTO v_sal FROM emp WHERE empno = 7698;
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
