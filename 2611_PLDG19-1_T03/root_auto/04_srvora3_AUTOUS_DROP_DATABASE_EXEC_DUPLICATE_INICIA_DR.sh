#!/usr/bin/env bash
# ==========================================================================================================
#  SCRIPT........: 04_srvora3_AUTOUS_DROP_DATABASE_EXEC_DUPLICATE_INICIA_DR.sh
#  AUTOR.........: Roberto Fernandes Sobrinho (DBA Sobrinho)
#  DATA..........: 20/09/2025
#  VERSÃO........: 2.5
#  17/11/2026 v2.5: so segue se o duplicate terminou ("Finished Duplicate Db" no log do RMAN);
#                   FLASHBACK ON no standby; recover moderno (real-time apply e o padrao no 19c).
#
#  OBJETIVO......
#      Este script automatiza todo o ciclo de destruição e recriação do banco de dados
#      standby AUTOUS em ambientes Oracle Data Guard. A execução contempla desde a
#      remoção completa da instância antiga até a criação de uma nova cópia via RMAN
#      DUPLICATE, finalizando com a ativação do processo de recovery.
#
#  ETAPAS EXECUTADAS:
#      1. Confirmação de execução (segurança)
#      2. Detecção automática de ORACLE_HOME e ORACLE_SID
#      3. Encerramento forçado da instância e DROP DATABASE (se existir)
#      4. Limpeza dos diretórios ASM (+DATA / +FRA)
#      5. Criação do arquivo init.ora e startup em NOMOUNT
#      6. Execução completa do RMAN DUPLICATE para recriação do standby
#      7. Ativação automática do MRP (Managed Recovery Process)
#
#  OBSERVAÇÕES...
#      - Deve ser executado como usuário root.
#      - Todos os logs detalhados são gravados no diretório de execução com timestamp.
#      - As mensagens exibidas no terminal são resumidas para melhor acompanhamento.
#
#  IMPORTANTE....
#      Use este script apenas em ambientes controlados de Data Guard.
#      A execução remove permanentemente o standby especificado.
#
# ==========================================================================================================


# DESLIGA abortos silenciosos
set +e

# Trap para erros inesperados
trap 'echo "[ERRO] Linha $LINENO falhou com código $?." >> "$LOG"' ERR
STAMP="$(date +%Y%m%d_%H%M)"
LOG="./04_srvora3_AUTOUS_DROP_DATABASE_EXEC_DUPLICATE_INICIA_DR_exec_${STAMP}.log"

echo
echo "=========================================================================================="
echo "AVISO IMPORTANTE"
echo "Este script vai APAGAR COMPLETAMENTE o banco de dados STANDBY AUTOUS e limpar +DATA  +FRA."
echo "=========================================================================================="
read -p "Para continuar digite 'dual': " C1
[[ "$C1" == "dual" ]] || { echo "Confirmação inválida. Abortado."; exit 1; }
echo
echo ">>> Execução iniciada. Acompanhe o processamento detalhado pelo log:"
echo ">>> $LOG"
echo ">>> Você pode visualizar em tempo real com:"
echo ">>> tail -f $LOG"
echo
sleep 2

# ===== CONFIG ==============================================================================
DB_UNIQUE_DIR="AUTO_U_US"
DG_DATA="+DATA"
DG_FRA="+FRA"
TNS_PRIMARY="AUTOBR_TNS"
TNS_STANDBY="AUTOUS_TNS"
SYS_PASS="oracle"


ABS_LOG="$(readlink -f "$LOG")"
exec >>"$LOG" 2>&1
say(){ echo "[$(date '+%d/%m/%Y %H:%M:%S')] $*"; }

# ===== HELPERS =============================================================================
as_oracle(){ sudo -iu oracle bash -lc "$*"; }
as_grid(){   sudo -iu grid   bash -lc "$*";  }

