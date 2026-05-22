-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_03  |  Slide 05
-- Tema: Atributo %TYPE - declaração ancorada ao tipo da coluna
-- Versão: 1.0  |  2026-04-26
-- Pré-req: Schema EMP/DEPT disponível
-- =============================================================================
-- O QUE DEMONSTRA:
--   %TYPE herda o tipo e tamanho exato da coluna da tabela.
--   Se a coluna mudar, a variável se adapta automaticamente.
--   Pode ancorar em outra variável também.
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_nome     emp.ename%TYPE;
  v_salario  emp.sal%TYPE;
  v_cargo    emp.job%TYPE;
  v_deptno   emp.deptno%TYPE;

  v_backup_sal  v_salario%TYPE;
BEGIN
  SELECT ename, sal, job, deptno
  INTO   v_nome, v_salario, v_cargo, v_deptno
  FROM   emp
  WHERE  empno = 7839;

  v_backup_sal := v_salario;

  DBMS_OUTPUT.PUT_LINE('=== Dados recuperados com %TYPE ===');
  DBMS_OUTPUT.PUT_LINE('Nome     : ' || v_nome);
  DBMS_OUTPUT.PUT_LINE('Salario  : ' || TO_CHAR(v_salario, 'FM99990.00'));
  DBMS_OUTPUT.PUT_LINE('Cargo    : ' || v_cargo);
  DBMS_OUTPUT.PUT_LINE('Depto    : ' || v_deptno);
  DBMS_OUTPUT.PUT_LINE('Backup   : ' || TO_CHAR(v_backup_sal, 'FM99990.00'));
END;
/

-- =============================================================================
-- TESTAR TAMBEM COM:
--   empno = 7698  (BLAKE - MANAGER)
--   empno = 7902  (FORD  - ANALYST)
-- =============================================================================
