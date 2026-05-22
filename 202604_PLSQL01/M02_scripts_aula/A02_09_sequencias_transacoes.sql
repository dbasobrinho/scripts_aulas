-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Modulo 02  |  Aula: A02_09  |  Complemento
-- Tema: Sequences em PL/SQL + DML + Controle de Transacao
-- Versao: 1.0  |  2026-04-27
-- Pre-req: A02_01, A02_02, A02_05
-- =============================================================================
-- Ref: Oracle Intro SQL/PL/SQL Vol2, Cap 17 (Sequences em expressoes PL/SQL)
--      Oracle Intro SQL/PL/SQL Vol2, Cap 18 (Instrucoes DML + COMMIT/ROLLBACK)
--      1Z0-149 Topics 2 e 3
-- =============================================================================
-- O QUE DEMONSTRA:
--   1. Sequences em PL/SQL: NEXTVAL e CURRVAL em instrucoes
--   2. DML dentro de bloco PL/SQL: INSERT, UPDATE, DELETE
--   3. Controle de transacao: COMMIT, ROLLBACK, SAVEPOINT
--   4. Conversao implicita vs explicita de tipos
-- =============================================================================

SET SERVEROUTPUT ON

-- ============================================================
-- SECAO 1: SEQUENCES EM PL/SQL
-- ============================================================
-- Em PL/SQL (Oracle 11g+) voce pode usar sequence.NEXTVAL e
-- sequence.CURRVAL diretamente em expressoes e instrucoes DML.
-- Antes do 11g era necessario: SELECT seq.NEXTVAL INTO v FROM dual;
-- ============================================================

-- Setup: criar tabela e sequence de teste
DROP TABLE pedidos_teste PURGE;

CREATE TABLE pedidos_teste (
  pedido_id  NUMBER       PRIMARY KEY,
  cliente    VARCHAR2(30) NOT NULL,
  valor      NUMBER(10,2),
  criado_em  DATE         DEFAULT SYSDATE
);

DROP SEQUENCE seq_pedido;
CREATE SEQUENCE seq_pedido START WITH 1 INCREMENT BY 1 NOCACHE;

-- ------------------------------------------------------------
-- EXEMPLO 1: sequence.NEXTVAL diretamente em INSERT PL/SQL
-- ------------------------------------------------------------
BEGIN
  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (seq_pedido.NEXTVAL, 'SMITH', 1500.00);

  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (seq_pedido.NEXTVAL, 'JONES', 2300.50);

  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (seq_pedido.NEXTVAL, 'FORD', 980.00);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('3 pedidos inseridos. Ultimo ID: ' || seq_pedido.CURRVAL);
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 2: NEXTVAL em expressao PL/SQL (Oracle 11g+)
-- ------------------------------------------------------------
DECLARE
  v_novo_id  NUMBER;
  v_cliente  VARCHAR2(30) := 'CLARK';
BEGIN
  -- Atribuicao direta (Oracle 11g+): sem SELECT INTO necessario
  v_novo_id := seq_pedido.NEXTVAL;

  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (v_novo_id, v_cliente, 750.00);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Pedido ' || v_novo_id || ' criado para ' || v_cliente);
END;
/

SELECT * FROM pedidos_teste ORDER BY pedido_id;

-- ============================================================
-- SECAO 2: DML DENTRO DE PL/SQL + ATRIBUTOS SQL%
-- ============================================================
-- Todo DML em PL/SQL usa o cursor implicito (cursor SQL).
-- SQL%ROWCOUNT: quantas linhas foram afetadas.
-- SQL%FOUND:    TRUE se alguma linha foi afetada.
-- SQL%NOTFOUND: TRUE se nenhuma linha foi afetada.
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO 3: UPDATE com SQL%ROWCOUNT
-- ------------------------------------------------------------
DECLARE
  v_rows NUMBER;
BEGIN
  UPDATE pedidos_teste
  SET    valor = valor * 1.10
  WHERE  valor < 1000;

  v_rows := SQL%ROWCOUNT;

  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Reajuste aplicado em ' || v_rows || ' pedido(s).');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Nenhum pedido abaixo de 1000 encontrado.');
  END IF;

  COMMIT;
END;
/

-- ============================================================
-- SECAO 3: COMMIT, ROLLBACK E SAVEPOINT
-- ============================================================
-- COMMIT:     confirma todas as alteracoes pendentes da sessao
-- ROLLBACK:   desfaz todas as alteracoes nao confirmadas
-- ROLLBACK TO SAVEPOINT nome: desfaz ate o ponto de controle
-- SAVEPOINT nome: marca um ponto intermediario na transacao
--
-- ATENCAO: DDL (CREATE, DROP, ALTER) causa COMMIT implicito!
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO 4: SAVEPOINT - desfaz apenas parte da transacao
-- ------------------------------------------------------------
DECLARE
  v_id1 NUMBER;
  v_id2 NUMBER;
