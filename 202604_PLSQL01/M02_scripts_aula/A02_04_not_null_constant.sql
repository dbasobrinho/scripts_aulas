-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_04  |  Slide 06
-- Tema: NOT NULL, DEFAULT e CONSTANT
-- Versão: 1.0  |  2026-04-26
-- Pré-req: A02_01
-- =============================================================================
-- O QUE DEMONSTRA:
--   NOT NULL obriga inicialização e impede atribuição de NULL.
--   DEFAULT fornece valor inicial (equivalente a :=).
--   CONSTANT declara valor imutável durante toda a execução.
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_status   VARCHAR2(10) NOT NULL := 'ATIVO';
  v_bonus    NUMBER       DEFAULT 500;
  c_limite   CONSTANT NUMBER       := 5000;
  c_empresa  CONSTANT VARCHAR2(30) := 'Oracle Corp';
  v_sal      NUMBER(10,2)          := 3000;
  v_novo_sal NUMBER(10,2);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Status  : ' || v_status);
  DBMS_OUTPUT.PUT_LINE('Bonus   : ' || v_bonus);
  DBMS_OUTPUT.PUT_LINE('Limite  : ' || c_limite);
  DBMS_OUTPUT.PUT_LINE('Empresa : ' || c_empresa);

  IF v_sal + v_bonus <= c_limite THEN
    v_novo_sal := v_sal + v_bonus;
    DBMS_OUTPUT.PUT_LINE('Aprovado. Novo salario: ' || v_novo_sal);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Reprovado. Acima do limite de ' || c_limite);
  END IF;

  -- Testar NOT NULL: descomentar a linha abaixo para ver o erro PLS-00218
  -- v_status := NULL;
END;
/

-- =============================================================================
-- ERROS ESPERADOS SE DESCOMENTAR:
--   v_status := NULL;
--   PLS-00218: a variable declared NOT NULL must have an initialization assignment
--   (na verdade o erro seria em runtime: VALUE_ERROR)
-- =============================================================================
