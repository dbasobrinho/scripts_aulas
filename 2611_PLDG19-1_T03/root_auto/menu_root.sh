#!/bin/bash
# ==================================================================================================
# Script Name  : menu_root.sh
# Autor        : DBA Sobrinho
# Data         : 17/11/2026
# Versao       : 1.2
# Descricao    : Menu (root) dos scripts de recomposicao do lab PowerLab Data Guard.
#                Mostra a ordem certa, onde cada script roda e se pode rodar NESTA maquina;
#                bloqueia execucao no servidor errado, pede confirmacao e grava log de cada execucao.
# Uso          : como root, digite: menu
# ==================================================================================================
SCR_DIR="/root/ADMDBA/PLDG/SCRIPTS"
LOG_DIR="/root/ADMDBA/PLDG/logs_root"
HOST="$(hostname -s)"

# catalogo: arquivo | onde roda | passo | descricao
CAT=(
"02.srvora4_AUTOBR_RECRIA_AUTOBR_DROP_RESTORE.sh|srvora4|1|Recria o primario AUTOBR a partir do backup (DROP + RESTORE)"
"05_srvora3_srvora4_AJUSTA_LISTENER_GRID_PARA_DG.sh|ambos|2|listener.ora do Grid com as entradas estaticas do DG"
"06_srvora3_srvora4_AJUSTA_TNANAMES_ORACLE_PARA_DG.sh|ambos|3|tnsnames.ora com os aliases do DG"
"08_srvora3_srvora4_AJUSTA_ORAPW_PARA_DG.sh|ambos|4|Arquivo de senha (orapw) igual nos dois servidores"
"07_srvora4_AUTOBR_DG_PARAMS_E_ARCHIVE_FLASHBACK_total.sh|srvora4|5|Primario: DG, ARCHIVELOG, FLASHBACK, FORCE LOGGING e SRL"
"04_srvora3_AUTOUS_DROP_DATABASE_EXEC_DUPLICATE_INICIA_DR.sh|srvora3|6|Recria o standby: DROP + DUPLICATE + MRP"
"03_srvora3_AUTOUS_DROP_DATABASE.sh|srvora3|opc|So apaga o standby AUTOUS (o passo 6 ja faz isso)"
"00.srvora4_AUTOBR_DOWNLOAD_BKP_AUTOBR_GITHUB.sh|srvora4|opc|Baixa o backup do GitHub (a imagem ja traz em bkp_AUTOBR)"
"01.srvora4_AUTOBR_RUN_BACKUP.sh|srvora4|instr|Gera um backup NOVO do AUTOBR (uso do instrutor)"
)

if [ -t 1 ] && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  C_LAR=$'\e[38;5;208m'; C_AZ=$'\e[38;5;75m'; C_VD=$'\e[32m'; C_AM=$'\e[33m'; C_VM=$'\e[31m'
  C_CZ=$'\e[90m'; C_B=$'\e[1m'; C_0=$'\e[0m'
else
  C_LAR=""; C_AZ=""; C_VD=""; C_AM=""; C_VM=""; C_CZ=""; C_B=""; C_0=""
fi
LINHA="=================================================================================================================="
TRACO="------------------------------------------------------------------------------------------------------------------"

pode_aqui() { [ "$1" = "ambos" ] || [ "$1" = "$HOST" ]; }

info_banco() {
  local sid r
  sid="$(su - oracle -c 'echo $ORACLE_SID' 2>/dev/null)"
  pgrep -f "ora_pmon_${sid}\$" >/dev/null 2>&1 || { echo "${sid:-?} | instancia fora do ar"; return; }
  r="$(su - oracle -c 'sqlplus -s / as sysdba' 2>/dev/null <<'EOSQL' | grep '^PAPEL=' | head -1 | sed 's/^PAPEL=//'
set heading off feedback off pagesize 0
select 'PAPEL='||db_unique_name||' | '||database_role||' | '||open_mode from v$database;
exit
EOSQL
)"
  echo "${sid} | ${r:-nao foi possivel consultar}"
}

ultima_exec() {   # $1 = arquivo do script -> 13 colunas visiveis
  local f
  f="$(ls -1t "$LOG_DIR/${1%.sh}"_*.log 2>/dev/null | head -1)"
  [ -z "$f" ] && { printf "%s%-13s%s" "$C_CZ" "nunca rodou" "$C_0"; return; }
  if grep -q "^== RC=0$" "$f"; then printf "%s✔ %s%s" "$C_VD" "$(date -r "$f" '+%d/%m %H:%M')" "$C_0"
  else printf "%s✖ %s%s" "$C_VM" "$(date -r "$f" '+%d/%m %H:%M')" "$C_0"; fi
}

