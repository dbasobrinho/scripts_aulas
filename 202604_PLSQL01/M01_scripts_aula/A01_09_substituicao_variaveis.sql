-- ============================================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M01 - Introducao ao PL/SQL
-- Script A01_09 | Variaveis de Substituicao (&) no SQL*Plus
-- ============================================================================
-- Objetivo: demonstrar o uso de & (e &&) para passar valores dinamicos
--           a blocos PL/SQL diretamente no SQL*Plus / SQLcl.
-- ============================================================================
-- CONCEITO:
--   O & nao e PL/SQL puro — e um recurso do SQL*Plus (e SQLcl).
--   Antes de enviar o bloco ao Oracle, o SQL*Plus substitui &variavel
--   pelo valor digitado pelo usuario. O Oracle recebe o bloco ja
--   com o valor embutido — como se voce tivesse digitado na mao.
--
--   & variavel  --> solicita o valor CADA VEZ que aparece no bloco
--   && variavel --> solicita o valor UMA VEZ e reutiliza no mesmo bloco
--
--   ACCEPT nome PROMPT 'texto: '  --> define prompt customizado
--   SET VERIFY ON/OFF              --> mostra/oculta "old/new" da substituicao
--   SET DEFINE OFF                 --> desativa o & (util em senhas com &)
-- ============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF

-- ============================================================================
-- EXEMPLO 1: & simples — valor entrado pelo usuario
-- ============================================================================
-- Ao executar, o SQL*Plus vai perguntar: "Enter value for v_nome:"
-- O valor digitado substitui &v_nome antes do bloco chegar ao Oracle.

PROMPT === EXEMPLO 1: simples ===

DECLARE
   v_nome   VARCHAR2(50) := '&v_nome';
BEGIN
   DBMS_OUTPUT.PUT_LINE('Ola, ' || v_nome || '! Bem-vindo ao PL/SQL.');
END;
/


-- ============================================================================
-- EXEMPLO 2: && duplo — entra uma vez, reutiliza no mesmo bloco
-- ============================================================================
-- &&v_linguagem so pergunta UMA VEZ mesmo aparecendo duas vezes no bloco.

PROMPT === EXEMPLO 2: duplo (uma entrada, dois usos) ===

DECLARE
   v_linguagem   VARCHAR2(30) := '&&v_linguagem';
   v_msg         VARCHAR2(100);
BEGIN
   v_msg := 'Aprendendo ' || v_linguagem || ' com DBA Sobrinho!';
   DBMS_OUTPUT.PUT_LINE(v_msg);
   DBMS_OUTPUT.PUT_LINE('Linguagem escolhida: ' || '&&v_linguagem');
END;
/

-- Limpa a definicao de &&v_linguagem para nao reutilizar na proxima execucao
UNDEFINE v_linguagem


-- ============================================================================
-- EXEMPLO 3: ACCEPT com prompt customizado e tipo
-- ============================================================================
-- ACCEPT da mais controle: define o nome, tipo, prompt e valor default.
-- Sintaxe: ACCEPT variavel [TYPE tipo] [DEFAULT valor] PROMPT 'texto'

PROMPT === EXEMPLO 3: ACCEPT com prompt customizado ===

ACCEPT v_salario  NUMBER          PROMPT 'Informe o salario base: '
ACCEPT v_bonus    NUMBER DEFAULT 10 PROMPT 'Percentual de bonus [default 10]: '

DECLARE
   v_sal_base    NUMBER := &v_salario;
   v_perc_bonus  NUMBER := &v_bonus;
   v_total       NUMBER;
BEGIN
   v_total := v_sal_base * (1 + v_perc_bonus / 100);
   DBMS_OUTPUT.PUT_LINE('Salario base  : R$ ' || TO_CHAR(v_sal_base,   '999,990.00'));
   DBMS_OUTPUT.PUT_LINE('Bonus (' || v_perc_bonus || '%)   : R$ ' ||
                         TO_CHAR(v_total - v_sal_base, '999,990.00'));
   DBMS_OUTPUT.PUT_LINE('Total         : R$ ' || TO_CHAR(v_total,      '999,990.00'));
END;
/


-- ============================================================================
-- EXEMPLO 4: & em valor numerico (sem aspas)
-- ============================================================================
-- Para NUMBER: sem aspas simples.
-- Para VARCHAR2/CHAR: com aspas simples ao redor do &.

PROMPT === EXEMPLO 4: tipo numerico (sem aspas) ===

DECLARE
   v_a    NUMBER := &primeiro_numero;
   v_b    NUMBER := &segundo_numero;
   v_soma NUMBER;
BEGIN
   v_soma := v_a + v_b;
   DBMS_OUTPUT.PUT_LINE(v_a || ' + ' || v_b || ' = ' || v_soma);
END;
/


-- ============================================================================
-- EXEMPLO 5: SET DEFINE OFF — quando o & faz parte do dado
-- ============================================================================
-- Se o dado contem & (ex: "Pesquisa & Desenvolvimento"), o SQL*Plus
-- tentaria fazer substituicao. SET DEFINE OFF desativa isso.

PROMPT === EXEMPLO 5: SET DEFINE OFF ===

SET DEFINE OFF

DECLARE
   v_empresa   VARCHAR2(50) := 'Pesquisa & Desenvolvimento';
BEGIN
   DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_empresa);
END;
/

-- Reativa o comportamento padrao
SET DEFINE ON


-- ============================================================================
-- RESUMO
-- ============================================================================
-- &var          → substitui e pergunta cada vez que aparece
-- &&var         → substitui e pergunta so uma vez (reutiliza)
-- ACCEPT        → prompt customizado com tipo e default
-- SET VERIFY OFF→ oculta as linhas "old/new" da substituicao
-- SET DEFINE OFF→ desativa & (para dados que contem o caractere)
-- UNDEFINE var  → limpa o valor armazenado de &&var
-- ============================================================================
