-- ============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- Modulo M03 - Estruturas de Controle
-- Desafio Final | Simulador de Progressao Salarial por Faixa
-- ============================================================================
-- OBJETIVO:
--   Integrar em um unico bloco PL/SQL TODAS as estruturas de controle do M03:
--   IF, CASE, FOR LOOP (cursor implicito), WHILE LOOP e contadores.
-- ============================================================================
-- PRE-REQUISITOS:
--   - Schema EMP disponivel (SCOTT)
--   - SET SERVEROUTPUT ON
-- ============================================================================
-- TAREFA:
--
--   Para CADA funcionario da tabela EMP, simule quantos reajustes anuais
--   ele precisa para DOBRAR o salario atual, conforme a faixa dele.
--
--   1. Percorra EMP com FOR ... IN (SELECT ...) LOOP  (cursor implicito),
--      ordenado por salario decrescente.
--
--   2. Classifique cada funcionario com CASE pesquisado, definindo tambem
--      o percentual de reajuste anual de cada faixa:
--        SENIOR : sal > 4000            -> reajuste 5%  ao ano
--        PLENO  : sal > 2500 e <= 4000  -> reajuste 8%  ao ano
--        JUNIOR : sal <= 2500           -> reajuste 12% ao ano
--
--   3. Com um WHILE LOOP, simule os reajustes ano a ano ate o salario
--      simulado atingir (ou ultrapassar) o DOBRO do salario original.
--      Conte quantos anos foram necessarios (v_anos).
--
--   4. Use um IF para marcar como 'RAPIDO' quem dobra em ate 8 anos e
--      'LENTO' caso contrario.
--
--   5. Acumule contadores por faixa (quantos SENIOR, PLENO, JUNIOR) e
--      tambem a soma total de anos simulados (para calcular a media).
--
--   6. Imprima uma linha por funcionario no formato:
--        Nome         | Classe | Sal atual | Anos p/ dobrar | Ritmo
--
--   7. Ao final, exiba o painel de totais:
--        - Quantidade em cada faixa (SENIOR / PLENO / JUNIOR)
--        - Media de anos para dobrar (total de anos / total de funcionarios)
--
-- ============================================================================
-- RESTRICOES:
--   - Use %TYPE onde fizer sentido (ename, sal)
--   - O contador do FOR nao pode ser usado; o WHILE controla os anos
--   - CASE deve ser PESQUISADO (WHEN condicao), fechado com END CASE;
--   - Formate os numeros com TO_CHAR e alinhe colunas com RPAD/LPAD
-- ============================================================================

SET SERVEROUTPUT ON

-- Escreva seu bloco PL/SQL aqui:

DECLARE
  -- variaveis do funcionario (use %TYPE)
  ...

  -- variaveis de simulacao (salario simulado, percentual, anos, ritmo)
  ...

  -- contadores por faixa e acumulador de anos
  ...
BEGIN
  -- Cabecalho do relatorio
  ...

  FOR r IN (SELECT ename, sal FROM emp ORDER BY sal DESC) LOOP
    -- 2. CASE pesquisado: define classe e percentual
    ...

    -- 3. WHILE: simula reajustes ate dobrar
    ...

    -- 4. IF: classifica o ritmo
    ...

    -- 5. Atualiza contadores
    ...

    -- 6. Imprime a linha do funcionario
    ...
  END LOOP;

  -- 7. Painel de totais e media
  ...
END;
/
