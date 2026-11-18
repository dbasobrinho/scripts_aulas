#!/usr/bin/env bash
# ==========================================================================================================
#  SCRIPT........: 05_srvora3_srvora4_AJUSTA_LISTENER_GRID_PARA_DG.sh
#  AUTOR.........: Roberto Fernandes Sobrinho (DBA Sobrinho)
#  DATA..........: 05/10/2025
#  VERSÃO........: 1.1
#
#  OBJETIVO......
#      Ajustar automaticamente o arquivo listener.ora do Oracle Grid Infrastructure nos
#      servidores srvora3 e srvora4 para adequação ao ambiente Oracle Data Guard,
#      garantindo que cada nó tenha a configuração correta do listener.
#
#  FUNCIONAMENTO:
#      - Detecta o servidor (srvora3 ou srvora4) de forma automática.
#      - Faz backup do listener.ora atual com timestamp.
#      - Substitui o conteúdo pelo arquivo correspondente:
#          • srvora3 → usa grid_srvora3_listener.ora
#          • srvora4 → usa grid_srvora4_listener.ora
#      - Corrige permissões e proprietário (grid:oinstall, 0644).
#      - Ao final, executa (como grid): lsnrctl reload && lsnrctl status.
#
#  DEPENDÊNCIAS...
#      - Arquivos obrigatórios (na MESMA PASTA do script):
#          • grid_srvora3_listener.ora
#          • grid_srvora4_listener.ora
#
#  USO...........
#      chmod +x 05_srvora3_srvora4_ajusta_listener_grid_para_dg.sh
#      sudo ./05_srvora3_srvora4_ajusta_listener_grid_para_dg.sh
#
#  IMPORTANTE....
#      - Este script deve ser executado **como root**.
#      - É destinado exclusivamente aos servidores srvora3 e srvora4.
#      - Operação segura, mas deve ser feita fora de janelas críticas de aplicação.
#
# ==========================================================================================================

set -euo pipefail

GRID_LISTENER="/u01/app/19.0.0/grid/network/admin/listener.ora"
OWNER="grid"
GROUP="oinstall"
PERMS="0644"

STAMP="$(date +%Y%m%d_%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTNAME_LC="$(hostname | tr '[:upper:]' '[:lower:]')"

log(){ echo "[$(date '+%d/%m/%Y %H:%M:%S')] $*"; }
as_grid(){ sudo -iu grid bash -lc "$*"; }

# 1) Verifica se está sendo executado como root
if [[ $EUID -ne 0 ]]; then
  echo "[ERRO] Este script deve ser executado como root."
  exit 1
fi

# 2) Identifica o host e escolhe o arquivo correspondente
SRC_FILE=""
if [[ "$HOSTNAME_LC" == *"srvora3"* ]]; then
  SRC_FILE="${SCRIPT_DIR}/grid_srvora3_listener.ora"
elif [[ "$HOSTNAME_LC" == *"srvora4"* ]]; then
  SRC_FILE="${SCRIPT_DIR}/grid_srvora4_listener.ora"
else
  echo "[ERRO] Host '${HOSTNAME_LC}' não é srvora3 nem srvora4. Abortando."
  exit 2
fi

# 3) Checa se os arquivos existem
[[ -f "$GRID_LISTENER" ]] || { echo "[ERRO] Arquivo alvo não encontrado: $GRID_LISTENER"; exit 3; }
[[ -f "$SRC_FILE" ]]      || { echo "[ERRO] Arquivo de origem não encontrado: $SRC_FILE"; exit 4; }
[[ -s "$SRC_FILE" ]]      || { echo "[ERRO] Arquivo de origem está vazio: $SRC_FILE"; exit 5; }

log "=================================================================================="
log "Host........: $HOSTNAME_LC"
log "Arquivo alvo: $GRID_LISTENER"
log "Arquivo base: $SRC_FILE"
log "=================================================================================="

# 4) Faz backup do listener.ora atual
BK="${GRID_LISTENER}.bkp_${STAMP}"
cp -p "$GRID_LISTENER" "$BK"
log "Backup criado: $BK"

# 5) Substitui o conteúdo do listener.ora pelo modelo correspondente
cat "$SRC_FILE" > "$GRID_LISTENER"
log "Conteúdo do listener.ora substituído com sucesso."

# 6) Ajusta permissões e proprietário
chown "$OWNER:$GROUP" "$GRID_LISTENER" || true
chmod "$PERMS" "$GRID_LISTENER" || true
log "Permissões ajustadas para ${OWNER}:${GROUP} (${PERMS})."

# 7) Recarrega e mostra status do listener como usuário grid
log "Recarregando o listener (como usuário grid)..."
as_grid "lsnrctl reload" || { log "[AVISO] 'lsnrctl reload' retornou erro."; true; }

log "Exibindo status do listener (como usuário grid)..."
as_grid "lsnrctl status" || { log "[AVISO] 'lsnrctl status' retornou erro."; true; }

log "=================================================================================="
log "listener.ora atualizado e listener recarregado. Verifique o status acima."
log "=================================================================================="
