-- =============================================================================
-- MÓDULO 03 - Exercício 05
-- Tema: CASE pesquisado com EMP
-- Tipo: Código
-- Nível: Básico
-- Requer: Schema EMP
-- =============================================================================
-- TAREFA:
-- Para o funcionário empno = 7566 (JONES):
-- Use CASE pesquisado para determinar:
--   Se sal > 4000: bonus = sal * 0.10
--   Se sal entre 2000 e 4000: bonus = sal * 0.15
--   Senão: bonus = sal * 0.20
-- Exiba: nome, salário, faixa e bônus.
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   v_nome  emp.ename%TYPE;
--   v_sal   emp.sal%TYPE;
--   v_bonus NUMBER(10,2);
--   v_faixa VARCHAR2(20);
-- BEGIN
--   SELECT ename, sal INTO v_nome, v_sal FROM emp WHERE empno = 7566;

--   CASE
--     WHEN ... THEN ...
--     WHEN ... THEN ...
--     ELSE ...
--   END CASE;

--   DBMS_OUTPUT.PUT_LINE('Nome  : ' || INITCAP(v_nome));
--   DBMS_OUTPUT.PUT_LINE('Sal   : ' || TO_CHAR(v_sal,   'FM99990.00'));
--   DBMS_OUTPUT.PUT_LINE('Faixa : ' || v_faixa);
--   DBMS_OUTPUT.PUT_LINE('Bonus : ' || TO_CHAR(v_bonus, 'FM99990.00'));
-- END;
-- /
