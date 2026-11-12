-- =============================================================================
-- MÓDULO 04 - Exercício 03
-- Tema: SQL%ROWCOUNT após UPDATE
-- Tipo: Código
-- Nível: Básico
-- Schema: EMP
-- =============================================================================
-- TAREFA:
-- Escreva um bloco anônimo que:
--   1. Aumente em 15% o salário de todos os funcionários do departamento 30
--   2. Use SQL%ROWCOUNT para exibir quantas linhas foram afetadas
--   3. Use SQL%FOUND para exibir uma mensagem diferente se nenhuma linha
--      for afetada (teste com deptno = 99 para simular)
--   4. Faca ROLLBACK no final para não alterar os dados
-- =============================================================================

-- SET SERVEROUTPUT ON

-- BEGIN
--   UPDATE emp
--   SET    sal = ...
--   WHERE  deptno = ...;

--   IF SQL%FOUND THEN
--     DBMS_OUTPUT.PUT_LINE('Salarios atualizados: ' || ... || ' funcionario(s).');
--   ELSE
--     DBMS_OUTPUT.PUT_LINE('Nenhum funcionario encontrado no departamento informado.');
--   END IF;

--   ROLLBACK;
-- END;
-- /