BEGIN
  v_id1 := seq_pedido.NEXTVAL;
  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (v_id1, 'MARTIN', 400.00);
  DBMS_OUTPUT.PUT_LINE('Inserido pedido ' || v_id1 || ' (MARTIN)');

  SAVEPOINT sp_apos_martin;  -- ponto de controle

  v_id2 := seq_pedido.NEXTVAL;
  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (v_id2, 'WARD', 200.00);
  DBMS_OUTPUT.PUT_LINE('Inserido pedido ' || v_id2 || ' (WARD)');

  -- Decisao: cancelar apenas o pedido de WARD
  ROLLBACK TO SAVEPOINT sp_apos_martin;
  DBMS_OUTPUT.PUT_LINE('ROLLBACK TO sp_apos_martin: pedido WARD desfeito');

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('COMMIT: pedido MARTIN confirmado');
END;
/

SELECT pedido_id, cliente, valor
FROM   pedidos_teste
ORDER  BY pedido_id;

-- ------------------------------------------------------------
-- EXEMPLO 5: ROLLBACK no bloco EXCEPTION
-- ------------------------------------------------------------
DECLARE
  v_id NUMBER;
BEGIN
  v_id := seq_pedido.NEXTVAL;

  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (v_id, 'BLAKE', 5000.00);

  -- Simular erro: inserir registro com mesmo ID (PK violation)
  INSERT INTO pedidos_teste (pedido_id, cliente, valor)
  VALUES (v_id, 'BLAKE_DUPLICADO', 5000.00);  -- ORA-00001

  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERRO: ID duplicado. Transacao desfeita (ROLLBACK).');
    DBMS_OUTPUT.PUT_LINE('SQLCODE = ' || SQLCODE);
END;
/

-- Confirmar que o pedido de BLAKE nao foi inserido
SELECT COUNT(*) AS total FROM pedidos_teste WHERE cliente = 'BLAKE';

-- ============================================================
-- SECAO 4: CONVERSAO DE TIPOS - IMPLICITA vs EXPLICITA
-- ============================================================
-- Oracle realiza conversao IMPLICITA em alguns casos automaticamente.
-- Mas conversao implicita pode causar erros sutis em producao.
-- A boa pratica e sempre usar conversao EXPLICITA (TO_CHAR, TO_NUMBER, etc.)
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO 6: Conversao implicita (funciona mas evite)
-- ------------------------------------------------------------
DECLARE
  v_numero  NUMBER;
  v_texto   VARCHAR2(10) := '1234';    -- string numerica
  v_data    DATE;
  v_data_str VARCHAR2(20) := '01/01/2024'; -- string de data
BEGIN
  -- Implicita: Oracle converte string '1234' para NUMBER automaticamente
  v_numero := v_texto + 100;  -- conversao implicita STRING -> NUMBER
  DBMS_OUTPUT.PUT_LINE('Implicita STRING->NUMBER: ' || v_numero);

  -- Implicita: Oracle converte string para DATE usando NLS_DATE_FORMAT
  -- PERIGOSO: depende das configuracoes NLS da sessao/banco
  -- v_data := v_data_str;  -- pode falhar em servidores com NLS diferente

  -- EXPLICITA: sempre seguro, independente de NLS
  v_data := TO_DATE(v_data_str, 'DD/MM/YYYY');
  DBMS_OUTPUT.PUT_LINE('Explicita STRING->DATE: ' || TO_CHAR(v_data, 'DD/MM/YYYY'));
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 7: Pegadinha da conversao implicita com WHERE
-- ------------------------------------------------------------
-- Se a coluna eh NUMBER e voce compara com VARCHAR2,
-- Oracle converte a coluna (nao o literal), o que pode
-- impedir o uso do indice e causar full table scan.

-- Correto (usa indice se existir):
--   WHERE empno = 7369          -- NUMBER = NUMBER
--   WHERE empno = TO_NUMBER('7369')  -- NUMBER = NUMBER

-- Errado (conversao implicita na coluna, sem indice):
--   WHERE TO_CHAR(empno) = '7369'   -- funcao na coluna = no index

-- Demonstracao:
DECLARE
  v_nome VARCHAR2(30);
  v_empno NUMBER := 7369;
BEGIN
  SELECT ename INTO v_nome
  FROM   emp
  WHERE  empno = v_empno;  -- correto: NUMBER = NUMBER
  DBMS_OUTPUT.PUT_LINE('Empregado: ' || v_nome);
END;
/

-- ============================================================
-- LIMPEZA
-- ============================================================
-- DROP TABLE pedidos_teste PURGE;
-- DROP SEQUENCE seq_pedido;
