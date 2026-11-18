#!/usr/bin/env bash
# ==========================================================================================================
#  SCRIPT........: 07_srvora4_AUTOBR_DG_PARAMS_E_ARCHIVE_FLASHBACK_total.sh
#  AUTOR.........: Roberto Fernandes Sobrinho (DBA Sobrinho)
#  DATA..........: 05/10/2025
#  VERSÃO........: 1.1
#  17/11/2026 v1.1: FORCE LOGGING + standby redo logs 101..104 (mesmo tamanho dos online redo logs).
#
#  OBJETIVO......
#      Em UM ÚNICO SCRIPT: ajustar TODOS os parâmetros de Data Guard do AUTOBR, DESATIVAR o Broker,
#      e habilitar ARCHIVELOG + FLASHBACK DATABASE.
#      Observação: cada comando SQL continua mesmo se algum falhar (WHENEVER SQLERROR CONTINUE).
#
#  RESUMO DO QUE SERÁ FEITO (EXPLÍCITO):
#      -- Parâmetros DG
#      ALTER SYSTEM SET db_unique_name='AUTO_U_BR' SCOPE=SPFILE SID='*';
#      ALTER SYSTEM SET log_archive_config='DG_CONFIG=(AUTO_U_BR,AUTO_U_US)' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET log_archive_dest_1='location=USE_DB_RECOVERY_FILE_DEST valid_for=(all_logfiles,all_roles) db_unique_name=AUTO_U_BR' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET log_archive_dest_2='service=AUTOUS_TNS async noaffirm valid_for=(online_logfiles,primary_role) db_unique_name=AUTO_U_US reopen=60 net_timeout=30 compression=enable' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET log_archive_dest_state_1=ENABLE SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET log_archive_dest_state_2=ENABLE SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET fal_server='AUTOUS_TNS' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET fal_client='AUTOBR_TNS' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET standby_file_management='AUTO' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET db_file_name_convert='+DATA','+DATA','+FRA','+FRA' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET log_file_name_convert='+DATA','+DATA','+FRA','+FRA' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET remote_login_passwordfile='EXCLUSIVE' SCOPE=BOTH SID='*';
#      ALTER SYSTEM SET log_archive_max_processes=8 SCOPE=BOTH SID='*';
#      -- Broker OFF
#      ALTER SYSTEM SET dg_broker_start=FALSE SCOPE=BOTH SID='*';
#      ALTER SYSTEM RESET dg_broker_config_file1 SCOPE=BOTH SID='*';
#      ALTER SYSTEM RESET dg_broker_config_file2 SCOPE=BOTH SID='*';
#      -- Modo ARCHIVE + FLASHBACK
#      SHUTDOWN IMMEDIATE; STARTUP MOUNT; ALTER DATABASE ARCHIVELOG; ALTER DATABASE FLASHBACK ON;
#
#  USO...........
#      chmod +x 07_srvora4_AUTOBR_DG_PARAMS_E_ARCHIVE_FLASHBACK_total.sh
#      sudo ./07_srvora4_AUTOBR_DG_PARAMS_E_ARCHIVE_FLASHBACK_total.sh
# ==========================================================================================================
#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
LOG="./07_AUTOBR_DG_ARCHIVE_FLASHBACK_${STAMP}.log"
SQLFILE="/tmp/autobr_dg_arch_fb_${STAMP}.sql"

say(){ echo "[$(date '+%d/%m/%Y %H:%M:%S')] $*"; }
as_oracle(){ sudo -iu oracle bash -lc "$*"; }

# exige root
if [[ $EUID -ne 0 ]]; then
  echo "[ERRO] Execute como root."
  exit 1
fi

# aviso + confirmação (mostra log ANTES do redirecionamento)
echo
echo "=========================================================================================="
echo "Este script vai ALTERAR TODOS os parâmetros de DG (AUTOBR), DESATIVAR o BROKER"
echo "e HABILITAR ARCHIVELOG + FLASHBACK DATABASE."
echo "db_unique_name será definido com SCOPE=SPFILE (fará restart controlado)."
echo "LOG: $(readlink -f "$LOG" 2>/dev/null || echo "$LOG")"
echo "Dica: em outro terminal rode -> tail -f $LOG"
echo "=========================================================================================="
read -r -p "Para continuar digite 'dual': " C1
[[ "$C1" == "dual" ]] || { echo "Confirmação inválida. Abortado."; exit 1; }

