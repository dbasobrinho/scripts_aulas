-- ============================================================
-- CURSO PL/SQL ORACLE | dbasobrinho.com.br
-- Modulo M02 - Fundamentos da Linguagem
-- Gabarito M02_09 | Escopo: Variavel Visivel em Bloco Aninhado
-- ============================================================
--
-- RESPOSTA CORRETA: B  ("WCHAR INTERNA-15")
--
-- JUSTIFICATIVA:
-- No sub-bloco interno, WNUM foi redeclarado com valor 10.
-- A referencia nao qualificada "WNUM" acessa a variavel LOCAL
-- do sub-bloco (nivel mais interno): WNUM = 10.
--
-- WUNICO foi declarado SOMENTE no bloco externo (nivel 5).
-- O sub-bloco herda a visibilidade de WUNICO = 5.
--
-- WTOTAL = WNUM + WUNICO = 10 + 5 = 15
--
-- WCHAR tambem foi redeclarada no sub-bloco com 'WCHAR INTERNA'.
-- A referencia local retorna 'WCHAR INTERNA'.
--
-- Portanto: :MSG = 'WCHAR INTERNA' || '-' || 15 = 'WCHAR INTERNA-15'
-- ============================================================

VARIABLE MSG VARCHAR2(200)
-- DECLARE
  WNUM   NUMBER       := 12;
  WCHAR  VARCHAR2(20) := 'WCHAR EXTERNA';
  WUNICO NUMBER       := 5;
-- BEGIN
--   DECLARE
    WNUM   NUMBER       := 10;
    WCHAR  VARCHAR2(20) := 'WCHAR INTERNA';
    WTOTAL NUMBER;
--   BEGIN
    WTOTAL := WNUM + WUNICO;   -- 10 + 5 = 15
    :MSG   := WCHAR || '-' || WTOTAL;
--   END;
-- END;
/
PRINT MSG
-- Resultado: WCHAR INTERNA-15
-- ============================================================
