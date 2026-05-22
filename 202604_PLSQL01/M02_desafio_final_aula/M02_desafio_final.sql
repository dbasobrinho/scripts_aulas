-- ============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Desafio Final | Folha de Pagamento com Bloco Completo
-- ============================================================================
-- OBJETIVO:
--   Integrar em um unico bloco PL/SQL os conceitos do M02:
--   %TYPE, CONSTANT, NOT NULL, SELECT INTO, operadores e funcoes SQL.
-- ============================================================================
-- PRE-REQUISITOS:
--   - Schema EMP disponivel (SCOTT)
--   - SET SERVEROUTPUT ON
-- ============================================================================
-- TAREFA:
--
--   1. Declare as seguintes variaveis USANDO %TYPE baseado na tabela EMP:
--        v_nome    -> coluna ename
--        v_cargo   -> coluna job
--        v_salario -> coluna sal
--        v_deptno  -> coluna deptno
--
--   2. Declare as constantes abaixo (use CONSTANT NUMBER):
--        c_inss    = 0.09   (9% de INSS)
--        c_irrf    = 0.075  (7.5% de IRRF)
--
--   3. Declare as variaveis de calculo:
--        v_desconto    NUMBER(10,2)  -- total de descontos
--        v_sal_liquido NUMBER(10,2)  -- salario liquido
--
--   4. Faca um SELECT INTO para buscar o funcionario EMPNO = 7566 (JONES)
--        Traga: ename, job, sal, deptno
--
--   5. Calcule:
--        v_desconto    := v_salario * (c_inss + c_irrf)
--        v_sal_liquido := v_salario - v_desconto
--
--   6. Exiba o recibo com DBMS_OUTPUT.PUT_LINE no formato abaixo:
--
--      ==============================
--      RECIBO DE PAGAMENTO
--      ==============================
--      Funcionario : JONES
--      Cargo       : MANAGER
--      Departamento: 20
--      Salario Bruto : R$  2.975,00
--      Desconto (16,5%): R$    490,88
--      Salario Liquido: R$  2.484,13
--      ==============================
--
--      Dica: use TO_CHAR(valor, 'FM9G999D00') para formatar numeros.
--            use INITCAP para o nome.
--            use RPAD para alinhar colunas.
--
--   7. Dentro de um sub-bloco, calcule e exiba a diferenca de salario
--      entre JONES (v_salario) e o maior salario da empresa:
--
--        SELECT MAX(sal) INTO v_max_sal FROM emp;
--        v_dif := v_max_sal - v_salario;
--
--        Declare v_max_sal e v_dif como NUMBER(10,2) DENTRO do sub-bloco.
--        Exiba: "Diferenca para o maior salario: R$ X.XXX,XX"
--
-- ============================================================================
-- RESTRICOES:
--   - Nao use tipos literais onde couber %TYPE
--   - c_inss e c_irrf devem ser CONSTANT
--   - O sub-bloco deve ser aninhado dentro do bloco principal
--   - Use funcoes SQL para formatar toda a saida
-- ============================================================================

SET SERVEROUTPUT ON

-- Escreva seu bloco PL/SQL aqui:

DECLARE
  -- 1. Variaveis com %TYPE
  ...

  -- 2. Constantes
  ...

  -- 3. Variaveis de calculo
  ...

BEGIN
  -- 4. SELECT INTO
  ...

  -- 5. Calculos
  ...

  -- 6. Exibir recibo
  ...

  -- 7. Sub-bloco: diferenca de salario
  DECLARE
    ...
  BEGIN
    ...
  END;

END;
/
