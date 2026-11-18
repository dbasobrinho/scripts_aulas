#!/usr/bin/env bash
# ==========================================================================================================
#  ARQUIVO.......: 02.srvora4_AUTOBR_RECRIA_AUTOBR_DROP_RESTORE.sh
#  SCRIPT........: Recria primário AUTOBR (DROP + CLEAN ASM + RESTORE SPFILE/CONTROLFILE/DATABASE)
#  AUTOR.........: Roberto Fernandes Sobrinho (DBA Sobrinho)
#  DATA..........: 29/09/2025
#  VERSÃO........: 1.4
#  17/11/2026 v1.4: codigo real do RMAN (PIPESTATUS); RECOVER NOREDO (backup consistente, feito em MOUNT);
#                   SPFILE restaurado no mesmo lugar que o Oracle Restart usa + init ponteiro alinhado.
#
#  OBJETIVO......
#      Derrubar o banco AUTOBR, executar DROP DATABASE, limpar completamente os diretórios no ASM
#      (+DATA e +FRA) referentes ao banco primário e restaurar SPFILE, CONTROLFILE e DATABASE
#      a partir dos backups em disco (SPF_*.bkp, CRL_*.bkp e backupsets do DB) em BACKUP_DIR.
#
#  ETAPAS EXECUTADAS:
#      1) Confirmação de segurança (digitar 'dual')
#      2) Detecção de ORACLE_HOME/ORACLE_SID do usuário oracle
#      3) Shutdown e DROP DATABASE (se existir)
#      4) Limpeza dos diretórios no ASM (+DATA/+FRA)
#      5) PFILE mínimo e STARTUP NOMOUNT
#      6) RESTORE SPFILE (SPF_*.bkp) e STARTUP NOMOUNT com SPFILE
#      7) RESTORE CONTROLFILE (CRL_*.bkp) e MOUNT
#      8) CATALOG, RESTORE DATABASE, RECOVER DATABASE e OPEN RESETLOGS
#
#  PRÉ-REQUISITOS
#      - Executar como root (usa sudo -iu oracle/grid).
#      - Backups disponíveis em BACKUP_DIR.
#      - Ajuste DB_NAME/DB_UNIQUE_DIR se necessário.
# ==========================================================================================================

set +e
trap 'echo "[ERRO] Linha $LINENO falhou com código $?." >> "$EXEC_LOG"' ERR

STAMP="$(date +%Y%m%d_%H%M)"
EXEC_LOG="./02.srvora4_AUTOBR_RECRIA_AUTOBR_DROP_RESTORE_exec_${STAMP}.log" 
ABS_LOG="$(readlink -f "$EXEC_LOG")"

# ===================== CONFIG =====================
ORACLE_SID="AUTOBR"
DB_NAME="AUTO"               # ajuste se necessário
DB_UNIQUE_DIR="AUTO_U_BR"    # diretório lógico (OMF) do banco no ASM
DG_DATA="+DATA"
DG_FRA="+FRA"

BACKUP_DIR="/root/ADMDBA/PLDG/bkp_AUTOBR"   # SPF_*.bkp, CRL_*.bkp e backupsets do DB
RMAN_LOG="${BACKUP_DIR}/restore_${STAMP}.log"

# ===================== CABEÇALHO =====================
echo "================================================================================" | tee "$EXEC_LOG"
echo "RECRIAÇÃO PRIMÁRIO ${ORACLE_SID} - Início: $(date '+%d/%m/%Y %H:%M:%S')" | tee -a "$EXEC_LOG"
echo "Backups...............: ${BACKUP_DIR}" | tee -a "$EXEC_LOG"
echo "Log de execução.......: ${EXEC_LOG}" | tee -a "$EXEC_LOG"
echo "Log detalhado RMAN....: ${RMAN_LOG}" | tee -a "$EXEC_LOG"
echo "================================================================================" | tee -a "$EXEC_LOG"

# ===================== HELPERS =====================
say(){ echo "[$(date '+%d/%m/%Y %H:%M:%S')] $*" | tee -a "$EXEC_LOG" ; }
as_oracle(){ sudo -iu oracle bash -lc "$*" ; }
as_grid(){   sudo -iu grid   bash -lc "$*" ; }
mktemp_for_user() {
  local user="$1" ext="$2" tmp
  tmp="$(mktemp "/tmp/${user}_${STAMP}_XXXX.${ext}")"
  if [[ "$user" == "oracle" ]]; then
    chown oracle:oinstall "$tmp" || chown oracle:oracle "$tmp" || true
  elif [[ "$user" == "grid" ]]; then
    chown grid:oinstall "$tmp" || chown grid:grid "$tmp" || true
  fi
  chmod 600 "$tmp" || true
  echo "$tmp"
}

