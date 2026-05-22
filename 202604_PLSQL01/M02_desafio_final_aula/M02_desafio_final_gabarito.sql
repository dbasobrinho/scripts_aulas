-- ============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Desafio Final | GABARITO - Folha de Pagamento com Bloco Completo
-- ============================================================================

SET SERVEROUTPUT ON

DECLARE
  -- 1. Variaveis ancoradas com %TYPE
  v_nome     emp.ename%TYPE;
  v_cargo    emp.job%TYPE;
  v_salario  emp.sal%TYPE;
  v_deptno   emp.deptno%TYPE;

  -- 2. Constantes de desconto
  c_inss     CONSTANT NUMBER := 0.09;
  c_irrf     CONSTANT NUMBER := 0.075;

  -- 3. Variaveis de calculo
  v_desconto    NUMBER(10,2);
  v_sal_liquido NUMBER(10,2);

BEGIN
  -- 4. Busca dados do funcionario JONES (empno 7566)
  SELECT ename, job, sal, deptno
  INTO   v_nome, v_cargo, v_salario, v_deptno
  FROM   emp
  WHERE  empno = 7566;

  -- 5. Calculos de desconto e salario liquido
  v_desconto    := v_salario * (c_inss + c_irrf);
  v_sal_liquido := v_salario - v_desconto;

  -- 6. Exibir recibo formatado
  DBMS_OUTPUT.PUT_LINE('==============================');
  DBMS_OUTPUT.PUT_LINE('RECIBO DE PAGAMENTO');
  DBMS_OUTPUT.PUT_LINE('==============================');
  DBMS_OUTPUT.PUT_LINE('Funcionario : ' || INITCAP(v_nome));
  DBMS_OUTPUT.PUT_LINE('Cargo       : ' || INITCAP(v_cargo));
  DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_deptno);
  DBMS_OUTPUT.PUT_LINE(
    'Salario Bruto    : R$ ' ||
    TO_CHAR(v_salario, 'FM9G999D00', 'NLS_NUMERIC_CHARACTERS=,.')
  );
  DBMS_OUTPUT.PUT_LINE(
    'Desconto (16,5%): R$ ' ||
    TO_CHAR(v_desconto, 'FM9G999D00', 'NLS_NUMERIC_CHARACTERS=,.')
  );
  DBMS_OUTPUT.PUT_LINE(
    'Salario Liquido : R$ ' ||
    TO_CHAR(v_sal_liquido, 'FM9G999D00', 'NLS_NUMERIC_CHARACTERS=,.')
  );
  DBMS_OUTPUT.PUT_LINE('==============================');

  -- 7. Sub-bloco: diferenca para o maior salario
  DECLARE
    v_max_sal  NUMBER(10,2);
    v_dif      NUMBER(10,2);
  BEGIN
    SELECT MAX(sal)
    INTO   v_max_sal
    FROM   emp;

    v_dif := v_max_sal - v_salario;

    DBMS_OUTPUT.PUT_LINE(
      'Diferenca para o maior salario: R$ ' ||
      TO_CHAR(v_dif, 'FM9G999D00', 'NLS_NUMERIC_CHARACTERS=,.')
    );
  END;

END;
/

-- ============================================================================
-- SAIDA ESPERADA (JONES: sal = 2975):
-- ==============================
-- RECIBO DE PAGAMENTO
-- ==============================
-- Funcionario : Jones
-- Cargo       : Manager
-- Departamento: 20
-- Salario Bruto    : R$ 2.975,00
-- Desconto (16,5%): R$ 490,88
-- Salario Liquido : R$ 2.484,13
-- ==============================
-- Diferenca para o maior salario: R$ 2.025,00
--   (maior salario EMP = KING: 5000)
-- ============================================================================
