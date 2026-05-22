-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_08  |  Script base do exercício da aula
-- Tema: Declare variáveis e processe dados do funcionário BLAKE
-- Versão: 1.0  |  2026-04-26
-- Pré-req: Schema EMP disponível
-- =============================================================================
-- TAREFA:
--   1. Declare v_nome e v_sal usando %TYPE com a tabela EMP
--   2. Declare uma constante c_taxa de 0.15 (imposto)
--   3. Faça um SELECT INTO para o empno 7698 (BLAKE)
--   4. Calcule: v_sal_liquido := v_sal * (1 - c_taxa)
--   5. Exiba: nome (INITCAP), salário bruto e líquido com TO_CHAR
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_nome       emp.ename%TYPE;
  v_sal        emp.sal%TYPE;
  c_taxa       CONSTANT NUMBER := 0.15;
  v_sal_liquido NUMBER(10,2);
BEGIN
  SELECT ename, sal
  INTO   v_nome, v_sal
  FROM   emp
  WHERE  empno = 7698;

  v_sal_liquido := ...;

  DBMS_OUTPUT.PUT_LINE('Funcionario : ' || ...);
  DBMS_OUTPUT.PUT_LINE('Salario Bruto  : R$ ' || ...);
  DBMS_OUTPUT.PUT_LINE('Salario Liquido: R$ ' || ...);
END;
/
