
#!/usr/bin/env bash
# =========================================================================================
#  Script Name..: 01.srvora4_AUTOBR_RUN_BACKUP.sh
#  Autor........: Roberto Fernandes Sobrinho (DBA Sobrinho)  
#  Data.........: 28/09/2025
#  Versão.......: 1.11
#
#  Descrição....: Sobe a instância em MOUNT e executa backup RMAN do AUTOBR
#                 (DATABASE + SPFILE + CONTROLFILE) em DISK, com compressão e logs dedicados.
#
#  Escopo.......: Ambiente Oracle Database on-prem/VM com ASM. Execução como root,
#                 mas usando o ambiente do usuário oracle para SQL*Plus e RMAN.
#
#  Requisitos...:
#                 1) Usuário root com sudo para alternar para o usuário oracle:
#                    - sudo -iu oracle bash -lc "<comando>"
#                 2) bash_profile do usuário oracle configurado:
#                    - ORACLE_SID=<AUTOBR>
#                    - ORACLE_HOME, PATH, TNS_ADMIN e oraenv OK
#                 3) Diretório de destino acessível ao oracle:
#                    - BACKUP_DIR=/root/ADMDBA/PLDG/bkp_AUTOBR (ou outro)
#                    - Permissões: oracle:oinstall, 775
#                 4) Espaço em disco suficiente no filesystem do BACKUP_DIR.
#
#  Pré-checks...:
#                 - Verificar se a instância correta será usada:
#                   [oracle]$ echo $ORACLE_SID
#                 - Confirmar que não há backups concorrentes:
#                   [oracle]$ ps -ef | egrep 'rman|backup' | grep -v grep
#
#  Variáveis....:
#                 ORACLE_SID   = Nome lógico da instância (para TAGs e identificação)
#                 BACKUP_DIR   = Pasta onde os backup pieces e o log do RMAN serão armazenados
#                 STAMP        = Timestamp único do run (yyyyMMdd_HHmm)
#                 EXEC_LOG     = Log de execução do shell (no diretório atual)
#                 RMAN_LOG     = Log detalhado do RMAN (cópia em BACKUP_DIR)
#
#  Saída........:
#                 - BACKUP_DIR/DTF_%U.bkp   -> backupset do DATABASE
#                 - BACKUP_DIR/SPF_%U.bkp   -> SPFILE
#                 - BACKUP_DIR/CRL_%U.bkp   -> CONTROLFILE
#                 - BACKUP_DIR/backup_${STAMP}.log  -> log completo do RMAN
#                 - RUN_BACKUP_AUTOBR_exec_${STAMP}.log -> log do script
#
#  Retenção.....:
#                 - A limpeza não é feita automaticamente. Opcional:
#                   rman> DELETE NOPROMPT OBSOLETE;
#                   rman> REPORT OBSOLETE;
#                 - Ou política por filesystem (find -mtime, logrotate, cron).
#
#  Como usar....:
#                 [root]# bash ./RUN_BACKUP_AUTOBR.sh
#
#  Exemplos.....:
#                 - Execução direta:
#                   [root@srvora1]# ./RUN_BACKUP_AUTOBR.sh
#
#                 - via cron (todos os dias às 02:00):
#                   0 2 * * * /usr/bin/bash /root/ADMDBA/PLDG/RUN_BACKUP_AUTOBR.sh >> /root/ADMDBA/PLDG/cron.log 2>&1
#
#  Interrupção..:
#                 - Se o usuário interromper (Ctrl+C), alguns pieces podem ficar parciais.
#                 - Após interrupção, recomenda-se:
#                   rman> CROSSCHECK BACKUP;
#                   rman> DELETE NOPROMPT EXPIRED;
#                   rman> BACKUP DATABASE NOT BACKED UP;
#
#  Restauração..:
#                 - Controlfile:
#                   rman> RESTORE CONTROLFILE FROM '<BACKUP_DIR>/CRL_<piece>.bkp';
#                 - SPFILE:
#                   rman> RESTORE SPFILE FROM '<BACKUP_DIR>/SPF_<piece>.bkp';
#                 - Database:
#                   rman> RESTORE DATABASE;
#                   rman> RECOVER DATABASE;
#
#  Segurança....:
#                 - Evite afrouxar permissões do /root. Se possível, use BACKUP_DIR fora de /root
#                   (ex.: /u01/backup/...) ou ACL para conceder rx ao oracle.
#                 - Proteja logs e backup pieces contra leitura indevida.
#
#  Compatibilidade:
#                 - Testado em Oracle 19c. RMAN device type DISK, ASM no backend.
#                 - GNU/Linux x86_64. Shell bash.
#
#  Códigos......:
#                 0   = sucesso
#                 1   = oracle não consegue escrever em BACKUP_DIR
#                 130 = interrompido pelo usuário (Ctrl+C), se trap estiver habilitado
#                 >0  = erro retornado pelo RMAN ou comandos auxiliares
#
#  Troubleshooting:
#                 - Verificar logs: EXEC_LOG e RMAN_LOG
#                 - Validar peças: rman> VALIDATE BACKUPSET <id>;
#                 - Listar backups: rman> LIST BACKUP SUMMARY;
#
#  Histórico....:
#                 1.11  28/09/2025  Prefixos nos arquivos: DTF_, SPF_, CRL_ e padronização [FINAL  >]
#                 1.10  28/09/2025  Ajustes de expansão de variáveis, logs e limpeza de temporários
#                 1.8   28/09/2025  Versão estável base usada em produção
#
#  Observações..:
#                 - Este cabeçalho serve como contrato operacional. Qualquer mudança em
#                   BACKUP_DIR, número de canais ou formatos deve ser refletida aqui.
# =========================================================================================


