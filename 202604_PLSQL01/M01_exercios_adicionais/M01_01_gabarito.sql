-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Gabarito M01_01 | O que e PL/SQL - Definicao

-- ============================================================================

-- RESPOSTA CORRETA: B

-- EXPLICACAO:
-- A PL/SQL *estende* o SQL -- nao o substitui. Ela adiciona construcoes
-- procedurais (variaveis, IF, LOOP, EXCEPTION) ao ambiente Oracle.
-- Continuamos usando SQL DML (SELECT, INSERT, UPDATE, DELETE) dentro
-- dos blocos PL/SQL para manipular dados.
--
-- Definicao Oracle:
-- "Com ela, podemos usar comandos de SQL DML para manipular os dados
--  da base de dados Oracle e estabelecer fluxos de controle para
--  processar estes dados."
--
-- Por que as outras estao erradas:
--   A) Errada: PL/SQL usa SQL internamente; nao o substitui.
--   C) Errada: PL/SQL manipula dados via SQL DML integrado.
--   D) Errada: PL/SQL nao e produto independente (p.251 explica que
--      e um modulo executor instalado no Oracle Server ou nas ferramentas).
