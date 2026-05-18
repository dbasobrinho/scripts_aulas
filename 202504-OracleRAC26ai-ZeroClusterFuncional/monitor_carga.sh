#!/bin/bash
# ======================================================================
# monitor_carga.sh
# Monitoramento em tempo real dos scripts de carga (SRV_HR / SRV_CO / SRV_SH)
# Exibe status do service, configuracao de failover e ultima linha do log.
# Atualiza a cada 2 segundos.
#
# Uso: bash /home/oracle/scripts_carga/monitor_carga.sh
# ======================================================================

while true; do
  echo "============================================================"
  printf "=== CARGA RAC - %s ===\n" "$(date '+%Y-%m-%d %H:%M:%S')"
  ALL_STATUS=$(/u01/app/26ai/grid/bin/srvctl status service -d CORP 2>/dev/null)
  for svc in hr co sh; do
    LOGS=$(find /tmp -name "carga_${svc}_*.log" -mmin -2 2>/dev/null | sort)
    SVC="SRV_${svc^^}"
    STATUS=$(echo "$ALL_STATUS" | grep "$SVC" | tr '\n' ' ')
    FOVER=$(/u01/app/26ai/grid/bin/srvctl config service -d CORP -s "$SVC" 2>/dev/null \
              | grep -i failover | tr '\n' ' ')
    echo "======= $(echo $svc | tr a-z A-Z) ($SVC) ======="
    echo "  status  : $STATUS"
    echo "  failover: $FOVER"
    if [ -z "$LOGS" ]; then
      echo "  (sem log ativo)"
    else
      for LOG in $LOGS; do
        tail -1 "$LOG" 2>/dev/null | awk -v f="$LOG" '{print f " | " $0}'
      done
    fi
  done
  sleep 2
done
