-- =============================================================================
-- MÓDULO 04 - Exercício 06
-- Tema: Análise e correção de erro - FETCH sem OPEN
-- Tipo: Análise/correção de código
-- Nível: Básico
-- =============================================================================
-- CONTEXTO:
-- O código abaixo contém um erro intencional.
-- Análise, identifique o problema e corrija-o.
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_emp IS
--     SELECT ename, sal FROM emp WHERE deptno = 10;
--   v_ename emp.ename%TYPE;
--   v_sal   emp.sal%TYPE;
-- BEGIN
--   -- ERRO: cursor não foi aberto antes do FETCH
--   FETCH c_emp INTO v_ename, v_sal;   -- esta linha causa INVALID_CURSOR

--   IF c_emp%FOUND THEN
--     DBMS_OUTPUT.PUT_LINE(v_ename || ' - ' || v_sal);
--   END IF;

--   CLOSE c_emp;
-- END;
-- /

-- QUESTAO 1: Qual exceção Oracle e lancada por este código?
-- QUESTAO 2: Em qual linha está o erro?
-- QUESTAO 3: Reescreva o bloco de forma correta, exibindo todos os
--            funcionários do departamento 10.
