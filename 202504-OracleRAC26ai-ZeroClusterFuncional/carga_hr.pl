#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use POSIX qw(strftime);
$| = 1;

my $dsn  = "dbi:Oracle:host=rac-scan;port=1521;service_name=SRV_HR";
my $user = "hr";
my $pass = "oracle";
my $iter = 0;
my $dbh;

sub conectar {
    $dbh = DBI->connect($dsn, $user, $pass,
        { RaiseError => 0, AutoCommit => 0, PrintError => 0 });
    return $dbh;
}

conectar() or die "Conexao inicial falhou: $DBI::errstr\n";

## Rotacao de SQLs para gerar diferentes eventos de espera:
## SQL1 - full scan + window functions (db file scattered read, sorts)
## SQL2 - CONNECT BY gerando 1000 linhas sinteticas (CPU, temp)
## SQL3 - UPDATE em lote + ROLLBACK (undo, redo, row lock, log file sync)
my @sqls = (
    q{SELECT /*+ FULL(e) FULL(d) FULL(jh) */
             e.employee_id, e.last_name, e.salary,
             d.department_name,
             ROUND(AVG(e.salary)  OVER (PARTITION BY e.department_id), 2) avg_dep,
             ROUND(MAX(e.salary)  OVER (PARTITION BY e.department_id), 2) max_dep,
             RANK() OVER (ORDER BY e.salary DESC) rnk_geral
      FROM employees e
      JOIN departments d  ON e.department_id = d.department_id
      LEFT JOIN job_history jh ON e.employee_id = jh.employee_id
      ORDER BY e.salary DESC},

    q{SELECT LEVEL lvl,
             'EMP'||LPAD(LEVEL,4,'0')           nome,
             ROUND(DBMS_RANDOM.VALUE(2000,15000),2) sal,
             MOD(LEVEL,10)+1                    dept,
             ROUND(DBMS_RANDOM.VALUE(1,5),0)    nota
      FROM DUAL
      CONNECT BY LEVEL <= 1000
      ORDER BY sal DESC},

    q{UPDATE /*+ FULL(e) */ employees
      SET salary = salary * (1 + DBMS_RANDOM.VALUE(-0.05, 0.05))
      WHERE department_id IN
            (SELECT department_id FROM departments
             WHERE ROWNUM <= 5)},
);

while (1) {
    my $burst_end = time() + 30;
    while (time() < $burst_end) {
        $iter++;
        my $ts  = strftime('%H:%M:%S', localtime);
        my $idx = ($iter - 1) % scalar(@sqls);
        eval {
            my $rows;
            if ($sqls[$idx] =~ /^UPDATE/) {
                $rows = $dbh->do($sqls[$idx]);
                $dbh->rollback();
            } else {
                my $sth = $dbh->prepare($sqls[$idx]);
                $sth->execute();
                $rows = scalar(@{ $sth->fetchall_arrayref() });
                $sth->finish();
            }
            my ($inst) = $dbh->selectrow_array(
                "SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM DUAL");
            printf "[%s] SRV_HR | iter=%d | sql=%d | rows=%s | inst=%s\n",
                $ts, $iter, $idx+1, $rows // 0, $inst;
        };
        if ($@) {
            printf "[%s] SRV_HR | ERRO: %s - reconectando...\n", $ts, $@;
            eval { $dbh->rollback() };
            sleep 3;
            conectar();
            last;
        }
    }
    sleep 2;
}
