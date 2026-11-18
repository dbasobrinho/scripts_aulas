#!/bin/bash
# ==================================================================================================
# Script Name  : atualiza_quebra.sh
# Autor        : DBA Sobrinho
# Data         : 17/11/2026
# Versao       : 1.2
# Descricao    : Tenta baixar do GitHub a versao mais nova do robo de quebras (menu + quebra_*.sh.gpg).
#                Baixa numa pasta temporaria, valida (sintaxe do menu e decifra cada .gpg) e so entao
#                troca a pasta QUEBRA. Se nao houver internet ou algo falhar, mantem a versao local.
#                Antes disso, atualiza a si mesmo (atualiza_quebra.sh da mesma pasta do GitHub).
# Uso          : chamado pelo alias "quebra" antes de abrir o menu
# ==================================================================================================
set -u
REPO="${QUEBRA_REPO:-dbasobrinho/scripts_aulas}"
BRANCH="${QUEBRA_BRANCH:-main}"
CAMINHO="${QUEBRA_CAMINHO:-2611_PLDG19-1_T03/quebra.gpg}"
DIR="${QUEBRA_DIR:-/home/oracle/ADMDBA/PLDG/QUEBRA}"
API="https://api.github.com/repos/${REPO}/contents/${CAMINHO}?ref=${BRANCH}"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}/${CAMINHO}"
SELF="$(readlink -f "$0")"
SELF_URL="${QUEBRA_SELF_URL:-$RAW/atualiza_quebra.sh}"
TMP="$(mktemp -d /tmp/quebra_upd.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

msg() { echo "[robo] $*"; }
baixa() { wget -q -T 10 -t 1 -O "$2" "$1" 2>/dev/null && [ -s "$2" ]; }

# 0) auto-atualizacao: so uma vez por chamada (ATUALIZA_QUEBRA_REEXEC evita loop)
if [ -z "${ATUALIZA_QUEBRA_REEXEC:-}" ] && [ -f "$SELF" ] && [ -w "$(dirname "$SELF")" ]; then
  if baixa "$SELF_URL" "$TMP/self.sh" \
     && grep -q '^# Script Name  : atualiza_quebra.sh' "$TMP/self.sh" \
     && bash -n "$TMP/self.sh" 2>/dev/null \
     && ! cmp -s "$TMP/self.sh" "$SELF"; then
    cp "$TMP/self.sh" "${SELF}.novo" && chmod 755 "${SELF}.novo" && cp -p "$SELF" "${SELF}.anterior" \
      && mv -f "${SELF}.novo" "$SELF" \
      && { msg "atualizador atualizado do GitHub (versao anterior em ${SELF}.anterior)"; rm -rf "$TMP"; ATUALIZA_QUEBRA_REEXEC=1 exec bash "$SELF" "$@"; }
    rm -f "${SELF}.novo"
  fi
fi

# 1) lista de arquivos: API do GitHub; se falhar, nomes conhecidos
LISTA=""
if baixa "$API" "$TMP/lista.json"; then
  LISTA="$(grep -o '"name": *"[^"]*"' "$TMP/lista.json" | sed 's/.*"name": *"//;s/"$//' | grep -E '^(\.quebra_menu\.sh|quebra_[0-9]{3}_.*\.sh\.gpg)$')"
fi
if [ -z "$LISTA" ]; then
  LISTA=".quebra_menu.sh $(for n in $(seq -w 1 20); do printf 'quebra_0%s_PRIM_STBY.sh.gpg ' "$n"; done)"
  MODO="raw"
else
  MODO="api"
fi

# 2) baixa tudo para a pasta temporaria
mkdir -p "$TMP/novo"
for f in $LISTA; do baixa "$RAW/$f" "$TMP/novo/$f" || rm -f "$TMP/novo/$f"; done
NGPG="$(ls "$TMP/novo"/quebra_*.sh.gpg 2>/dev/null | wc -l)"
if [ "$NGPG" -eq 0 ]; then
  msg "sem acesso ao GitHub: usando a versao local ($(ls "$DIR"/quebra_*.sh.gpg 2>/dev/null | wc -l) quebras)"
  exit 0
fi

# 3) menu: usa o baixado (se a sintaxe estiver ok) ou mantem o local
if [ -f "$TMP/novo/.quebra_menu.sh" ] && bash -n "$TMP/novo/.quebra_menu.sh" 2>/dev/null; then
  :
elif [ -f "$DIR/.quebra_menu.sh" ]; then
  cp -p "$DIR/.quebra_menu.sh" "$TMP/novo/.quebra_menu.sh"
else
  msg "menu nao encontrado nem no GitHub nem local: mantendo a versao local"; exit 0
fi

# 4) valida: cada .gpg precisa decifrar com a senha do menu
SENHA="$(sed -n 's/^BASE="\(.*\)"$/\1/p' "$TMP/novo/.quebra_menu.sh" | head -1)"
if [ -z "$SENHA" ]; then
  SENHA="$(sed -n 's/^BASE_B64="\(.*\)"$/\1/p' "$TMP/novo/.quebra_menu.sh" | head -1 | base64 -d 2>/dev/null)"
fi
for g in "$TMP/novo"/quebra_*.sh.gpg; do
  if ! printf "%s" "$SENHA" | gpg --batch --yes --passphrase-fd 0 -d "$g" 2>/dev/null | tr -d '\r' | bash -n 2>/dev/null; then
    msg "arquivo invalido no GitHub ($(basename "$g")): mantendo a versao local"; exit 0
  fi
done

# 5) igual ao local? nada a fazer
if [ -d "$DIR" ] && diff -rq "$TMP/novo" "$DIR" >/dev/null 2>&1; then
  msg "robo ja esta atualizado ($NGPG quebras)"; exit 0
fi

# 6) troca: guarda a anterior e instala a nova
chmod 755 "$TMP/novo"/*.sh 2>/dev/null; chmod 644 "$TMP/novo"/*.gpg
rm -rf "${DIR}.anterior"
[ -d "$DIR" ] && mv "$DIR" "${DIR}.anterior"
if mv "$TMP/novo" "$DIR"; then
  msg "robo atualizado do GitHub ($NGPG quebras, via $MODO). Versao anterior em ${DIR}.anterior"
else
  [ -d "${DIR}.anterior" ] && mv "${DIR}.anterior" "$DIR"
  msg "falha ao instalar: mantida a versao local"
fi
exit 0
