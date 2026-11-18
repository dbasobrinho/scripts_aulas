#!/usr/bin/env bash
# ==========================================================================================================
#  SCRIPT........: 08_srvora3_srvora4_AJUSTA_ORAPW_PARA_DG.sh
#  AUTOR.........: DBA Sobrinho
#  DATA..........: 05/10/2025
#  VERSÃO........: 1.2
#  DESCRIÇÃO.....: Atualiza o password file no caminho fixo /u01/app/oracle/product/19.0.0/db_1/dbs
#                  - srvora3 -> orapwAUTOUS
#                  - srvora4 -> orapwAUTOBR
#                  Fonte: ./orapw_ALL.bin (mesma pasta do script)
#                  Regra: se existir, faz backup; se não existir, cria novo.
#                  Permissões padrão Oracle: -rw-r----- oracle:oinstall
# ==========================================================================================================

set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_FILE="${SCRIPT_DIR}/orapw_ALL.bin"

DBS_DIR="/u01/app/oracle/product/19.0.0/db_1/dbs"
OWNER="oracle"
GROUP="oinstall"
PERMS="640"

log(){ echo "[$(date '+%d/%m/%Y %H:%M:%S')] $*"; }
die(){ echo "[ERRO] $*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "Execute como root."
[[ -f "$SRC_FILE" && -s "$SRC_FILE" ]] || die "Arquivo fonte inválido: $SRC_FILE"

HOST="$(hostname -s 2>/dev/null || hostname)"
case "$HOST" in
  srvora3) TGT="${DBS_DIR}/orapwAUTOUS" ;;
  srvora4) TGT="${DBS_DIR}/orapwAUTOBR" ;;
  *) die "Hostname não mapeado: $HOST (esperado: srvora3 ou srvora4)";;
esac

log "Host................: $HOST"
log "Arquivo destino......: $TGT"

# Garante diretório
if [[ ! -d "$DBS_DIR" ]]; then
  mkdir -p "$DBS_DIR"
  chown "$OWNER:$GROUP" "$DBS_DIR"
  chmod 755 "$DBS_DIR"
  log "Diretório criado: $DBS_DIR"
fi

# Se existir, faz backup; se não, cria novo
if [[ -f "$TGT" ]]; then
  BK="${TGT}.bkp_${STAMP}"
  cp -p "$TGT" "$BK"
  log "Backup criado: $BK"
else
  : > "$TGT"
  chown "$OWNER:$GROUP" "$TGT"
  chmod "$PERMS" "$TGT"
  log "Arquivo alvo criado (novo): $TGT"
fi

# Copia o binário
dd if="$SRC_FILE" of="$TGT" status=none conv=fsync

# Ajusta ownership e permissões no padrão Oracle
chown "$OWNER:$GROUP" "$TGT"
chmod "$PERMS" "$TGT"

# Sanity check
[[ -s "$TGT" ]] || die "Falha: arquivo destino ficou vazio: $TGT"

log "Password file atualizado com sucesso!"
log "Permissões finais: $(ls -l "$TGT")"
