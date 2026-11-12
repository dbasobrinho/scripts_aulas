-- =============================================================================
-- MÓDULO 04 - Gabarito 12
-- Tema: FOR UPDATE com WAIT + DELETE via WHERE CURRENT OF
-- Tipo: Código
-- Nível: Intermediário-Avançado
-- Schema: EMP
-- Ref: 1Z0-149 Topic 6 - FOR UPDATE / WHERE CURRENT OF
-- =============================================================================

-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR c_vendedores IS
--     SELECT empno, ename, job, comm
--     FROM   emp
--     WHERE  job  = 'SALESMAN'
--     AND    comm IS NOT NULL
--     FOR UPDATE OF comm WAIT 5;

--   v_deletados   NUMBER := 0;
--   v_atualizados NUMBER := 0;
-- BEGIN
--   DBMS_OUTPUT.PUT_LINE('=== Revisao de Comissao - Vendedores ===');

--   FOR r IN c_vendedores LOOP
--     IF r.comm < 300 THEN
--       DELETE FROM emp WHERE CURRENT OF c_vendedores;
--       v_deletados := v_deletados + 1;
--       DBMS_OUTPUT.PUT_LINE('DELETE: ' || INITCAP(r.ename)
--         || ' (comm=' || r.comm || ') - comissao abaixo do minimo');

--     ELSIF r.comm <= 600 THEN
--       UPDATE emp SET comm = r.comm * 1.20 WHERE CURRENT OF c_vendedores;
--       v_atualizados := v_atualizados + 1;
--       DBMS_OUTPUT.PUT_LINE('UPDATE +20%: ' || INITCAP(r.ename)
--         || ' ' || r.comm || ' -> ' || ROUND(r.comm * 1.20, 2));

--     ELSE
--       UPDATE emp SET comm = r.comm * 1.10 WHERE CURRENT OF c_vendedores;
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
--     IF SQLCODE IN (-54, -30006) THEN
--       DBMS_OUTPUT.PUT_LINE('Erro de lock: SQLCODE=' || SQLCODE
--         || ' - ' || SQLERRM);
--       ROLLBACK;
--     ELSE
--       RAISE;
--     END IF;
-- END;
-- /

-- =============================================================================
-- SAIDA ESPERADA (Schema EMP padrao - vendedores):
-- =============================================================================
-- === Revisao de Comissao - Vendedores ===
-- UPDATE +20%: Allen 300 -> 360
-- UPDATE +20%: Ward 500 -> 600
-- UPDATE +10%: Martin 1400 -> 1540
-- DELETE: Turner (comm=0) - comissao abaixo do minimo
-- Deletados:   1
-- Atualizados: 3
-- ROLLBACK aplicado.
-- =============================================================================
-- (Saída real, conferida no Oracle 26ai em 09/11/2026.)
-- Obs.: Allen tem COMM = 300, que é a borda da faixa 300-600. Por isso ganha +20%.
-- Turner tem COMM = 0 (< 300) e é deletado. O ROLLBACK no fim desfaz o DELETE.
-- =============================================================================
-- PONTOS DE ATENCAO:
--   1. WAIT 5: aguarda até 5 segundos antes de levantar ORA-30006.
--      Util em sistemas com transações curtas onde o lock pode ser liberado
--      em instantes. Em batch de longa duracao, prefira NOWAIT + retry.
--   2. Um cursor FOR UPDATE pode ser usado tanto em UPDATE quanto em DELETE
--      dentro do mesmo loop - a referência WHERE CURRENT OF funciona para ambos.
--   3. O ROLLBACK no bloco EXCEPTION também libera os locks, mesmo que o
--      cursor não tenha sido fechado explicitamente.
--   4. Cuidado com DELETE dentro de cursor FOR loop: voce está iterando sobre
--      um conjunto de linhas e deletando algumas. Oracle mantem o rowset
--      original (snapshot) enquanto o cursor está aberto com FOR UPDATE,
--      então o comportamento e previsivel.
-- =============================================================================
