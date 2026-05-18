#!/bin/bash
# ======================================================================
# monitor_crs_db.sh
# Monitoramento em tempo real dos alert logs do CRS (Clusterware) e
# das instancias de banco (CORP1 / CORP2) — Oracle RAC 26ai — DBA Sobrinho
#
# Uso: bash /home/oracle/scripts_carga/monitor_crs_db.sh
# ======================================================================

while true; do
  clear
  printf "=== ALERT LOGS - %s ===\n" "$(date '+%Y-%m-%d %H:%M:%S')"
  for LOG in /u01/app/grid/diag/crs/lnxrac0*/crs/trace/alert.log \
             /u02/app/oracle/diag/rdbms/corp/CORP*/trace/alert_CORP*.log; do
    [ -f "$LOG" ] || continue
    case "$LOG" in
      *crs*)   HDR="[CRS] - Grid Infrastructure / Clusterware" ;;
      *rdbms*) HDR="[DB]  - Oracle Database Instance"          ;;
      *)       HDR="$(basename $LOG)"                           ;;
    esac
    echo "--- $HDR ---"
    tail -25 "$LOG" 2>/dev/null
  done
  sleep 3
done