mktemp_for_user() {
  local user="$1" ext="$2" tmp
  tmp="$(mktemp "/tmp/${user}_${STAMP}_XXXX.${ext}")"
  if [[ "$user" == "oracle" ]]; then
    chown oracle:oinstall "$tmp" || chown oracle:oracle "$tmp" || true
  elif [[ "$user" == "grid" ]]; then
    chown grid:oinstall "$tmp" || chown grid:grid "$tmp" || true
  else
    chown "${user}:${user}" "$tmp" || true
  fi
  chmod 600 "$tmp" || true
  echo "$tmp"
}

write_file_as_user() {
  local user="$1" ext="$2" content="$3" tmp
  tmp="$(mktemp_for_user "$user" "$ext")"
  printf "%s\n" "$content" > "$tmp"
  echo "$tmp"
}

say "=== [DEBUG] Script iniciado ==="

# ===== Detecta ambiente ==========================================================================
say "[DEBUG] Detectando ORACLE_SID e ORACLE_HOME..."
ORACLE_SID_DET="$(as_oracle 'echo "${ORACLE_SID:-}"')"
ORACLE_HOME_DET="$(as_oracle 'echo "${ORACLE_HOME:-}"')"
[[ -n "$ORACLE_SID_DET" && -n "$ORACLE_HOME_DET" ]] || { say "[ERRO] ORACLE_SID/ORACLE_HOME não setados."; exit 1; }
say "[DEBUG] ORACLE_SID=${ORACLE_SID_DET} | ORACLE_HOME=${ORACLE_HOME_DET}"

# ===== 1) DROP DATABASE =========================================================================
say "[DEBUG] Iniciando DROP DATABASE..."
DROP_SQL_FILE="$(mktemp_for_user oracle sql)"
cat > "$DROP_SQL_FILE" <<SQL
SET ECHO ON FEEDBACK ON
WHENEVER SQLERROR CONTINUE
SHUTDOWN ABORT;
STARTUP FORCE MOUNT EXCLUSIVE RESTRICT;
DROP DATABASE;
EXIT
SQL

if pgrep -f "ora_pmon_${ORACLE_SID_DET}" >/dev/null 2>&1; then
  say "[DEBUG] PMON encontrado -> DROP DATABASE"
  as_oracle "sqlplus -S / as sysdba @${DROP_SQL_FILE}" || true
  say "[DEBUG] DROP finalizado (ou ignorado)."
else
  say "[DEBUG] PMON não encontrado. Pulando DROP."
fi
rm -f "${DROP_SQL_FILE}" || true

# ===== 2) Limpeza ASM ============================================================================
say "[DEBUG] Limpando ASM: ${DG_DATA}/${DB_UNIQUE_DIR} e ${DG_FRA}/${DB_UNIQUE_DIR}"
as_grid "asmcmd -p rm -rf ${DG_DATA}/${DB_UNIQUE_DIR} || true"
as_grid "asmcmd -p rm -rf ${DG_FRA}/${DB_UNIQUE_DIR} || true"
say "[DEBUG] ASM limpo."

# ===== 3) Cria init.ora ==========================================================================
say "[DEBUG] Criando init.ora..."
as_oracle "printf '%s\n' 'DB_NAME=AUTO' > ${ORACLE_HOME_DET}/dbs/init${ORACLE_SID_DET}.ora; chmod 640 ${ORACLE_HOME_DET}/dbs/init${ORACLE_SID_DET}.ora"
as_oracle "cat ${ORACLE_HOME_DET}/dbs/init${ORACLE_SID_DET}.ora"

# ===== 4) Startup NOMOUNT ==========================================================================
say "[DEBUG] Executando shutdown abort preventivo..."
SHUTDOWN_SQL_FILE="$(mktemp_for_user oracle sql)"
cat > "$SHUTDOWN_SQL_FILE" <<SQL
SET ECHO ON FEEDBACK ON
WHENEVER SQLERROR CONTINUE
SHUTDOWN ABORT;
EXIT
SQL
as_oracle "sqlplus -S / as sysdba @${SHUTDOWN_SQL_FILE}" || true
rm -f "${SHUTDOWN_SQL_FILE}" || true

