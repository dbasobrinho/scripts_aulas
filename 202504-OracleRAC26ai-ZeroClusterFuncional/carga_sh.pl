#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use POSIX qw(strftime);
$| = 1;

my $dsn  = "dbi:Oracle:host=rac-scan;port=1521;service_name=SRV_SH";
my $user = "sh";
my $pass = "oracle";
my $iter = 0;
my $dbh;

sub conectar {
    $dbh = DBI->connect($dsn, $user, $pass,
        { RaiseError => 0, AutoCommit => 0, PrintError => 0 });
    return $dbh;
}

conectar() or die "Conexao inicial falhou: $DBI::errstr\n";

## SQL1 - agregacao total de vendas por canal e ano (full scan, hash agg, sort)
## SQL2 - CONNECT BY 2000 linhas com calculo de ranking (CPU, temp)
## SQL3 - join sales x times x customers x products (multi-table full scan)
my @sqls = (
    q{SELECT /*+ FULL(s) FULL(ch) FULL(t) */
             ch.channel_desc,
             t.calendar_year,
             COUNT(s.prod_id)                          qtd,
             ROUND(SUM(s.amount_sold),2)                receita,
             ROUND(AVG(s.amount_sold),2)                ticket,
             ROUND(SUM(SUM(s.amount_sold)) OVER
                   (PARTITION BY t.calendar_year), 2)  total_ano
      FROM sales s
      JOIN channels ch ON s.channel_id  = ch.channel_id
      JOIN times    t  ON s.time_id     = t.time_id
      GROUP BY ch.channel_desc, t.calendar_year
      ORDER BY t.calendar_year, receita DESC},

    q{SELECT LEVEL                                   seq,
             ROUND(DBMS_RANDOM.VALUE(100,99999), 2)  valor,
             ROUND(DBMS_RANDOM.VALUE(1,12))          mes,
             ROUND(DBMS_RANDOM.VALUE(2000,2026))     ano,
             MOD(LEVEL,5)+1                          canal,
             RANK() OVER
               (ORDER BY DBMS_RANDOM.VALUE(100,99999) DESC) rnk
      FROM DUAL
      CONNECT BY LEVEL <= 2000
      ORDER BY rnk},

    q{SELECT /*+ FULL(s) FULL(p) FULL(c) FULL(t) */
             p.prod_category,
             c.country_id,
             t.calendar_quarter_desc,
             COUNT(DISTINCT s.cust_id)               clientes,
             ROUND(SUM(s.amount_sold),2)              receita,
             ROUND(AVG(s.quantity_sold),2)            qtd_media
      FROM sales     s
      JOIN products  p ON s.prod_id    = p.prod_id
      JOIN customers c ON s.cust_id    = c.cust_id
      JOIN times     t ON s.time_id    = t.time_id
      GROUP BY p.prod_category, c.country_id, t.calendar_quarter_desc
      ORDER BY receita DESC},
);

while (1) {
    my $burst_end = time() + 30;
    while (time() < $burst_end) {
        $iter++;
        my $ts  = strftime('%H:%M:%S', localtime);
        my $idx = ($iter - 1) % scalar(@sqls);
        eval {
            my $sth = $dbh->prepare($sqls[$idx]);
            $sth->execute();
            my $rows = scalar(@{ $sth->fetchall_arrayref() });
            $sth->finish();
            my ($inst) = $dbh->selectrow_array(
                "SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM DUAL");
            printf "[%s] SRV_SH | iter=%d | sql=%d | rows=%d | inst=%s\n",
                $ts, $iter, $idx+1, $rows, $inst;
        };
        if ($@) {
            printf "[%s] SRV_SH | ERRO: %s - reconectando...\n", $ts, $@;
            eval { $dbh->rollback() };
            sleep 3;
            conectar();
            last;
        }
    }
    sleep 2;
}