# ===================== CONFIRMAÇÃO (digitar 'dual') =====================
echo
echo "================================================================================"
echo "AVISO IMPORTANTE"
echo "Este procedimento vai:"
echo "  - Parar e DROPAR o banco ${ORACLE_SID}"
echo "  - Apagar dados no ASM: ${DG_DATA}/${DB_UNIQUE_DIR} e ${DG_FRA}/${DB_UNIQUE_DIR}"
echo "  - Restaurar SPFILE, CONTROLFILE e DATABASE a partir de ${BACKUP_DIR}"
echo "================================================================================"
read -p "Para continuar digite 'dual': " C1
[[ "$C1" == "dual" ]] || { echo "Confirmação inválida. Abortado."; exit 1; }
say "Confirmação recebida (dual). Prosseguindo..."

# ===================== SANITY CHECKS =====================
[[ -d "$BACKUP_DIR" ]] || { say "[ERRO] BACKUP_DIR não existe: $BACKUP_DIR"; exit 1; }

# ===================== DETECÇÃO DE AMBIENTE =====================
say "Detectando ORACLE_SID/ORACLE_HOME do usuário oracle..."
ORACLE_SID_DET="$(as_oracle 'echo ${ORACLE_SID:-}' )"
ORACLE_HOME_DET="$(as_oracle 'echo ${ORACLE_HOME:-}' )"
if [[ -z "$ORACLE_SID_DET" || -z "$ORACLE_HOME_DET" ]]; then
  say "[ERRO] ORACLE_SID/ORACLE_HOME não encontrados no ambiente oracle."
  exit 1
fi
say "ORACLE_SID=${ORACLE_SID_DET} | ORACLE_HOME=${ORACLE_HOME_DET}"
# spfile registrado no Oracle Restart (lido ANTES do DROP DATABASE, que apaga o spfile em uso)
SPF_CRS="$(as_oracle "srvctl config database -db ${DB_UNIQUE_DIR} 2>/dev/null | awk -F': ' '/^Spfile/{print \$2}'")"

# ===================== PASSO 1: SHUTDOWN + DROP DATABASE =====================
say "[PASSO 1] Shutdown e DROP DATABASE (se existir)..."
DROP_SQL="$(mktemp_for_user oracle sql)"
cat > "$DROP_SQL" <<SQL
SET ECHO ON FEEDBACK ON
WHENEVER SQLERROR CONTINUE
SHUTDOWN ABORT;
STARTUP MOUNT EXCLUSIVE RESTRICT;
DROP DATABASE;
EXIT
SQL

if as_oracle "pgrep -f 'ora_pmon_${ORACLE_SID}' >/dev/null 2>&1"; then
  say "Instância encontrada. Executando DROP DATABASE..."
  as_oracle "sqlplus -S / as sysdba @${DROP_SQL}" | tee -a "$EXEC_LOG"
else
  say "Instância não ativa. Tentando DROP mesmo assim..."
  as_oracle "sqlplus -S / as sysdba @${DROP_SQL}" | tee -a "$EXEC_LOG" || true
fi
rm -f "$DROP_SQL" 2>/dev/null || true

# ===================== PASSO 2: LIMPEZA ASM =====================
say "[PASSO 2] Limpando ASM (${DG_DATA}/${DB_UNIQUE_DIR} e ${DG_FRA}/${DB_UNIQUE_DIR})..."
as_grid "asmcmd -p rm -rf ${DG_DATA}/${DB_UNIQUE_DIR} || true" | tee -a "$EXEC_LOG"
as_grid "asmcmd -p rm -rf ${DG_FRA}/${DB_UNIQUE_DIR} || true" | tee -a "$EXEC_LOG"
say "ASM limpo (ou diretórios já inexistentes)."

# ===================== PASSO 3: PFILE MÍNIMO + STARTUP NOMOUNT =====================
say "[PASSO 3] Criando PFILE mínimo e subindo NOMOUNT..."
INIT_FILE="${ORACLE_HOME_DET}/dbs/init${ORACLE_SID}.ora"
as_oracle "printf '%s\n' \
  'DB_NAME=${DB_NAME}' \
  'DB_UNIQUE_NAME=${DB_UNIQUE_DIR}' \
  'DB_CREATE_FILE_DEST=${DG_DATA}' \
  'DB_RECOVERY_FILE_DEST=${DG_FRA}' \
  'DB_RECOVERY_FILE_DEST_SIZE=100G' \
  > ${INIT_FILE}; chmod 640 ${INIT_FILE}" || { say "[ERRO] Falha criando PFILE."; exit 1; }

# SPFILE: restaura no mesmo lugar que o Oracle Restart usa (srvctl config). Se esse lugar estiver
# dentro dos diretorios que foram apagados no ASM, usa o padrao do dbs e ajusta o srvctl no final.
case "$SPF_CRS" in
  ""|"${DG_DATA}/${DB_UNIQUE_DIR}/"*|"${DG_FRA}/${DB_UNIQUE_DIR}/"*)
     SPF_DEST="${ORACLE_HOME_DET}/dbs/spfile${ORACLE_SID}.ora"; AJUSTA_CRS=1 ;;
  *) SPF_DEST="$SPF_CRS"; AJUSTA_CRS=0 ;;
