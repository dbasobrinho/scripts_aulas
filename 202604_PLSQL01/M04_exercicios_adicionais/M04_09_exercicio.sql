-- =============================================================================
-- MÓDULO 04 - Exercício 09
-- Tema: Cursor parametrizado por departamento e cargo
-- Tipo: Código
-- Nível: Intermediário
-- Schema: EMP
-- =============================================================================
-- TAREFA:
-- Escreva um bloco anônimo que:
--   1. Declare um cursor parametrizado que aceite DEPTNO e JOB como parâmetros
--   2. Selecione EMPNO, ENAME, SAL de EMP filtrando pelos dois parâmetros
--   3. Abra o cursor com (deptno=30, job='SALESMAN') e liste os resultados
--   4. Feche e reabra o cursor com (deptno=10, job='MANAGER')
--   5. Liste os resultados da segunda abertura
--   6. Feche o cursor ao final
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_filtro (p_deptno NUMBER, p_job VARCHAR2) IS
--     SELECT empno, ename, sal
--     FROM   emp
--     WHERE  deptno = ...
--     AND    job    = ...
--     ORDER  BY ename;

--   v_rec c_filtro%ROWTYPE;

--   PROCEDURE exibe_grupo (p_deptno NUMBER, p_job VARCHAR2) IS
--   BEGIN
--     DBMS_OUTPUT.PUT_LINE('=== DEPT ' || p_deptno || ' / ' || p_job || ' ===');
--     OPEN c_filtro(..., ...);
--     LOOP
--       FETCH c_filtro INTO v_rec;
--       EXIT WHEN ...;
--       DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_rec.ename), 12) || TO_CHAR(v_rec.sal, 'FM$99990.00'));
--     END LOOP;
--     CLOSE c_filtro;
--   END exibe_grupo;

-- BEGIN
--   exibe_grupo(..., ...);
--   exibe_grupo(..., ...);
-- END;
-- /