mostra_menu() {
  echo
  echo "${C_LAR}${LINHA}${C_0}"
  echo "${C_LAR}${C_B}   POWERLAB DATA GUARD  ::  RECOMPOSICAO DO LAB (root)${C_0}                                   ${C_CZ}dbasobrinho.com.br${C_0}"
  echo "${C_LAR}${LINHA}${C_0}"
  printf "   %sServidor:%s %-9s %sBanco:%s %s\n" "$C_AZ" "$C_0" "$HOST" "$C_AZ" "$C_0" "$(info_banco)"
  echo "   ${C_AZ}Ordem:${C_0} passo 1 (srvora4) > passos 2, 3 e 4 (nos dois) > passo 5 (srvora4) > passo 6 (srvora3)"
  echo "${C_CZ}${TRACO}${C_0}"
  printf "   ${C_B}%-3s %-9s %-66s %-8s %-18s %s${C_0}\n" "ID" "Passo" "O que faz" "Onde" "Aqui" "Ultima vez"
  echo "${C_CZ}${TRACO}${C_0}"
  local i=0 e arq onde passo desc aqui p
  for e in "${CAT[@]}"; do
    ((i++)); IFS='|' read -r arq onde passo desc <<< "$e"
    case "$passo" in opc) p="opcional";; instr) p="instrutor";; *) p="  $passo";; esac
    if [ ! -f "$SCR_DIR/$arq" ]; then aqui="${C_VM}✖ sem arquivo     ${C_0}"
    elif pode_aqui "$onde"; then aqui="${C_VD}✔ pode rodar      ${C_0}"
    else aqui="${C_CZ}✖ outro servidor  ${C_0}"; fi
    printf "   %s%-3s%s %-9s %-66s %-8s %s %s\n" "$C_LAR" "$i" "$C_0" "$p" "${desc:0:66}" "$onde" "$aqui" "$(ultima_exec "$arq")"
  done
  echo "${C_CZ}${TRACO}${C_0}"
  echo "   ${C_VD}✔${C_0} pode rodar neste servidor   ${C_CZ}✖${C_0} roda no outro servidor        Ultima vez: ${C_VD}✔${C_0} terminou ok   ${C_VM}✖${C_0} terminou com erro"
  echo "   Digite o ${C_B}ID${C_0} do script  |  ${C_B}a${C_0} = baixar de novo do GitHub  |  ${C_B}q${C_0} = sair"
  echo "${C_LAR}${LINHA}${C_0}"
}

# ------------------------------------------------------------------ baixar de novo do GitHub
REPO="${ROOT_REPO:-dbasobrinho/scripts_aulas}"
BRANCH="${ROOT_BRANCH:-main}"
CAMINHO="${ROOT_CAMINHO:-2611_PLDG19-1_T03/root_auto}"

