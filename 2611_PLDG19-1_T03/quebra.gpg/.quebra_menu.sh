#!/bin/bash
# ==================================================================================================
# Script Name  : quebra_menu.sh
# Autor        : DBA Sobrinho
# Data         : 17/11/2026
# Versao       : 3.0
# Descricao    : Menu do robo gerador de problemas do PowerLab Data Guard.
#                -> lista os quebra_*.sh.gpg, mostra a ultima execucao de cada um (pelos logs)
#                -> descriptografa em memoria e executa com bash (nao grava o .sh no disco)
#                -> mostra o resultado: QUEBRADO, NADA FOI QUEBRADO (com o motivo) ou ERRO
# Uso          : alias "quebra"
# Requisitos   : gpg 2.0+
# ==================================================================================================
export QUEBRA_DIR_DEFAULT="/home/oracle/ADMDBA/PLDG/QUEBRA"
export QUEBRA_LOG_DIR_DEFAULT="/home/oracle/ADMDBA/PLDG/logs"
BASE_B64="Z3VpbmFuYW90aW5oYWRv"
GPG_BIN="$(command -v gpg || echo /usr/bin/gpg)"

# ---------------------------------------------------------------- cores (so em terminal)
if [ -t 1 ] && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  C_LAR=$'\e[38;5;208m'; C_AZ=$'\e[38;5;75m'; C_VD=$'\e[32m'; C_AM=$'\e[33m'; C_VM=$'\e[31m'
  C_CZ=$'\e[90m'; C_B=$'\e[1m'; C_0=$'\e[0m'
else
  C_LAR=""; C_AZ=""; C_VD=""; C_AM=""; C_VM=""; C_CZ=""; C_B=""; C_0=""
fi
LINHA="=============================================================================================="
TRACO="----------------------------------------------------------------------------------------------"

info_banco() {
  local r
  r="$(sqlplus -s -L "/ as sysdba" <<'EOSQL' 2>/dev/null | sed '/^[[:space:]]*$/d' | head -1
set heading off feedback off pagesize 0
select database_role||' | '||open_mode from v$database;
exit
EOSQL
)"
  case "$r" in *ORA-*|*ERROR*|"") echo "instancia fora do ar";; *) echo "$r";; esac
}

ultima_exec() {   # $1 = nome do .gpg ; imprime "data  status"
  local f st
  f="$(ls -1t "$LOGDIR/${1%.*}"_*.log 2>/dev/null | head -1)"
  [ -z "$f" ] && { printf "%s" "${C_CZ}nunca executado${C_0}"; return; }
  if grep -q "\[NOK\]" "$f"; then st="${C_AM}! nada quebrado${C_0}"
  elif grep -q "\[OK\] ALGO FOI QUEBRADO" "$f"; then st="${C_VD}+ quebrado${C_0}"
  else st="${C_VM}x erro${C_0}"; fi
  printf "%s  %s" "$(date -r "$f" '+%d/%m %H:%M')" "$st"
}

