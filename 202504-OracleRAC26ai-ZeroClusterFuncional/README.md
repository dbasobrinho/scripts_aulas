# Scripts de Carga Contínua — Oracle RAC 26ai

Scripts Perl para geração de carga contínua no ambiente Oracle RAC 26ai do curso **DBA Sobrinho**.  
Cada script conecta via SCAN em um service dedicado e executa um conjunto rotativo de SQLs,
simulando workload real de aplicação para demonstração de balanceamento, failover e TAF.

---

## Ambiente

| Item             | Valor                                      |
|------------------|--------------------------------------------|
| Cluster          | lnxrac01 / lnxrac02 (dbasobrinho.com)      |
| SCAN             | rac-scan:1521                              |
| PDB              | PBOOK                                      |
| Módulo Perl      | DBD::Oracle (compilado contra ORACLE_HOME) |

---

## Scripts

| Arquivo                  | Linguagem | Finalidade                                                   |
|--------------------------|-----------|--------------------------------------------------------------|
| `carga_hr.pl`            | Perl      | Carga contínua via SRV_HR (Active/Active)                    |
| `carga_co.pl`            | Perl      | Carga contínua via SRV_CO (Active/Active)                    |
| `carga_sh.pl`            | Perl      | Carga contínua via SRV_SH (Singleton CORP1)                  |
| `carga_monitora.sh`    | Bash      | Monitoramento em tempo real dos alert logs (CRS + instâncias)|

### Scripts de carga Perl

| Arquivo       | Schema | Service  | Tipo de Service       | Carga gerada                                      |
|---------------|--------|----------|-----------------------|---------------------------------------------------|
| `carga_hr.pl` | HR     | SRV_HR   | Active/Active         | Full scan + window functions, CONNECT BY, UPDATE+ROLLBACK |
| `carga_co.pl` | CO     | SRV_CO   | Active/Active         | Hash join orders/items/customers, UPDATE+ROLLBACK, agregação |
| `carga_sh.pl` | SH     | SRV_SH   | Singleton (CORP1)     | Full scan analytics, CONNECT BY 2000 linhas, multi-table join |

> **SRV_HR e SRV_CO** distribuem conexões entre CORP1 e CORP2 automaticamente via SCAN.  
> **SRV_SH** é Singleton — todas as conexões vão para CORP1.

---

## Onde salvar no servidor

Copiar para o home do usuário `oracle` no nó 1:

```bash
/home/oracle/scripts_carga/
```

Estrutura esperada:

```
/home/oracle/scripts_carga/
  carga_hr.pl
  carga_co.pl
  carga_sh.pl
```

### Download direto do GitHub (recomendado)

```bash
mkdir -p /home/oracle/scripts_carga
cd /home/oracle/scripts_carga

BASE="https://raw.githubusercontent.com/dbasobrinho/scripts_aulas/main/202504-OracleRAC26ai-ZeroClusterFuncional"
wget -q "$BASE/carga_hr.pl"         -O carga_hr.pl
wget -q "$BASE/carga_co.pl"         -O carga_co.pl
wget -q "$BASE/carga_sh.pl"         -O carga_sh.pl
wget -q "$BASE/carga_monitora.sh" -O carga_monitora.sh

chmod +x carga_hr.pl carga_co.pl carga_sh.pl carga_monitora.sh
```

### Validar sintaxe antes de executar

```bash
perl -c carga_hr.pl && perl -c carga_co.pl && perl -c carga_sh.pl
# Esperado: syntax OK para os três
```

---

## Pré-requisitos

1. **Schemas instalados** — HR, CO e SH devem existir no PDB PBOOK com senha `oracle`
2. **Services ativos** — SRV_HR, SRV_CO e SRV_SH devem estar em execução:
   ```bash
   srvctl status service -d CORP
   ```
3. **DBD::Oracle instalado** — módulo Perl compilado contra o ORACLE_HOME:
   ```bash
   perl -e "use DBD::Oracle; print \"DBD::Oracle OK\n\""
   ```
4. **Variáveis de ambiente do oracle** configuradas no `.bash_profile`:
   ```bash
   export ORACLE_HOME=/u02/app/oracle/product/26.0.0/dbhome_1
   export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
   ```

---

## Como executar

### Matar processos anteriores (se houver)

```bash
kill $(pgrep -f carga_) 2>/dev/null; echo "OK"
```

### Iniciar os três scripts em background

