-- =============================================================================
-- MÓDULO 04 - Exercício 12
-- Tema: FOR UPDATE com WAIT + DELETE via WHERE CURRENT OF
-- Tipo: Código
-- Nível: Intermediário-Avançado
-- Schema: EMP
-- Ref: 1Z0-149 Topic 6 - FOR UPDATE / WHERE CURRENT OF
-- =============================================================================
-- TAREFA:
-- Escreva um bloco anônimo que:
--   1. Declare um cursor que selecione EMPNO, ENAME, JOB, COMM de EMP
--      apenas para funcionários que tenham comissão (COMM IS NOT NULL)
--      e cujo JOB seja 'SALESMAN'
--      Use FOR UPDATE OF comm com WAIT 5 (espera até 5 segundos)
--   2. Trate no bloco externo a exceção de timeout de lock (SQLCODE -30006)
--      e a exceção de recurso ocupado (SQLCODE -54), exibindo mensagem
--      adequada e fazendo ROLLBACK
--   3. Dentro do loop, aplique a seguinte lógica usando WHERE CURRENT OF:
--      - Se COMM < 300: remova o funcionário (DELETE) - comissão muito baixa
--      - Se COMM entre 300 e 600: atualize COMM para COMM * 1.20
--      - Se COMM > 600: atualize COMM para COMM * 1.10
--   4. Exiba para cada funcionário a ação tomada (DELETE, UPDATE +20%, UPDATE +10%)
--   5. Exiba totais: quantos deletados, quantos atualizados
--   6. Aplique ROLLBACK ao final
-- =============================================================================
-- DICAS:
--   - Declare o cursor na secao DECLARE, não como variável de cursor
--   - WAIT 5 levanta ORA-30006 após 5 segundos sem conseguir lock
--   - Tanto UPDATE quanto DELETE aceitam WHERE CURRENT OF no mesmo cursor
--   - Um mesmo cursor pode ter UPDATE em alguns loops e DELETE em outros
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_vendedores IS
--     SELECT empno, ename, job, comm
--     FROM   emp
--     WHERE  job  = ...
--     AND    comm IS NOT NULL
--     FOR UPDATE OF ... WAIT 5;

--   v_deletados   NUMBER := 0;
--   v_atualizados NUMBER := 0;
-- BEGIN
--   DBMS_OUTPUT.PUT_LINE('=== Revisao de Comissao - Vendedores ===');

--   FOR r IN c_vendedores LOOP
--     IF r.comm < 300 THEN
--       DELETE FROM emp WHERE CURRENT OF ...;
--       v_deletados := v_deletados + 1;
--       DBMS_OUTPUT.PUT_LINE('DELETE: ' || INITCAP(r.ename)
--         || ' (comm=' || r.comm || ') - comissao abaixo do minimo');

--     ELSIF r.comm <= 600 THEN
--       UPDATE emp SET comm = r.comm * ... WHERE CURRENT OF ...;
--       v_atualizados := v_atualizados + 1;
--       DBMS_OUTPUT.PUT_LINE('UPDATE +20%: ' || INITCAP(r.ename)
--         || ' ' || r.comm || ' -> ' || ROUND(r.comm * 1.20, 2));

--     ELSE
--       UPDATE emp SET comm = r.comm * ... WHERE CURRENT OF ...;
--       v_atualizados := v_atualizados + 1;
--       DBMS_OUTPUT.PUT_LINE('UPDATE +10%: ' || INITCAP(r.ename)
--         || ' ' || r.comm || ' -> ' || ROUND(r.comm * 1.10, 2));
--     END IF;
--   END LOOP;

--   DBMS_OUTPUT.PUT_LINE('');
--   DBMS_OUTPUT.PUT_LINE('Deletados:   ' || v_deletados);
--   DBMS_OUTPUT.PUT_LINE('Atualizados: ' || v_atualizados);

--   ROLLBACK;
--   DBMS_OUTPUT.PUT_LINE('ROLLBACK aplicado.');

-- EXCEPTION
--   WHEN OTHERS THEN
--     IF SQLCODE IN (..., ...) THEN
--       DBMS_OUTPUT.PUT_LINE('Erro de lock: SQLCODE=' || SQLCODE);
--       ROLLBACK;
--     ELSE
--       RAISE;
--     END IF;
-- END;
-- /
