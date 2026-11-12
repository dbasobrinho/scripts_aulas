-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 04  |  Aula: A04_05  |  Slide 08
-- Tema: Cursor Parametrizado - recebe parâmetros no OPEN
-- Versão: 1.0  |  2026-04-26
-- Pré-req: M01, M02, M03, Schema EMP
-- =============================================================================
-- Um cursor parametrizado aceita valores no OPEN, tornando-o reutilizável.
-- Sintaxe: CURSOR nome (param tipo) IS SELECT ...;
-- Abertura: OPEN nome (valor);
-- Pode ser aberto, fechado e reaberto com parâmetros diferentes.
-- =============================================================================

SET SERVEROUTPUT ON
SET DEFINE ON

-- ------------------------------------------------------------
-- EXEMPLO 1: Cursor com 1 parâmetro - filtro por departamento
-- ------------------------------------------------------------
DECLARE
  CURSOR c_emp (p_deptno NUMBER) IS
    SELECT ename, sal, job
    FROM   emp
    WHERE  deptno = p_deptno
    ORDER  BY sal DESC;

  v_rec c_emp%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== DEPT 10 ===');
  OPEN c_emp(10);
  LOOP
    FETCH c_emp INTO v_rec;
    EXIT WHEN c_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_rec.ename), 12) || TO_CHAR(v_rec.sal, 'FM$99990.00'));
  END LOOP;
  CLOSE c_emp;

  DBMS_OUTPUT.PUT_LINE('=== DEPT 20 ===');
  OPEN c_emp(20);
  LOOP
    FETCH c_emp INTO v_rec;
    EXIT WHEN c_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(v_rec.ename), 12) || TO_CHAR(v_rec.sal, 'FM$99990.00'));
  END LOOP;
  CLOSE c_emp;
END;
/

-- ------------------------------------------------------------
-- EXEMPLO 2: Cursor com 2 parâmetros - dept e salário mínimo
-- ------------------------------------------------------------
-- VALORES PARA TESTAR (o script pede DEPTNO e depois SAL_MIN):
--   30 / 1500 -> Blake, Allen, Turner          (3 funcionários)
--   20 / 2000 -> Scott, Ford, Jones            (3 funcionários)
--   10 / 0    -> King, Clark, Miller           (3 funcionários)
--   40 / 0    -> nenhuma linha: o FOR não executa nenhuma vez
-- ------------------------------------------------------------
DECLARE
  CURSOR c_filtro (p_deptno NUMBER, p_sal_min NUMBER) IS
    SELECT ename, sal, job
    FROM   emp
    WHERE  deptno  = p_deptno
    AND    sal     >= p_sal_min
    ORDER  BY sal DESC;

  v_count NUMBER := 0;
BEGIN
  -- duplo e-comercial: pede cada valor uma vez só; o FOR abaixo reaproveita
  DBMS_OUTPUT.PUT_LINE('Funcionarios do dept &&dept_filtro com sal >= &&sal_min:');
  DBMS_OUTPUT.PUT_LINE('---');

  FOR rec IN c_filtro(&dept_filtro, &sal_min) LOOP
    v_count := v_count + 1;
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(rec.ename), 12) || RPAD(rec.job, 12) || TO_CHAR(rec.sal, 'FM$99990.00'));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('---');
  DBMS_OUTPUT.PUT_LINE('Total: ' || v_count || ' funcionario(s).');
END;
/
UNDEFINE dept_filtro
UNDEFINE sal_min

-- ------------------------------------------------------------
-- EXEMPLO 3: Cursor com parâmetro e valor default
-- ------------------------------------------------------------
DECLARE
  CURSOR c_top (p_deptno NUMBER, p_limite NUMBER DEFAULT 3) IS
    SELECT ename, sal
    FROM   (SELECT ename, sal FROM emp WHERE deptno = p_deptno ORDER BY sal DESC)
    WHERE  ROWNUM <= p_limite;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Top 3 salarios dept 20:');
  FOR rec IN c_top(20) LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(rec.ename), 12) || TO_CHAR(rec.sal, 'FM$99990.00'));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Top 2 salarios dept 30:');
  FOR rec IN c_top(30, 2) LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(INITCAP(rec.ename), 12) || TO_CHAR(rec.sal, 'FM$99990.00'));
  END LOOP;
END;
/
