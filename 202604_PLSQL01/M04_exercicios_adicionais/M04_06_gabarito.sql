-- =============================================================================
-- MÓDULO 04 - Gabarito 06
-- Tema: Análise e correção de erro - FETCH sem OPEN
-- =============================================================================
-- RESPOSTA 1: INVALID_CURSOR (ORA-01001)
--   Ocorre quando se tenta fazer FETCH em um cursor que não foi aberto,
--   ou CLOSE em cursor não aberto, ou acesso a atributos após CLOSE.
--
-- RESPOSTA 2: A linha do FETCH - o cursor nunca foi aberto com OPEN c_emp.
--
-- RESPOSTA 3: Código corrigido:
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_emp IS
--     SELECT ename, sal FROM emp WHERE deptno = 10;
--   v_ename emp.ename%TYPE;
--   v_sal   emp.sal%TYPE;
-- BEGIN
--   OPEN c_emp;

--   LOOP
--     FETCH c_emp INTO v_ename, v_sal;
--     EXIT WHEN c_emp%NOTFOUND;
--     DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_ename), 12) || TO_CHAR(v_sal, 'FM$99990.00'));
--   END LOOP;

--   CLOSE c_emp;
-- END;
-- /
-- Resultado esperado: Clark, King, Miller (dept 10)
