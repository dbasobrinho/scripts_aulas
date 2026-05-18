#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use POSIX qw(strftime);
$| = 1;

my $dsn  = "dbi:Oracle:host=rac-scan;port=1521;service_name=SRV_CO";
my $user = "co";
my $pass = "oracle";
my $iter = 0;
my $dbh;

sub conectar {
    $dbh = DBI->connect($dsn, $user, $pass,
        { RaiseError => 0, AutoCommit => 0, PrintError => 0 });
    return $dbh;
}

conectar() or die "Conexao inicial falhou: $DBI::errstr\n";

## SQL1 - join orders + order_items + customers (full scan, sort, hash join)
## SQL2 - UPDATE order_items + ROLLBACK (undo, redo, row lock — sem dependencia de sequence)
## SQL3 - agregacao por produto com window function (CPU, sorts)
my @sqls = (
    q{SELECT /*+ FULL(o) FULL(oi) FULL(c) */
             o.order_id, o.order_tms, o.order_status,
             c.full_name,
             COUNT(oi.line_item_id)                       qtd_itens,
             ROUND(SUM(oi.unit_price*oi.quantity),2)       total_itens,
             RANK() OVER (ORDER BY SUM(oi.unit_price*oi.quantity) DESC) rnk
      FROM orders o
      JOIN order_items oi ON o.order_id    = oi.order_id
      JOIN customers   c  ON o.customer_id = c.customer_id
      GROUP BY o.order_id, o.order_tms, o.order_status, c.full_name
      ORDER BY total_itens DESC},

    q{UPDATE /*+ FULL(oi) */ order_items
      SET unit_price = unit_price * (1 + DBMS_RANDOM.VALUE(-0.03, 0.03))
      WHERE order_id IN (SELECT order_id FROM orders WHERE ROWNUM <= 10)},

    q{SELECT /*+ FULL(oi) FULL(p) */
             p.product_name,
             COUNT(oi.order_id)                       pedidos,
             ROUND(SUM(oi.unit_price * oi.quantity),2) receita,
             ROUND(AVG(oi.unit_price * oi.quantity),2) ticket_medio,
             ROUND(SUM(SUM(oi.unit_price * oi.quantity))
                   OVER () , 2)                        total_geral
      FROM order_items oi
      JOIN products p ON oi.product_id = p.product_id
      GROUP BY p.product_name
      ORDER BY receita DESC},
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
            printf "[%s] SRV_CO | iter=%d | sql=%d | rows=%s | inst=%s\n",
                $ts, $iter, $idx+1, $rows // 0, $inst;
        };
        if ($@) {
            printf "[%s] SRV_CO | ERRO: %s - reconectando...\n", $ts, $@;
            eval { $dbh->rollback() };
            sleep 3;
            conectar();
            last;
        }
    }
    sleep 2;
}