say "[DEBUG] Subindo NOMOUNT..."
START_SQL_FILE="$(mktemp_for_user oracle sql)"
cat > "$START_SQL_FILE" <<SQL
SET ECHO ON FEEDBACK ON
WHENEVER SQLERROR CONTINUE
STARTUP NOMOUNT PFILE='${ORACLE_HOME_DET}/dbs/init${ORACLE_SID_DET}.ora';
EXIT
SQL

as_oracle "sqlplus -S / as sysdba @${START_SQL_FILE}" || true
rm -f "${START_SQL_FILE}" || true
say "[DEBUG] NOMOUNT concluído. Prosseguindo..."

# ===== 5) RMAN DUPLICATE ==========================================================================
say "[DEBUG] Preparando RMAN script..."

read -r -d '' RMAN_CONTENT <<'EOF_RMAN'
connect target  sys/__SYS_PASS__@__TNS_PRIMARY__
connect auxiliary sys/__SYS_PASS__@__TNS_STANDBY__

run {
  allocate channel prmy1 type disk;
  allocate channel prmy2 type disk;
  allocate channel prmy3 type disk;
  allocate channel prmy4 type disk;
  allocate channel prmy5 type disk;
  allocate channel prmy6 type disk;
  allocate auxiliary channel stdby type disk;

  duplicate target database for standby from active database DORECOVER NOFILENAMECHECK
    spfile
      parameter_value_convert 'AUTOBR','AUTOUS'
      set db_unique_name='AUTO_U_US'
      set db_create_file_dest='__DG_DATA__'
      set db_recovery_file_dest='__DG_FRA__'
      set db_recovery_file_dest_size='100G'
      set db_file_name_convert='__DG_DATA__','__DG_DATA__','__DG_FRA__','__DG_FRA__'
      set log_file_name_convert='__DG_DATA__','__DG_DATA__','__DG_FRA__','__DG_FRA__'
      set control_files='__DG_DATA__/__DB_UNIQUE_DIR__/CONTROLFILE/control01.ctl'
      set cluster_database='FALSE'
      set fal_client='__TNS_STANDBY__'
      set fal_server='__TNS_PRIMARY__'
      set log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST'
      set log_archive_dest_2='SERVICE=__TNS_PRIMARY__ ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=AUTO_U_BR'
      set log_archive_config='DG_CONFIG=(AUTO_U_BR,AUTO_U_US)'
      set log_archive_format='AUTO_U_US_%t_%s_%r.arc'
      set standby_file_management='AUTO'
	  set service_names='AUTO_U_US, AUTOUS, AUTOUS_SVC' 
      set log_archive_max_processes='5';
}
exit
EOF_RMAN

say "[DEBUG] Substituindo variáveis no RMAN script..."
RMAN_CONTENT="${RMAN_CONTENT//__SYS_PASS__/${SYS_PASS}}"
RMAN_CONTENT="${RMAN_CONTENT//__TNS_PRIMARY__/${TNS_PRIMARY}}"
RMAN_CONTENT="${RMAN_CONTENT//__TNS_STANDBY__/${TNS_STANDBY}}"
RMAN_CONTENT="${RMAN_CONTENT//__DG_DATA__/${DG_DATA}}"
RMAN_CONTENT="${RMAN_CONTENT//__DG_FRA__/${DG_FRA}}"
RMAN_CONTENT="${RMAN_CONTENT//__DB_UNIQUE_DIR__/${DB_UNIQUE_DIR}}"

RMAN_FILE="$(write_file_as_user oracle rman "$RMAN_CONTENT")"

say "[DEBUG] RMAN script gerado em: ${RMAN_FILE}"
cat "${RMAN_FILE}"

say "[DEBUG] Dormindo 10s antes do RMAN..."
sleep 10

say "[DEBUG] Testando tnsping..."
as_oracle "tnsping ${TNS_PRIMARY}" || true
as_oracle "tnsping ${TNS_STANDBY}" || true

