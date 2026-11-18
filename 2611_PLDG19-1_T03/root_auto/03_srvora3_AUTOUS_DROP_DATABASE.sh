#!/usr/bin/env bash
# ==========================================================================================================
#  SCRIPT........: 03_srvora3_AUTOUS_DROP_DATABASE.sh
#  AUTOR.........: Roberto Fernandes Sobrinho (DBA Sobrinho)
#  DATA..........: 02/10/2025
#  VERSÃO........: 2.5
#
#  OBJETIVO......
#    Apagar com segurança o standby AUTOUS e limpar diretórios no ASM (+DATA/+FRA).
#    Prepara o terreno para recriação posterior (RMAN DUPLICATE).
#
#  ETAPAS:
#    1) Confirmações de segurança (duplas)
#    2) Checagens (root, usuários, ORACLE_HOME/SID)
#    3) Validação do db_unique_name = AUTOUS
#    4) DROP DATABASE (se existir / montado)
#    5) Limpeza dos caminhos no ASM (+DATA/AUTO_U_US e +FRA/AUTO_U_US)
#
#  OBS...
#    - Executar como root (usa sudo -iu oracle/grid).
#    - Log completo com timestamp na pasta atual.
#    - Use apenas no standby AUTOUS.
# ================================================================================================

# --- Não abortar em qualquer erro; logar via trap
set +e

# --- Trap simples para registrar linha/código de erro no log
trap 'echo "[ERRO] Linha $LINENO falhou com código $?." >> "$LOG"' ERR

STAMP="$(date +%Y%m%d_%H%M)"
LOG="./03_srvora3_AUTOUS_DROP_DATABASE_exec_${STAMP}.log"

echo
echo "=========================================================================================="
echo "AVISO IMPORTANTE"
echo "Este script vai APAGAR COMPLETAMENTE o banco de dados STANDBY AUTOUS e limpar +DATA e +FRA."
echo "=========================================================================================="
read -r -p "Para continuar digite 'dual': " C1
[[ "$C1" == "dual" ]] || { echo "Confirmação inválida. Abortado."; exit 1; }

echo
echo ">>> Execução iniciada. Acompanhe o processamento detalhado pelo log:"
echo ">>> $LOG"
echo ">>> Você pode visualizar em tempo real com:"
echo ">>> tail -f $LOG"
echo
sleep 2

# ===== CONFIG ===================================================================================
DB_UNIQUE_DIR="AUTO_U_US"   # diretório “raiz” do banco no ASM (ajuste se seu padrão for outro)
DG_DATA="+DATA"
DG_FRA="+FRA"
TNS_PRIMARY="AUTOBR_TNS"    # reservado para a fase de DUPLICATE (não usado aqui)
TNS_STANDBY="AUTOUS_TNS"    # reservado para a fase de DUPLICATE (não usado aqui)
SYS_PASS="oracle"           # mantido por compatibilidade (não usado nesta etapa)

ABS_LOG="$(readlink -f "$LOG")"

# --- Redireciona tudo pro log a partir daqui
exec >>"$LOG" 2>&1
say(){ echo "[$(date '+%d/%m/%Y %H:%M:%S')] $*"; }

say "=== [DEBUG] Script iniciado ==="
say "[DEBUG] Log: $ABS_LOG"

# ===== HELPERS ==================================================================================
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

# ===== Detecta ambiente =========================================================================
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

# Se a instância estiver ativa (PMON), executa o DROP; senão, pula
if pgrep -f "ora_pmon_${ORACLE_SID_DET}" >/dev/null 2>&1; then
  say "[DEBUG] PMON encontrado -> executando DROP DATABASE"
  as_oracle "sqlplus -S / as sysdba @${DROP_SQL_FILE}" || true
  say "[DEBUG] DROP finalizado (ou ignorado, se já estava dropado)."
else
  say "[DEBUG] PMON não encontrado. Pulando DROP (sem instância para dropar)."
fi
rm -f "${DROP_SQL_FILE}" || true

# ===== 2) Limpeza ASM ===========================================================================
say "[DEBUG] Limpando ASM: ${DG_DATA}/${DB_UNIQUE_DIR} e ${DG_FRA}/${DB_UNIQUE_DIR}"
as_grid "asmcmd -p rm -rf ${DG_DATA}/${DB_UNIQUE_DIR} || true"
as_grid "asmcmd -p rm -rf ${DG_FRA}/${DB_UNIQUE_DIR} || true"
say "[DEBUG] ASM limpo."

say "Log detalhado disponível em: $(readlink -f "$LOG")"