QUEBRA() {
  DIR="${QUEBRA_DIR:-$QUEBRA_DIR_DEFAULT}"
  LOGDIR="${QUEBRA_LOG_DIR:-$QUEBRA_LOG_DIR_DEFAULT}"
  [[ -d "$LOGDIR" ]] || mkdir -p "$LOGDIR"
  [[ -d "$DIR" ]] || { echo "[ERRO] diretorio nao encontrado: $DIR"; return 1; }
  mapfile -t FILES < <(ls -1 "$DIR"/quebra_*.sh.gpg 2>/dev/null | sort -V)
  (( ${#FILES[@]} == 0 )) && { echo "[INFO] nenhum quebra_*.sh.gpg em $DIR"; return 0; }

  echo
  echo "${C_LAR}${LINHA}${C_0}"
  echo "${C_LAR}${C_B}   POWERLAB DATA GUARD  ::  GERADOR DE PROBLEMAS${C_0}                        ${C_CZ}dbasobrinho.com.br${C_0}"
  echo "${C_LAR}${LINHA}${C_0}"
  printf "   %sServidor:%s %-10s %sInstancia:%s %-8s %sBanco:%s %s\n" "$C_AZ" "$C_0" "$(hostname -s)" "$C_AZ" "$C_0" "${ORACLE_SID:-?}" "$C_AZ" "$C_0" "$(info_banco)"
  echo "${C_CZ}${TRACO}${C_0}"
  printf "   ${C_B}%-4s %-14s %-32s %s${C_0}\n" "ID" "Problema" "Arquivo" "Ultima execucao"
  echo "${C_CZ}${TRACO}${C_0}"
  local i=0 f base num
  for f in "${FILES[@]}"; do
    ((i++)); base=$(basename "$f"); num="???"
    [[ "$base" =~ ([0-9]{3}) ]] && num="${BASH_REMATCH[1]}"
    printf "   ${C_LAR}%-4s${C_0} %-14s ${C_CZ}%-32s${C_0} %s\n" "$i" "Problema $num" "$base" "$(ultima_exec "$base")"
  done
  echo "${C_CZ}${TRACO}${C_0}"
  echo "   Digite o ${C_B}ID${C_0} do problema  |  ${C_B}q${C_0} = sair"
  echo "${C_LAR}${LINHA}${C_0}"
  echo
  local choice
  read -r -p "   Sua escolha: " choice
  [[ -z "$choice" || "$choice" =~ ^[Qq]$ ]] && { echo "   saindo..."; return 0; }
  [[ "$choice" =~ ^[0-9]+$ ]] || { echo "   ${C_VM}[ERRO] entrada invalida${C_0}"; return 1; }
  (( choice < 1 || choice > ${#FILES[@]} )) && { echo "   ${C_VM}[ERRO] ID invalido${C_0}"; return 1; }

  local sel="${FILES[choice-1]}"; base=$(basename "$sel"); num="???"
  [[ "$base" =~ ([0-9]{3}) ]] && num="${BASH_REMATCH[1]}"
  echo
  local l
  echo "${C_VM}###############################################################################${C_0}"
  for l in "" "  ATENCAO: o PROBLEMA $num vai ser gerado de proposito neste ambiente." \
           "  Use somente no laboratorio PowerLab Data Guard. Nunca em producao." ""; do
    printf "%s#%s %-75s %s#%s\n" "$C_VM" "$C_0" "$l" "$C_VM" "$C_0"
  done
  echo "${C_VM}###############################################################################${C_0}"
  echo
  local conf
  read -r -p "   Para confirmar digite DUAL e pressione Enter: " conf
  [[ "$conf" =~ ^[Dd][Uu][Aa][Ll]$ ]] || { echo "   cancelado."; return 1; }

  local ts logf rc senha
  ts=$(date "+%Y%m%d_%H%M%S"); logf="$LOGDIR/${base%.*}_$ts.log"
  senha="$(printf "%s" "$BASE_B64" | base64 -d)"
  echo
  echo "   ${C_AZ}>> Gerando o problema $num ...${C_0}  ${C_CZ}(log: $logf)${C_0}"
  echo "${C_CZ}${TRACO}${C_0}"
  {
    set -o pipefail
    echo "== $(date '+%Y-%m-%d %H:%M:%S') | Inicio | Host: $(hostname) | Usuario: $(whoami) | Script: $sel"
    if printf "%s" "$senha" | "$GPG_BIN" --batch --yes --passphrase-fd 0 --pinentry-mode loopback -d "$sel" >/dev/null 2>&1; then
      printf "%s" "$senha" | "$GPG_BIN" --batch --yes --passphrase-fd 0 --pinentry-mode loopback -d "$sel" 2>/dev/null | tr -d '\r' | bash
      rc=$?
    else
      printf "%s" "$senha" | "$GPG_BIN" --batch --yes --passphrase-fd 0 -d "$sel" 2>/dev/null | tr -d '\r' | bash
      rc=$?
    fi
    echo "== $(date '+%Y-%m-%d %H:%M:%S') | Fim | RC=$rc"
    exit $rc
  } 2>&1 | tee -a "$logf" | grep -vE '^== '
  rc=${PIPESTATUS[0]}
  echo "${C_CZ}${TRACO}${C_0}"
  if (( rc == 0 )); then
    echo "   ${C_VD}${C_B}PROBLEMA $num GERADO.${C_0} Agora e com voce: descubra o que quebrou e corrija."
  elif grep -q "\[NOK\]" "$logf"; then
    echo "   ${C_AM}${C_B}NADA FOI QUEBRADO.${C_0} O ambiente ainda nao permite este problema (motivo acima)."
  else
    echo "   ${C_VM}${C_B}ERRO ao executar o problema $num (RC=$rc).${C_0} Veja o log: $logf"
  fi
  echo
  return $rc
}

QUEBRA