esac
PTR_FILE="${ORACLE_HOME_DET}/dbs/init${ORACLE_SID}_ptr.ora"
as_oracle "echo \"SPFILE='${SPF_DEST}'\" > ${PTR_FILE}; chmod 640 ${PTR_FILE}"
if [[ "$SPF_DEST" == +* ]]; then
  as_grid "asmcmd rm -f ${SPF_DEST} 2>/dev/null || true"
else
  as_oracle "rm -f ${SPF_DEST}"
fi
say "SPFILE destino.........: ${SPF_DEST} (Oracle Restart: ${SPF_CRS:-nao registrado})"

START_NOMOUNT_SQL="$(mktemp_for_user oracle sql)"
cat > "$START_NOMOUNT_SQL" <<SQL
WHENEVER SQLERROR EXIT SQL.SQLCODE
STARTUP NOMOUNT PFILE='${INIT_FILE}';
EXIT
SQL
as_oracle "sqlplus -S / as sysdba @${START_NOMOUNT_SQL}" | tee -a "$EXEC_LOG" || { say "[ERRO] Falha em STARTUP NOMOUNT com PFILE."; exit 1; }
rm -f "$START_NOMOUNT_SQL" 2>/dev/null || true

# ===================== PASSO 4: LOCALIZA SPF/CRL MAIS RECENTES =====================
say "[PASSO 4] Localizando últimos backups de SPFILE e CONTROLFILE..."
SPF_PIECE="$(ls -1t ${BACKUP_DIR}/SPF_*.bkp 2>/dev/null | head -1)"
CRL_PIECE="$(ls -1t ${BACKUP_DIR}/CRL_*.bkp 2>/dev/null | head -1)"
if [[ -z "$SPF_PIECE" || -z "$CRL_PIECE" ]]; then
  say "[ERRO] Não encontrei SPF_*.bkp ou CRL_*.bkp em ${BACKUP_DIR}."
  exit 1
fi
say "SPFILE........: ${SPF_PIECE}"
say "CONTROLFILE...: ${CRL_PIECE}"

# ===================== PASSO 5: RMAN RESTORE/RECOVER/OPEN =====================
say "[PASSO 5] Executando RMAN restore/recover/open..."
touch "${RMAN_LOG}" && chown oracle:oinstall "${RMAN_LOG}" && chmod 664 "${RMAN_LOG}"

RMAN_CMD="$(mktemp_for_user oracle rman)"
cat > "${RMAN_CMD}" <<EOF
connect target /
 
# SPFILE: restaura do piece encontrado e reinicia NOMOUNT lendo SPFILE
shutdown abort;
startup nomount pfile='${INIT_FILE}';
restore spfile to '${SPF_DEST}' from '${SPF_PIECE}';
shutdown abort;

# agora usando o SPFILE restaurado (pelo ponteiro, que aponta para o mesmo spfile do Oracle Restart)
startup nomount pfile='${PTR_FILE}';

# CONTROLFILE: restaura e monta
restore controlfile from '${CRL_PIECE}';
alter database mount;

# CATALOG de todos os backups no diretório (com controlfile montado)
catalog start with '${BACKUP_DIR}/' noprompt;

# RESTORE e RECOVER do DATABASE
run {
  restore database;
  recover database noredo;
}

# abre com resetlogs
alter database open resetlogs;

exit
EOF

as_oracle "rman log='${RMAN_LOG}' cmdfile='${RMAN_CMD}'" | tee -a "$EXEC_LOG"
RC_RMAN=${PIPESTATUS[0]}

rm -f "${RMAN_CMD}" 2>/dev/null || true

# ===================== PASSO 6: RESULTADO E MONITORIA =====================
if [[ ${RC_RMAN} -eq 0 ]]; then
  say "[FINAL] Banco restaurado e aberto com RESETLOGS com sucesso."
  # init<SID>.ora vira o ponteiro: startup manual usa o mesmo spfile do Oracle Restart
  as_oracle "cp ${PTR_FILE} ${INIT_FILE} && rm -f ${PTR_FILE}"
  if [[ "$AJUSTA_CRS" == "1" && -n "$SPF_CRS" ]]; then
    as_oracle "srvctl modify database -db ${DB_UNIQUE_DIR} -spfile ${SPF_DEST}" && say "Oracle Restart ajustado para o spfile ${SPF_DEST}"
  fi
  ALERT_BASE="$(as_oracle 'echo $ORACLE_BASE')"
  ALERT_FILE="$(as_oracle "ls -1t ${ALERT_BASE}/diag/rdbms/*/*/trace/alert_*.log 2>/dev/null | head -1")"
  if [[ -n "$ALERT_FILE" ]]; then
    say "Monitorando alert.log por 15s: ${ALERT_FILE}"
    as_oracle "timeout 15 tail -n 20 -f ${ALERT_FILE}" || true
  else
    say "alert.log não localizado automaticamente (OK)."
  fi
  say "RMAN log em: ${RMAN_LOG}"
else
  say "[ERRO] RMAN terminou com código ${RC_RMAN}. Consulte o log: ${RMAN_LOG}"
fi

say "Log de execução em: ${ABS_LOG}"