ABS_RMAN_LOG="$(readlink -f "${LOG%.log}_rman.log")"
say "[DEBUG] Executando RMAN com log absoluto: ${ABS_RMAN_LOG}"
as_oracle "rman cmdfile='${RMAN_FILE}' log='${ABS_RMAN_LOG}'"
RMAN_STATUS=$?
if ! grep -q "Finished Duplicate Db" "${ABS_RMAN_LOG}" 2>/dev/null; then
  say "[ERRO] O duplicate nao terminou (sem 'Finished Duplicate Db' no log). Veja: ${ABS_RMAN_LOG}"
  RMAN_STATUS=99
fi

rm -f "${RMAN_FILE}" || true
say "[DEBUG] FIM DO SCRIPT"
say "Log final: ${ABS_LOG}"

if [[ $RMAN_STATUS -eq 0 ]]; then
  say "Aplicação Recovery Standby"

  # Garante que o banco está montado antes do recovery
  CHECK_SQL=$(mktemp /tmp/check_XXXX.sql)
  cat > "$CHECK_SQL" <<EOF
WHENEVER SQLERROR CONTINUE
STARTUP MOUNT;
EXIT
EOF
  chown oracle:oinstall "$CHECK_SQL"
  chmod 600 "$CHECK_SQL"
  as_oracle "sqlplus -S / as sysdba @$CHECK_SQL" || true
  rm -f "$CHECK_SQL"

  # Aplica o recovery
  RECOVERY_SQL=$(mktemp /tmp/recovery_XXXX.sql)
  cat > "$RECOVERY_SQL" <<EOF
WHENEVER SQLERROR CONTINUE
ALTER DATABASE FLASHBACK ON;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT;
EXIT
EOF
  chown oracle:oinstall "$RECOVERY_SQL"
  chmod 600 "$RECOVERY_SQL"
  as_oracle "sqlplus -S / as sysdba @$RECOVERY_SQL" || {
    say "[ERRO] Falha ao aplicar o recovery. Verifique o alert.log."
  }
  rm -f "$RECOVERY_SQL"

  # -----------------------------------------------
  # Ajusta log_archive_dest_state_2 no PRIMÁRIO
  # -----------------------------------------------
  say "Ajustando log_archive_dest_state_2 no PRIMÁRIO (DEFER -> ENABLE)..."
  PRIMARY_TNS="${TNS_PRIMARY:-AUTOBR_TNS}"
  PRIMARY_PWD="${SYS_PASS:-oracle}"

  PRIMARY_SQL=$(mktemp /tmp/primary_archdest2_XXXX.sql)
  cat > "$PRIMARY_SQL" <<EOF
WHENEVER SQLERROR CONTINUE
ALTER SYSTEM SET log_archive_dest_state_2=DEFER  SCOPE=BOTH SID='*';
ALTER SYSTEM SET log_archive_dest_state_2=ENABLE SCOPE=BOTH SID='*';
EXIT
EOF
  chown oracle:oinstall "$PRIMARY_SQL"
  chmod 600 "$PRIMARY_SQL"

  as_oracle "sqlplus -S \"sys/${PRIMARY_PWD}@${PRIMARY_TNS} as sysdba\" @${PRIMARY_SQL}" || {
    say "[ERRO] Não foi possível aplicar DEFER/ENABLE no primário via ${PRIMARY_TNS}. Verifique conectividade/TNS."
  }
  rm -f "$PRIMARY_SQL"
  
# Tail no alert.log por 15 segundos após entrar em recovery
  say "Monitorando alert.log por 15 segundos..."
  as_oracle "timeout 15 tail -n 10 -f /u01/app/oracle/diag/rdbms/auto_u_us/AUTOUS/trace/alert_AUTOUS.log" || true

  say "Aplicação Recovery Standby"
  say ">> Processo concluído com sucesso. Standby pronto e em recovery."
else
  say ">> Processo finalizado, mas o duplicate falhou. Recovery não foi iniciado."
fi

say "Log detalhado disponível em: $(readlink -f "$LOG")"
