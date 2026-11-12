-- =============================================================================
-- MÓDULO 04 - Gabarito 03
-- Tema: SQL%ROWCOUNT após UPDATE
-- =============================================================================

-- SET SERVEROUTPUT ON

-- BEGIN
--   UPDATE emp
--   SET    sal = sal * 1.15
--   WHERE  deptno = 30;

--   IF SQL%FOUND THEN
--     DBMS_OUTPUT.PUT_LINE('Salarios atualizados: ' || SQL%ROWCOUNT || ' funcionario(s).');
--   ELSE
--     DBMS_OUTPUT.PUT_LINE('Nenhum funcionario encontrado no departamento informado.');
--   END IF;

--   ROLLBACK;
-- END;
-- /
-- Resultado esperado: "Salarios atualizados: 6 funcionario(s)."
-- Para testar o ELSE: trocar deptno = 30 por deptno = 99
