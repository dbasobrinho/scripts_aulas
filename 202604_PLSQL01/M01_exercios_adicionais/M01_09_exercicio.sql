-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Exercicio M01_09 | Performance: 1 Bloco vs N Round Trips

-- ============================================================================

-- CONTEXTO :
-- "A utilizacao da PL/SQL pode reduzir o trafego na rede pelo envio de
--  um bloco contendo diversos comandos de SQL grupados em blocos para o
--  Oracle."
--
-- PERGUNTA:
-- Um sistema de folha de pagamento precisa, para cada funcionario:
--   1. Buscar o salario atual
--   2. Calcular o bonus
--   3. Atualizar o salario
--   4. Inserir registro no historico
--
-- Sem PL/SQL, a aplicacao envia cada SQL separadamente.
-- Quantos round trips de rede sao necessarios por funcionario
-- sem PL/SQL vs. com PL/SQL?
--
--   A) Sem PL/SQL: 1 round trip. Com PL/SQL: 4 round trips.
--
--   B) Sem PL/SQL: 4 round trips (1 por SQL).
--      Com PL/SQL: 1 round trip (o bloco completo e enviado de uma vez).
--
--   C) Sem PL/SQL e com PL/SQL: sempre 4 round trips, pois
--      cada SQL e processado individualmente de qualquer forma.
--
--   D) Nao ha diferenca de trafego de rede entre SQL e PL/SQL.
--
-- ============================================================================

-- Escreva sua resposta aqui:
-- Resposta: ___

-- Justificativa:
-- ...