```bash
cd /home/oracle/scripts_carga

nohup perl carga_hr.pl > /tmp/carga_hr_$(date '+%H%M%S')_$(printf '%03d' $((RANDOM % 900 + 100))).log 2>&1 &
nohup perl carga_co.pl > /tmp/carga_co_$(date '+%H%M%S')_$(printf '%03d' $((RANDOM % 900 + 100))).log 2>&1 &
nohup perl carga_sh.pl > /tmp/carga_sh_$(date '+%H%M%S')_$(printf '%03d' $((RANDOM % 900 + 100))).log 2>&1 &
```

O nome do log inclui hora + número aleatório para não sobrescrever execuções anteriores.

### Confirmar que estão rodando

```bash
ps aux | grep carga | grep -v grep
```

---

## Monitorar em tempo real

Loop que exibe status do service e última linha do log de cada script (atualiza a cada 2s):

```bash
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
```

### Saída esperada

```
============================================================
=== CARGA RAC - 2026-05-18 10:15:42 ===
======= HR (SRV_HR) =======
  status  : O serviço SRV_HR está em execução nas instâncias CORP1,CORP2
  failover: Tipo de failover: NONE Método de failover: NONE ...
/tmp/carga_hr_101500_412.log | [10:15:40] SRV_HR | iter=6639 | sql=3 | rows=55 | inst=CORP2
/tmp/carga_hr_101501_883.log | [10:15:41] SRV_HR | iter=3605 | sql=2 | rows=1000 | inst=CORP1
======= CO (SRV_CO) =======
  status  : O serviço SRV_CO está em execução nas instâncias CORP1,CORP2
/tmp/carga_co_101500_271.log | [10:15:39] SRV_CO | iter=2810 | sql=1 | rows=105 | inst=CORP1
======= SH (SRV_SH) =======
  status  : O serviço SRV_SH está em execução nas instâncias CORP1
/tmp/carga_sh_101500_639.log | [10:15:40] SRV_SH | iter=4122 | sql=1 | rows=28 | inst=CORP1
```

---

## O que cada campo do log significa

```
[10:15:40] SRV_HR | iter=6639 | sql=3 | rows=55 | inst=CORP2
    │          │        │         │        │          └─ instância Oracle que atendeu
    │          │        │         │        └─ linhas retornadas / afetadas
    │          │        │         └─ qual SQL do ciclo foi executado (1, 2 ou 3)
    │          │        └─ número da iteração acumulada desde o início
    │          └─ service usado na conexão
    └─ horário local da execução
```

---

## Comportamento durante failover

Quando uma instância cai (shutdown abort, poweroff, interconnect down):

- O script detecta o erro na próxima execução de SQL
- Imprime a linha `ERRO: ... - reconectando...`
- Aguarda 3 segundos e tenta reconectar via SCAN
- O SCAN redireciona para a instância sobrevivente
- A carga continua automaticamente — sem intervenção manual

Se o service estiver configurado com **TAF SELECT** (`srvctl modify service -db CORP -s SRV_ZBX -failovertype SELECT`), queries SELECT em andamento são retomadas transparentemente pelo Oracle, sem que o script sequer perceba a falha.

---

## carga_monitora.sh — Alert Logs em Tempo Real

Exibe as últimas 25 linhas dos alert logs do **CRS** e de cada **instância de banco**,
atualizando a cada 3 segundos com `clear`. Ideal para observar eventos durante os
cenários de falha (interconnect down, shutdown abort, poweroff).

### Onde salvar

```
/home/oracle/scripts_carga/carga_monitora.sh
```

### Como executar

Abrir um terminal dedicado (não misturar com a carga):

```bash
bash /home/oracle/scripts_carga/carga_monitora.sh
```

### O que monitorar

| Log                                                          | O que aparece                                    |
|--------------------------------------------------------------|--------------------------------------------------|
| `/u01/app/grid/diag/crs/lnxrac0*/crs/trace/alert.log`       | Eventos do Clusterware: eviction, VIP failover, CSS heartbeat |
| `/u02/app/oracle/diag/rdbms/corp/CORP*/trace/alert_CORP*.log`| Eventos do banco: crash recovery, ORA-29740, instance startup |

### Saída esperada durante falha

```
=== ALERT LOGS - 2026-05-18 10:22:05 ===
--- alert.log ---
... CSS: Node lnxrac02 is not responding ...
... Evicting node 2 from the cluster ...
--- alert_CORP1.log ---
... ORA-29740: evicted by member 2 ...
... Instance Recovery started ...
```

---

## Referências

- Runbook principal: `RAC-26ai_RUNBOOK.sql` — ETAPA 29.1
- Repositório: https://github.com/dbasobrinho/scripts_aulas
- Curso: https://dbasobrinho.com.br
