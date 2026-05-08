-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_08 | Performance: 1 Bloco PL/SQL vs N Comandos SQL
-- ============================================================================
-- Objetivo: demonstrar a vantagem de performance do PL/SQL ao agrupar
--           multiplos comandos SQL em um unico bloco enviado ao Oracle.
-- ============================================================================
-- Pre-requisito: usuario SCOTT com tabela EMP e DEPT (schema padrao Oracle).
-- ============================================================================

SET SERVEROUTPUT ON

-- ----------------------------------------------------------------------------
-- PASSO 0: Criar tabela auxiliar para o demo (se ainda nao existir)
-- ----------------------------------------------------------------------------
DECLARE
   v_existe   NUMBER;
BEGIN
   SELECT COUNT(*)
   INTO   v_existe
   FROM   user_tables
   WHERE  table_name = 'LOG_ALTERACOES';

   IF v_existe = 0 THEN
      EXECUTE IMMEDIATE '
         CREATE TABLE log_alteracoes (
            empno        NUMBER,
            dt_alteracao DATE,
            descricao    VARCHAR2(100)
         )';
      DBMS_OUTPUT.PUT_LINE('Tabela LOG_ALTERACOES criada.');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Tabela LOG_ALTERACOES ja existe.');
   END IF;
END;
/

-- ----------------------------------------------------------------------------
-- CONCEITO: Sem PL/SQL - a aplicacao envia cada SQL separadamente
-- (simulacao: cada bloco abaixo seria uma chamada de rede separada)
-- ----------------------------------------------------------------------------

-- Chamada 1: buscar salario atual
-- SELECT sal INTO v_sal FROM emp WHERE empno = 7788;

-- Chamada 2: calcular novo salario
-- v_novo_sal := v_sal * 1.10;

-- Chamada 3: atualizar
-- UPDATE emp SET sal = v_novo_sal WHERE empno = 7788;

-- Chamada 4: registrar log
-- INSERT INTO log_alteracoes VALUES (7788, SYSDATE, 'AUMENTO 10%');

-- Chamada 5: confirmar
-- COMMIT;

-- 5 round trips de rede!

-- ----------------------------------------------------------------------------
-- COM PL/SQL: tudo em um unico bloco - 1 unico envio ao Oracle
-- ----------------------------------------------------------------------------
DECLARE
   v_empno      NUMBER := 7788;
   v_sal        NUMBER;
   v_novo_sal   NUMBER;
BEGIN
   -- Passo 1: buscar salario atual
   SELECT sal
   INTO   v_sal
   FROM   emp
   WHERE  empno = v_empno;

   -- Passo 2: calcular novo salario (aumento de 10%)
   v_novo_sal := v_sal * 1.10;

   -- Passo 3: atualizar
   UPDATE emp
   SET    sal = v_novo_sal
   WHERE  empno = v_empno;

   -- Passo 4: registrar log
   INSERT INTO log_alteracoes (empno, dt_alteracao, descricao)
   VALUES (v_empno, SYSDATE, 'AUMENTO 10%');

   -- Passo 5: confirmar
   COMMIT;

   DBMS_OUTPUT.PUT_LINE('Salario anterior: ' || v_sal);
   DBMS_OUTPUT.PUT_LINE('Salario novo    : ' || v_novo_sal);
   DBMS_OUTPUT.PUT_LINE('Atualizacao concluida - 1 bloco, 1 round trip.');

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Funcionario ' || v_empno || ' nao encontrado.');
      ROLLBACK;
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
      ROLLBACK;
END;
/

-- ----------------------------------------------------------------------------
-- LIMPEZA: reverter aumento para nao alterar dados do schema SCOTT
-- (execute apos a demonstracao se quiser preservar o dado original)
-- ----------------------------------------------------------------------------
-- ROLLBACK;  -- descomente se quiser desfazer
-- DROP TABLE log_alteracoes;  -- descomente se quiser remover a tabela

-- ----------------------------------------------------------------------------
-- RESUMO DO CONCEITO:
-- - Sem PL/SQL: aplicacao faz N chamadas separadas ao banco (N round trips)
-- - Com PL/SQL: aplicacao envia 1 bloco contendo todos os comandos SQL
--   O Oracle processa internamente e devolve apenas o resultado final.
-- - Resultado: reducao de trafego de rede e menor latencia.
-- ----------------------------------------------------------------------------
