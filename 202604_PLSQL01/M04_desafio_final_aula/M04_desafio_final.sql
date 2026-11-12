-- ============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- Módulo M04 - Cursores
-- Desafio Final | Fechamento da Folha com Reajuste por Faixa
-- ============================================================================
-- OBJETIVO:
--   Integrar em um único bloco PL/SQL os principais recursos de cursor do M04:
--   cursor FOR LOOP, cursor explícito parametrizado (OPEN/FETCH/CLOSE),
--   %ROWTYPE, FOR UPDATE + WHERE CURRENT OF, SQL%ROWCOUNT, c%ROWCOUNT
--   e SYS_REFCURSOR.
-- ============================================================================
-- PRÉ-REQUISITOS:
--   - Schema EMP/DEPT disponível (SCOTT)
--   - SET SERVEROUTPUT ON
-- ============================================================================
-- TAREFA:
--
--   O RH quer SIMULAR um reajuste por faixa salarial, departamento por
--   departamento, e ver o impacto na folha. Nada pode ficar gravado.
--
--   1. Declare um cursor c_dept (DEPT ordenado por deptno) e percorra-o
--      com cursor FOR LOOP. Imprima: DEPT nn - DNAME (LOC)
--
--   2. Declare um cursor PARAMETRIZADO c_emp(p_deptno) que traga
--      empno, ename e sal dos funcionários do departamento,
--      ORDER BY sal DESC, ename  e  FOR UPDATE OF sal.
--
--   3. Para cada departamento, abra c_emp com OPEN/FETCH/CLOSE explícitos
--      (NÃO use FOR LOOP aqui), lendo cada linha num registro c_emp%ROWTYPE.
--
--   4. Regra de reajuste (CASE pesquisado):
--        sal <  1500           -> +10%
--        sal >= 1500 e < 3000  -> +5%
--        sal >= 3000           -> sem reajuste
--
--   5. Quando houver reajuste, grave com
--        UPDATE emp SET sal = ... WHERE CURRENT OF c_emp;
--      e conte as linhas atualizadas somando SQL%ROWCOUNT.
--
--   6. Imprima uma linha por funcionário:
--        Nome      sal_atual -> sal_novo  (+10% | +5% | sem reajuste)
--
--   7. Antes do CLOSE, guarde c_emp%ROWCOUNT (funcionários lidos).
--      Se for 0, imprima "(sem funcionarios)". Senão imprima:
--        Funcionarios: n | Reajustados: n
--        Folha antes: x | depois: y | aumento: z
--
--   8. Ao final: totais gerais (funcionários, reajustados, aumento total),
--      ROLLBACK, e confirme com um SYS_REFCURSOR (OPEN ... FOR
--      SELECT SUM(sal) FROM emp) que a folha voltou ao valor original.
--
-- ============================================================================
-- RESTRIÇÕES:
--   - Use %TYPE / %ROWTYPE (nada de declarar coluna a coluna "na mao")
--   - O cursor de funcionários DEVE ser explícito com OPEN/FETCH/CLOSE
--   - O UPDATE DEVE usar WHERE CURRENT OF (nada de WHERE empno = ...)
--   - Formate valores com TO_CHAR(.., 'FM99990.00') e alinhe com RPAD/LPAD
-- ============================================================================
-- PERGUNTAS PARA PENSAR (respostas no gabarito):
--   a) Por que guardar c_emp%ROWCOUNT ANTES do CLOSE?
--   b) O que acontece se tirar o FOR UPDATE OF sal do cursor?
--   c) Quando o lock das linhas é liberado: no CLOSE ou no ROLLBACK?
-- ============================================================================

SET SERVEROUTPUT ON

-- Escreva seu bloco PL/SQL aqui:

DECLARE
  -- 1. cursor de departamentos
  ...

  -- 2. cursor parametrizado de funcionários com FOR UPDATE OF sal
  ...

  -- registro do funcionário (%ROWTYPE do cursor) e variáveis de cálculo
  ...

  -- acumuladores por departamento e gerais
  ...

  -- REF CURSOR para a conferência final
  ...
BEGIN
  -- Cabeçalho
  ...

  FOR r_dept IN c_dept LOOP
    -- zera acumuladores do departamento
    ...

    OPEN c_emp(...);
    LOOP
      FETCH ...;
      EXIT WHEN ...;

      -- 4. CASE: percentual da faixa
      ...

      -- 5. UPDATE ... WHERE CURRENT OF + SQL%ROWCOUNT
      ...

      -- 6. linha do funcionário
      ...
    END LOOP;
    -- 7. guarda %ROWCOUNT ANTES de fechar
    ...
    CLOSE c_emp;

    -- resumo do departamento
    ...
  END LOOP;

  -- 8. totais, ROLLBACK e conferência via SYS_REFCURSOR
  ...
END;
/
