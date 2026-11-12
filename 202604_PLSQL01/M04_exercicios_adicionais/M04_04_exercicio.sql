-- =============================================================================
-- MÓDULO 04 - Exercício 04
-- Tema: Cursor explícito com OPEN/FETCH/CLOSE
-- Tipo: Código
-- Nível: Básico
-- Schema: EMP
-- =============================================================================
-- TAREFA:
-- Escreva um bloco anônimo que:
--   1. Declare um cursor explícito que selecione EMPNO, ENAME, JOB e SAL
--      de todos os funcionários do departamento 20, ordenados por ENAME
--   2. Use variáveis individuais (não %ROWTYPE) para receber o FETCH
--   3. Percorra todas as linhas com LOOP/EXIT WHEN usando %NOTFOUND
--   4. Exiba cada linha no formato: "7369  Smith        CLERK       $800.00"
--   5. Ao final, exiba o total de linhas lidas com %ROWCOUNT
--   6. Feche o cursor
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_dept20 IS
--     SELECT ...
--     FROM   emp
--     WHERE  ...
--     ORDER  BY ...;

--   v_empno  emp.empno%TYPE;
--   v_ename  emp.ename%TYPE;
--   v_job    emp.job%TYPE;
--   v_sal    emp.sal%TYPE;
-- BEGIN
--   OPEN ...;

--   LOOP
--     FETCH ... INTO ...;
--     EXIT WHEN ...;

--     DBMS_OUTPUT.PUT_LINE(
--       LPAD(v_empno, 6) || '  ' ||
--       RPAD(INITCAP(v_ename), 12) ||
--       RPAD(v_job, 12) ||
--       TO_CHAR(v_sal, 'FM$99990.00')
--     );
--   END LOOP;

--   DBMS_OUTPUT.PUT_LINE('---');
--   DBMS_OUTPUT.PUT_LINE('Total lido: ' || ... || ' linha(s).');

--   CLOSE ...;
-- END;
-- /
