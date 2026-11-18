#!/usr/bin/env bash
# ==========================================================================================================
#  SCRIPT........: 06_srvora3_srvora4_AJUSTA_TNANAMES_ORACLE_PARA_DG.sh
#  AUTOR.........: Roberto Fernandes Sobrinho (DBA Sobrinho)
#  DATA..........: 05/10/2025
#  VERSÃO........: 1.1
#
#  OBJETIVO......
#      Garantir que o arquivo tnsnames.ora do ORACLE_HOME (RDBMS) esteja presente e atualizado
#      a partir do arquivo modelo oracle_ALL_tnsnames.ora mantido pelo usuário oracle.
#      Caso o arquivo de destino não exista, o script o criará automaticamente.
#
#  FUNCIONAMENTO:
#      - Executa como root.
#      - Localiza o arquivo fonte oracle_ALL_tnsnames.ora em:
#          1) mesma pasta do script, OU
#          2) /home/oracle/oracle_ALL_tnsnames.ora
#      - Se o tnsnames.ora não existir, cria o arquivo.
#      - Se existir, faz backup (cp -p) com timestamp.
#      - Substitui o conteúdo via "cat >" (mantém inode/SELinux).
#      - Ajusta owner/perms: oracle:oinstall, 0644.
#
#  DEPENDÊNCIAS...
#      - oracle_ALL_tnsnames.ora deve estar disponível em um dos caminhos citados.
#
#  ALVO...........
#      - /u01/app/oracle/product/19.0.0/db_1/network/admin/tnsnames.ora
#
#  USO............
#      chmod +x 06_srvora3_srvora4_AJUSTA_TNANAMES_ORACLE_PARA_DG.sh
#      sudo ./06_srvora3_srvora4_AJUSTA_TNANAMES_ORACLE_PARA_DG.sh
#
#  OBSERVAÇÕES...
#      - Não é necessário recarregar o listener (tnsnames é client-side).
#      - Após atualização, valide com tnsping <ALIAS>.
# ==========================================================================================================

set -euo pipefail

# --- Configurações
TNS_TARGET="/u01/app/oracle/product/19.0.0/db_1/network/admin/tnsnames.ora"
OWNER="oracle"
GROUP="oinstall"
PERMS="0644"

STAMP="$(date +%Y%m%d_%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log(){ echo "[$(date '+%d/%m/%Y %H:%M:%S')] $*"; }

# 1) Exigir root
if [[ $EUID -ne 0 ]]; then
  echo "[ERRO] Este script deve ser executado como root."
  exit 1
fi

# 2) Localiza o arquivo de origem
SRC_FILE=""
if [[ -f "${SCRIPT_DIR}/oracle_ALL_tnsnames.ora" ]]; then
  SRC_FILE="${SCRIPT_DIR}/oracle_ALL_tnsnames.ora"
elif [[ -f "/home/oracle/oracle_ALL_tnsnames.ora" ]]; then
  SRC_FILE="/home/oracle/oracle_ALL_tnsnames.ora"
else
  echo "[ERRO] oracle_ALL_tnsnames.ora não encontrado."
  echo "       Coloque-o na mesma pasta do script OU em /home/oracle/"
  exit 2
fi

[[ -s "$SRC_FILE" ]] || { echo "[ERRO] Arquivo de origem está vazio: $SRC_FILE"; exit 3; }

# 3) Garante que o diretório destino exista
DEST_DIR="$(dirname "$TNS_TARGET")"
if [[ ! -d "$DEST_DIR" ]]; then
  mkdir -p "$DEST_DIR"
  chown "$OWNER:$GROUP" "$DEST_DIR"
  chmod 755 "$DEST_DIR"
  log "Diretório criado: $DEST_DIR"
fi

# 4) Se não existir, cria o tnsnames.ora vazio antes de copiar
if [[ ! -f "$TNS_TARGET" ]]; then
  touch "$TNS_TARGET"
  chown "$OWNER:$GROUP" "$TNS_TARGET"
  chmod "$PERMS" "$TNS_TARGET"
  log "Arquivo tnsnames.ora criado (novo)."
else
  # Faz backup se já existir
  BK="${TNS_TARGET}.bkp_${STAMP}"
  cp -p "$TNS_TARGET" "$BK"
  log "Backup criado: $BK"
fi

# 5) Substitui conteúdo mantendo inode e contexto SELinux
cat "$SRC_FILE" > "$TNS_TARGET"
log "Conteúdo do tnsnames.ora atualizado a partir de: $SRC_FILE"

# 6) Ajusta permissões e owner
chown "$OWNER:$GROUP" "$TNS_TARGET" || true
chmod "$PERMS" "$TNS_TARGET" || true
log "Permissões ajustadas para ${OWNER}:${GROUP} (${PERMS})."

log "=================================================================================="
log "tnsnames.ora atualizado (ou criado) com sucesso!"
log "Valide com: tnsping AUTOBR_TNS | tnsping AUTOUS_TNS | tnsping AUTOBR_DGMGRL | tnsping AUTOUS_DGMGRL"
log "=================================================================================="
