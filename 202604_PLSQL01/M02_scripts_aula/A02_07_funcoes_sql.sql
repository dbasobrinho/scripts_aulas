-- =============================================================================
-- CURSO PL/SQL ORACLE 19c  |  dbasobrinho.com.br
-- =============================================================================
-- Módulo 02  |  Aula: A02_07  |  Slide 09
-- Tema: Funções SQL dentro do PL/SQL
-- Versão: 1.0  |  2026-04-26
-- Pré-req: A02_01
-- =============================================================================
-- O QUE DEMONSTRA:
--   Funções de linha única (texto, número, data, conversão, nulo)
--   são usadas diretamente em expressões PL/SQL.
-- =============================================================================

SET SERVEROUTPUT ON

DECLARE
  v_nome    VARCHAR2(30) := 'maria silva';
  v_num     NUMBER       := -3.14159;
  v_data    DATE         := SYSDATE;
  v_sal     NUMBER       := NULL;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== FUNCOES DE TEXTO ===');
  DBMS_OUTPUT.PUT_LINE('UPPER   : ' || UPPER(v_nome));
  DBMS_OUTPUT.PUT_LINE('INITCAP : ' || INITCAP(v_nome));
  DBMS_OUTPUT.PUT_LINE('LENGTH  : ' || LENGTH(v_nome));
  DBMS_OUTPUT.PUT_LINE('SUBSTR  : ' || SUBSTR(v_nome, 1, 5));
  DBMS_OUTPUT.PUT_LINE('REPLACE : ' || REPLACE(v_nome, 'silva', 'souza'));
  DBMS_OUTPUT.PUT_LINE('TRIM    : [' || TRIM('  Oracle  ') || ']');
  DBMS_OUTPUT.PUT_LINE('LPAD    : ' || LPAD('42', 8, '0'));

  DBMS_OUTPUT.PUT_LINE('=== FUNCOES NUMERICAS ===');
  DBMS_OUTPUT.PUT_LINE('ABS     : ' || ABS(v_num));
  DBMS_OUTPUT.PUT_LINE('ROUND   : ' || ROUND(v_num, 2));
  DBMS_OUTPUT.PUT_LINE('TRUNC   : ' || TRUNC(v_num, 2));
  DBMS_OUTPUT.PUT_LINE('CEIL    : ' || CEIL(v_num));
  DBMS_OUTPUT.PUT_LINE('FLOOR   : ' || FLOOR(v_num));

  DBMS_OUTPUT.PUT_LINE('=== FUNCOES DE DATA ===');
  DBMS_OUTPUT.PUT_LINE('SYSDATE           : ' || TO_CHAR(v_data, 'DD/MM/YYYY'));
  DBMS_OUTPUT.PUT_LINE('ADD_MONTHS(+3)    : ' || TO_CHAR(ADD_MONTHS(v_data, 3), 'DD/MM/YYYY'));
  DBMS_OUTPUT.PUT_LINE('LAST_DAY          : ' || TO_CHAR(LAST_DAY(v_data), 'DD/MM/YYYY'));
  DBMS_OUTPUT.PUT_LINE('TRUNC(data)       : ' || TO_CHAR(TRUNC(v_data), 'DD/MM/YYYY HH24:MI:SS'));

  DBMS_OUTPUT.PUT_LINE('=== CONVERSAO ===');
  DBMS_OUTPUT.PUT_LINE('TO_CHAR(num)      : ' || TO_CHAR(3750.5, 'FM99990.00'));
  DBMS_OUTPUT.PUT_LINE('TO_CHAR(data)     : ' || TO_CHAR(v_data, 'DD/MM/YYYY HH24:MI'));
  DBMS_OUTPUT.PUT_LINE('TO_NUMBER         : ' || TO_NUMBER('1234.56'));

  DBMS_OUTPUT.PUT_LINE('=== NULO ===');
  DBMS_OUTPUT.PUT_LINE('NVL(NULL,0)       : ' || NVL(v_sal, 0));
  DBMS_OUTPUT.PUT_LINE('NVL2(NULL,x,y)    : ' || NVL2(v_sal, 'tem valor', 'eh nulo'));
  DBMS_OUTPUT.PUT_LINE('COALESCE          : ' || COALESCE(v_sal, 100, 200));
END;
/
