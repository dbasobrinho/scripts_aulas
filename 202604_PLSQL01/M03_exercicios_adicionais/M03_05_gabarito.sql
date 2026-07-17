-- =============================================================================
-- MÓDULO 03 - Gabarito 05
-- Tema: CASE pesquisado com EMP
-- =============================================================================

-- SET SERVEROUTPUT ON
-- SET DEFINE ON

-- DECLARE
--   v_nome  emp.ename%TYPE;
--   v_sal   emp.sal%TYPE;
--   v_bonus NUMBER(10,2);
--   v_faixa VARCHAR2(20);
-- BEGIN
--   SELECT ename, sal INTO v_nome, v_sal FROM emp WHERE empno = &empno;

--   CASE
--     WHEN v_sal > 4000          THEN v_faixa := 'Alta';  v_bonus := v_sal * 0.10;
--     WHEN v_sal BETWEEN 2000 AND 4000 THEN v_faixa := 'Media'; v_bonus := v_sal * 0.15;
--     ELSE                            v_faixa := 'Baixa'; v_bonus := v_sal * 0.20;
--   END CASE;

--   DBMS_OUTPUT.PUT_LINE('Nome  : ' || INITCAP(v_nome));
--   DBMS_OUTPUT.PUT_LINE('Sal   : ' || TO_CHAR(v_sal,   'FM99990.00'));
--   DBMS_OUTPUT.PUT_LINE('Faixa : ' || v_faixa);
--   DBMS_OUTPUT.PUT_LINE('Bonus : ' || TO_CHAR(v_bonus, 'FM99990.00'));
-- END;
-- /
-- Exemplos de saida conforme o EMPNO digitado:
--   7839 KING  : sal=5000, faixa=Alta,  bonus=500.00
--   7566 JONES : sal=2975, faixa=Media, bonus=446.25
--   7369 SMITH : sal= 800, faixa=Baixa, bonus=160.00