# redireciona pro log
exec >>"$LOG" 2>&1
say "Iniciando execução total: parâmetros DG + ARCHIVELOG + FLASHBACK."

# bloco SQL único (continua mesmo com erro)
cat > "$SQLFILE" <<'SQL'
SET ECHO ON
WHENEVER SQLERROR CONTINUE

PROMPT === AJUSTES DE PARÂMETROS DE DATA GUARD (AUTOBR) ===
ALTER SYSTEM SET db_unique_name = 'AUTO_U_BR' SCOPE=SPFILE SID='*';
ALTER SYSTEM SET log_archive_config = 'DG_CONFIG=(AUTO_U_BR,AUTO_U_US)' SCOPE=BOTH SID='*';

ALTER SYSTEM SET log_archive_dest_1 =
  'location=USE_DB_RECOVERY_FILE_DEST valid_for=(all_logfiles,all_roles) db_unique_name=AUTO_U_BR'
  SCOPE=BOTH SID='*';

ALTER SYSTEM SET log_archive_dest_2 =
  'service=AUTOUS_TNS async noaffirm valid_for=(online_logfiles,primary_role) db_unique_name=AUTO_U_US reopen=60 net_timeout=30 compression=enable'
  SCOPE=BOTH SID='*';

ALTER SYSTEM SET log_archive_dest_state_1 = ENABLE SCOPE=BOTH SID='*';
ALTER SYSTEM SET log_archive_dest_state_2 = ENABLE SCOPE=BOTH SID='*';

ALTER SYSTEM SET fal_server = 'AUTOUS_TNS' SCOPE=BOTH SID='*';
ALTER SYSTEM SET fal_client = 'AUTOBR_TNS' SCOPE=BOTH SID='*';

ALTER SYSTEM SET standby_file_management = 'AUTO' SCOPE=SPFILE SID='*';

ALTER SYSTEM SET db_file_name_convert = '+DATA','+DATA','+FRA','+FRA' SCOPE=SPFILE SID='*';
ALTER SYSTEM SET log_file_name_convert = '+DATA','+DATA','+FRA','+FRA' SCOPE=SPFILE SID='*';

ALTER SYSTEM SET remote_login_passwordfile = 'EXCLUSIVE' SCOPE=SPFILE SID='*';
ALTER SYSTEM SET log_archive_max_processes = 8 SCOPE=SPFILE SID='*';

PROMPT === BROKER OFF TOTAL ===
ALTER SYSTEM SET dg_broker_start = FALSE SCOPE=BOTH SID='*';
ALTER SYSTEM RESET dg_broker_config_file1 SCOPE=BOTH SID='*';
ALTER SYSTEM RESET dg_broker_config_file2 SCOPE=BOTH SID='*';

PROMPT === AJUSTES DE MODO (ARCHIVELOG + FLASHBACK) ===
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

ALTER DATABASE ARCHIVELOG;
ALTER DATABASE FLASHBACK ON;
ALTER DATABASE FORCE LOGGING;

ALTER DATABASE OPEN;

PROMPT === STANDBY REDO LOGS NO PRIMARIO (101 a 104, mesmo tamanho dos online redo logs) ===
DECLARE
  v_mb NUMBER;
  v_n  NUMBER;
BEGIN
  SELECT MAX(bytes)/1024/1024 INTO v_mb FROM v$log;
  FOR g IN 101..104 LOOP
    SELECT COUNT(*) INTO v_n FROM v$standby_log WHERE group# = g;
    IF v_n = 0 THEN
      EXECUTE IMMEDIATE 'ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP '||g||' SIZE '||v_mb||'M';
    END IF;
  END LOOP;
END;
/
SELECT group#, thread#, bytes/1024/1024 AS mb, status FROM v$standby_log ORDER BY 1;

PROMPT === VERIFICAÇÕES RÁPIDAS ===
ARCHIVE LOG LIST;

SHOW PARAMETER db_unique_name;
SHOW PARAMETER log_archive_config;
SHOW PARAMETER log_archive_dest_1;
SHOW PARAMETER log_archive_dest_2;
SHOW PARAMETER log_archive_max_processes;
SHOW PARAMETER dg_broker_start;
exit;
SQL

say "[EXEC] Aplicando bloco total (parâmetros + modos)..."
as_oracle "sqlplus -s / as sysdba @$SQLFILE"

say "Concluído. Revise o log: $LOG"