set -e

ORACLE_SID="AUTOBR"
BACKUP_DIR="/root/ADMDBA/PLDG/bkp_AUTOBR"
STAMP="$(date +%Y%m%d_%H%M)"
EXEC_LOG="./01.srvora4_AUTOBR_RUN_BACKUP_exec_${STAMP}.log"
RMAN_LOG="${BACKUP_DIR}/backup_${STAMP}.log"
RMAN_TMPLOG="/tmp/backup_${ORACLE_SID}_${STAMP}.log"
SQL_MOUNT="/tmp/sql_mount_${STAMP}.sql"
RMAN_CMD="/tmp/rman_${ORACLE_SID}_${STAMP}.rman"

# ===================== Cabeçalho =====================
echo "================================================================================" | tee "$EXEC_LOG"
echo "BACKUP ${ORACLE_SID} - Início: $(date '+%d/%m/%Y %H:%M:%S')" | tee -a "$EXEC_LOG"
echo "Destino dos arquivos..: ${BACKUP_DIR}" | tee -a "$EXEC_LOG"
echo "Log detalhado RMAN....: ${RMAN_LOG}" | tee -a "$EXEC_LOG"
echo "Log de execução.......: ${EXEC_LOG}" | tee -a "$EXEC_LOG"
echo "================================================================================" | tee -a "$EXEC_LOG"

# ===================== Diretórios e permissões =====================
# Garante árvore e permissões para o oracle conseguir escrever e atravessar
mkdir -p /root/ADMDBA/PLDG
chmod 711 /root
chmod 755 /root/ADMDBA /root/ADMDBA/PLDG
mkdir -p "${BACKUP_DIR}"
chown -R oracle:oinstall "${BACKUP_DIR}"
chmod 775 "${BACKUP_DIR}"

# Cria o arquivo de log do RMAN e ajusta permissões para o oracle
touch "${RMAN_LOG}"
chown oracle:oinstall "${RMAN_LOG}"
chmod 664 "${RMAN_LOG}"

# ===================== PASSO 1: SHUTDOWN IMMEDIATE; STARTUP MOUNT =====================
echo "[PASSO 1] Parando e subindo banco em MOUNT..." | tee -a "$EXEC_LOG"

