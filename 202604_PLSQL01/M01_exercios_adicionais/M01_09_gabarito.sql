-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_09 | Performance: 1 Bloco vs N Round Trips

-- ============================================================================

-- RESPOSTA CORRETA: B

-- EXPLICACAO:
-- Sem PL/SQL: a aplicacao envia cada comando SQL separadamente ao banco.
-- Para 4 operacoes = 4 chamadas de rede (4 round trips).
--
-- Com PL/SQL: a aplicacao envia UM unico bloco contendo todos os comandos.
-- O Oracle processa os 4 SQLs internamente e retorna apenas o resultado.
-- Resultado: 1 round trip independentemente de quantos SQLs estao no bloco.
--
-- Definicao Oracle:
-- "A utilizacao da PL/SQL pode reduzir o trafego na rede pelo envio de
--  um bloco contendo diversos comandos de SQL grupados em blocos para o Oracle."
--
-- Complemento :
-- "A PL/SQL tambem adiciona performance as ferramentas que possuem um
--  modulo executor local, pois nao necessitam enviar comandos de PL/SQL
--  para serem processados pelo servidor, sendo enviados apenas os
--  comandos de SQL."

SET SERVEROUTPUT ON

-- Demonstracao do conceito:
DECLARE
   v_empno    NUMBER := 7788;
   v_sal      NUMBER := 3000;
   v_bonus    NUMBER;
BEGIN
   -- Todos os passos em 1 bloco = 1 round trip
   v_bonus := v_sal * 0.10;
   DBMS_OUTPUT.PUT_LINE('Salario : ' || v_sal);
   DBMS_OUTPUT.PUT_LINE('Bonus   : ' || v_bonus);
   DBMS_OUTPUT.PUT_LINE('Total   : ' || (v_sal + v_bonus));
   DBMS_OUTPUT.PUT_LINE('--- tudo processado em 1 unico bloco ---');
END;
/
