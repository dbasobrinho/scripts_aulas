-- ============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- Modulo M03 - Estruturas de Controle
-- Desafio Final | GABARITO - Simulador de Progressao Salarial por Faixa
-- ============================================================================

SET SERVEROUTPUT ON

DECLARE
  -- Variaveis do funcionario (ancoradas com %TYPE)
  v_nome   emp.ename%TYPE;
  v_sal    emp.sal%TYPE;

  -- Simulacao
  v_pct    NUMBER;             -- percentual de reajuste anual da faixa
  v_class  VARCHAR2(10);       -- SENIOR / PLENO / JUNIOR
  v_sim    NUMBER(12,2);       -- salario simulado ano a ano
  v_anos   NUMBER;             -- anos ate dobrar
  v_ritmo  VARCHAR2(10);       -- RAPIDO / LENTO

  -- Contadores por faixa e acumuladores
  v_senior   NUMBER := 0;
  v_pleno    NUMBER := 0;
  v_junior   NUMBER := 0;
  v_tot_anos NUMBER := 0;
  v_tot_func NUMBER := 0;
BEGIN
  -- Cabecalho do relatorio
  DBMS_OUTPUT.PUT_LINE(
    RPAD('Nome', 8)   || ' | ' || RPAD('Classe', 6) || ' | ' ||
    LPAD('Sal atual', 9) || ' | ' || LPAD('Anos p/ dobrar', 14) || ' | Ritmo');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));

  -- 1. Percorre EMP com FOR + cursor implicito
  FOR r IN (SELECT ename, sal FROM emp ORDER BY sal DESC) LOOP
    v_nome := r.ename;
    v_sal  := r.sal;

    -- 2. CASE pesquisado: define classe, percentual e conta a faixa
    CASE
      WHEN v_sal > 4000 THEN
        v_class := 'SENIOR'; v_pct := 0.05; v_senior := v_senior + 1;
      WHEN v_sal > 2500 THEN
        v_class := 'PLENO';  v_pct := 0.08; v_pleno  := v_pleno  + 1;
      ELSE
        v_class := 'JUNIOR'; v_pct := 0.12; v_junior := v_junior + 1;
    END CASE;

    -- 3. WHILE: simula reajustes ate dobrar o salario
    v_sim  := v_sal;
    v_anos := 0;
    WHILE v_sim < v_sal * 2 LOOP
      v_sim  := v_sim * (1 + v_pct);
      v_anos := v_anos + 1;
    END LOOP;

    -- 4. IF: classifica o ritmo
    IF v_anos <= 8 THEN
      v_ritmo := 'RAPIDO';
    ELSE
      v_ritmo := 'LENTO';
    END IF;

    -- 5. Acumula totais
    v_tot_anos := v_tot_anos + v_anos;
    v_tot_func := v_tot_func + 1;

    -- 6. Linha do funcionario
    DBMS_OUTPUT.PUT_LINE(
      RPAD(INITCAP(v_nome), 8) || ' | ' ||
      RPAD(v_class, 6)         || ' | ' ||
      LPAD(TO_CHAR(v_sal, 'FM9990'), 9) || ' | ' ||
      LPAD(v_anos, 14)         || ' | ' || v_ritmo);
  END LOOP;

  -- 7. Painel de totais e media
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 60, '='));
  DBMS_OUTPUT.PUT_LINE('Totais por faixa:');
  DBMS_OUTPUT.PUT_LINE('  SENIOR : ' || v_senior);
  DBMS_OUTPUT.PUT_LINE('  PLENO  : ' || v_pleno);
  DBMS_OUTPUT.PUT_LINE('  JUNIOR : ' || v_junior);
  DBMS_OUTPUT.PUT_LINE('Funcionarios : ' || v_tot_func);
  DBMS_OUTPUT.PUT_LINE(
    'Media de anos para dobrar : ' ||
    TO_CHAR(ROUND(v_tot_anos / v_tot_func, 1), 'FM990.0'));
END;
/

-- ============================================================================
-- SAIDA ESPERADA (schema SCOTT.EMP padrao, 14 funcionarios)
-- Obs.: o reajuste dobra o salario em N anos que so depende do percentual da
--       faixa, entao TODO SENIOR = 15, TODO PLENO = 10 e TODO JUNIOR = 7 anos.
--       (5%/ano -> 15 | 8%/ano -> 10 | 12%/ano -> 7). Empates de salario
--       (Ford/Scott = 3000; Ward/Martin = 1250) podem trocar de ordem.
--
-- Nome     | Classe | Sal atual | Anos p/ dobrar | Ritmo
-- ------------------------------------------------------------
-- King     | SENIOR |      5000 |             15 | LENTO
-- Ford     | PLENO  |      3000 |             10 | LENTO
-- Scott    | PLENO  |      3000 |             10 | LENTO
-- Jones    | PLENO  |      2975 |             10 | LENTO
-- Blake    | PLENO  |      2850 |             10 | LENTO
-- Clark    | JUNIOR |      2450 |              7 | RAPIDO
-- Allen    | JUNIOR |      1600 |              7 | RAPIDO
-- Turner   | JUNIOR |      1500 |              7 | RAPIDO
-- Miller   | JUNIOR |      1300 |              7 | RAPIDO
-- Ward     | JUNIOR |      1250 |              7 | RAPIDO
-- Martin   | JUNIOR |      1250 |              7 | RAPIDO
-- Adams    | JUNIOR |      1100 |              7 | RAPIDO
-- James    | JUNIOR |       950 |              7 | RAPIDO
-- Smith    | JUNIOR |       800 |              7 | RAPIDO
-- ============================================================
-- Totais por faixa:
--   SENIOR : 1
--   PLENO  : 4
--   JUNIOR : 9
-- Funcionarios : 14
-- Media de anos para dobrar : 8.4     (118 anos / 14 = 8,43)
-- ============================================================================