atualiza_github() {
  local tmp ref sha lista f n
  tmp="$(mktemp -d /tmp/root_upd.XXXXXX)"
  falha() { echo "   ${C_VM}[ERRO] $*: nada foi alterado.${C_0}"; rm -rf "$tmp"; return 1; }
  echo "   ${C_AZ}>> consultando o GitHub (${REPO}/${CAMINHO})...${C_0}"
  # baixa pelo SHA do ultimo commit da pasta: o raw pela branch fica ate 5 min em cache
  ref="$BRANCH"
  if wget -q -T 10 -t 1 -O "$tmp/commit.json" "https://api.github.com/repos/${REPO}/commits?path=${CAMINHO}&sha=${BRANCH}&per_page=1"; then
    sha="$(grep -o '"sha": *"[0-9a-f]\{40\}"' "$tmp/commit.json" | head -1 | grep -o '[0-9a-f]\{40\}')"
    [ -n "$sha" ] && ref="$sha"
  fi
  wget -q -T 10 -t 1 -O "$tmp/lista.json" "https://api.github.com/repos/${REPO}/contents/${CAMINHO}?ref=${ref}" || { falha "sem acesso ao GitHub"; return 1; }
  lista="$(grep -o '"name": *"[^"]*"' "$tmp/lista.json" | sed 's/.*"name": *"//;s/"$//' | grep -E '\.(sh|ora|bin)$')"
  [ -n "$lista" ] || { falha "a pasta no GitHub esta vazia"; return 1; }
  mkdir -p "$tmp/novo"
  for f in $lista; do
    wget -q -T 20 -t 1 -O "$tmp/novo/$f" "https://raw.githubusercontent.com/${REPO}/${ref}/${CAMINHO}/$f" && [ -s "$tmp/novo/$f" ] \
      || { falha "nao foi possivel baixar $f"; return 1; }
  done
  # validacoes antes de trocar
  [ -f "$tmp/novo/menu_root.sh" ] || { falha "o menu_root.sh nao veio do GitHub"; return 1; }
  for f in "$tmp/novo"/*.sh; do bash -n "$f" 2>/dev/null || { falha "sintaxe invalida em $(basename "$f")"; return 1; }; done
  for f in "$tmp/novo"/*.ora; do
    [ "$(tr -cd '(' < "$f" | wc -c)" = "$(tr -cd ')' < "$f" | wc -c)" ] || { falha "parenteses desbalanceados em $(basename "$f")"; return 1; }
  done
  n="$(ls "$tmp/novo" | wc -l)"
  if diff -rq "$tmp/novo" "$SCR_DIR" >/dev/null 2>&1; then
    echo "   ${C_VD}✔ os scripts ja estao atualizados (${n} arquivos).${C_0}"; rm -rf "$tmp"; return 0
  fi
  chown root:root "$tmp/novo"/*; chmod 644 "$tmp/novo"/*; chmod 755 "$tmp/novo"/*.sh
  rm -rf "${SCR_DIR}.anterior"; cp -a "$SCR_DIR" "${SCR_DIR}.anterior"
  find "$SCR_DIR" -maxdepth 1 -type f -delete
  cp -p "$tmp/novo"/* "$SCR_DIR/"
  rm -rf "$tmp"
  echo "   ${C_VD}✔ scripts atualizados do GitHub (${n} arquivos).${C_0} Versao anterior em ${SCR_DIR}.anterior"
  read -r -p "   Enter para recarregar o menu..." _
  exec bash "$SCR_DIR/menu_root.sh"
}

executa() {   # $1 = indice (1..N)
  local e arq onde passo desc ts logf rc conf
  e="${CAT[$1-1]}"; IFS='|' read -r arq onde passo desc <<< "$e"
  echo
  if [ ! -f "$SCR_DIR/$arq" ]; then echo "   ${C_VM}[ERRO] arquivo nao encontrado: $SCR_DIR/$arq${C_0}"; return 1; fi
  if ! pode_aqui "$onde"; then
    echo "   ${C_VM}${C_B}BLOQUEADO:${C_0} este script roda no ${C_B}${onde}${C_0} e voce esta no ${C_B}${HOST}${C_0}."
    return 1
  fi
  echo "   ${C_B}Script:${C_0} $arq"
  echo "   ${C_B}Faz...:${C_0} $desc"
  echo "   ${C_B}Onde..:${C_0} $onde   |   ${C_B}Passo:${C_0} $passo"
  [ "$passo" = "instr" ] && echo "   ${C_AM}Atencao: este script e de uso do instrutor.${C_0}"
  echo
  read -r -p "   Executar agora neste servidor (${HOST})? [s/N]: " conf
  [[ "$conf" =~ ^[Ss]$ ]] || { echo "   cancelado."; return 0; }
  mkdir -p "$LOG_DIR"
  ts="$(date '+%Y%m%d_%H%M%S')"; logf="$LOG_DIR/${arq%.sh}_${ts}.log"
  echo "   ${C_AZ}>> executando...${C_0}  ${C_CZ}(log: $logf)${C_0}"
  echo "${C_CZ}${TRACO}${C_0}"
  ( cd "$SCR_DIR" && bash "./$arq" ) 2>&1 | tee -a "$logf"
  rc=${PIPESTATUS[0]}
  echo "== RC=$rc" >> "$logf"
  echo "${C_CZ}${TRACO}${C_0}"
  if (( rc == 0 )); then echo "   ${C_VD}${C_B}Terminou OK.${C_0}  Log: $logf"
  else echo "   ${C_VM}${C_B}Terminou com erro (RC=$rc).${C_0}  Log: $logf"; fi
}

while true; do
  mostra_menu
  echo
  read -r -p "   Sua escolha: " op
  case "$op" in
    ""|q|Q) echo "   saindo..."; exit 0;;
    a|A) atualiza_github;;
    *[!0-9]*) echo "   ${C_VM}[ERRO] entrada invalida${C_0}";;
    *) if (( op >= 1 && op <= ${#CAT[@]} )); then executa "$op"; else echo "   ${C_VM}[ERRO] ID invalido${C_0}"; fi;;
  esac
  echo
  read -r -p "   Enter para voltar ao menu..." _
done