# Cria o SQL de mount como oracle
sudo -iu oracle bash -lc "cat > '${SQL_MOUNT}'" <<'SQL'
WHENEVER SQLERROR CONTINUE
ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM ARCHIVE LOG CURRENT;
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
EXIT
SQL

# Executa o SQL de mount
sudo -iu oracle bash -lc "sqlplus -S / as sysdba @'${SQL_MOUNT}'" >> "${EXEC_LOG}" 2>&1 || true
sudo -iu oracle rm -f "${SQL_MOUNT}" 2>/dev/null || true

# ===================== PASSO 2: BACKUP (DB + SPFILE + CONTROLFILE) =====================
echo "[PASSO 2] Iniciando backup (DATABASE + SPFILE + CONTROLFILE)..." | tee -a "$EXEC_LOG"

# Verifica se o oracle consegue escrever no diretório de backup
if ! sudo -iu oracle bash -lc "test -w '${BACKUP_DIR}'"; then
  echo "[ERRO] Usuário 'oracle' não consegue escrever em ${BACKUP_DIR}. Ajuste permissões e execute novamente." | tee -a "$EXEC_LOG"
  exit 1
fi

# Cria o script RMAN como oracle (evita problemas de permissão)
sudo -iu oracle bash -lc "cat > '${RMAN_CMD}'" <<EOF
RUN {
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK FORMAT '${BACKUP_DIR}/DTF_full_%U.bkp';
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK FORMAT '${BACKUP_DIR}/DTF_full_%U.bkp';
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK FORMAT '${BACKUP_DIR}/DTF_full_%U.bkp';

  BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG FROM TIME 'SYSDATE-1/24' UNTIL TIME 'SYSDATE' FORMAT '${BACKUP_DIR}/ARC_%U.bkp';
	
  BACKUP AS COMPRESSED BACKUPSET DATABASE TAG 'FULL_DB_${ORACLE_SID}_${STAMP}';
  BACKUP SPFILE FORMAT '${BACKUP_DIR}/SPF_%U.bkp' TAG 'SPFILE_${ORACLE_SID}_${STAMP}';
  BACKUP CURRENT CONTROLFILE FORMAT '${BACKUP_DIR}/CRL_%U.bkp' TAG 'CTRL_${ORACLE_SID}_${STAMP}';

  RELEASE CHANNEL c1;
  RELEASE CHANNEL c2;
  RELEASE CHANNEL c3;
}
EXIT
EOF

# Executa o RMAN logando em /tmp (sempre gravável) e depois copia para o destino
sudo -iu oracle bash -lc "rman target / cmdfile='${RMAN_CMD}' log='${RMAN_TMPLOG}'" >> "${EXEC_LOG}" 2>&1
RC=$?

# Copia msglog para o diretório final e garante permissões
cp -f "${RMAN_TMPLOG}" "${RMAN_LOG}" 2>/dev/null || true
chown oracle:oinstall "${RMAN_LOG}" 2>/dev/null || true
chmod 664 "${RMAN_LOG}" 2>/dev/null || true

# Limpa temporários
sudo -iu oracle rm -f "${RMAN_CMD}" "${RMAN_TMPLOG}" 2>/dev/null || true

# ===================== Resultado =====================
if [[ ${RC} -eq 0 ]]; then
  echo "[FINAL >] Backup concluído com sucesso em $(date '+%d/%m/%Y %H:%M:%S')" | tee -a "${EXEC_LOG}"
  echo "Arquivos de backup em: ${BACKUP_DIR}" | tee -a "${EXEC_LOG}"
  echo "Log do RMAN..........: ${RMAN_LOG}" | tee -a "${EXEC_LOG}"
else
  echo "[ERRO] Backup finalizado com erro (RC=${RC}). Consulte: ${RMAN_LOG}" | tee -a "${EXEC_LOG}"
fi
echo "================================================================================" | tee -a "${EXEC_LOG}"

