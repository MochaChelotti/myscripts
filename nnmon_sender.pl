#!/usr/bin/perl
# Version 2
use IO::Socket;

$SIG{INT} = $SIG{TERM} = $SIG{__DIE__} = $SIG{QUIT} = $SIG{ABORT} = \&signal_handler;
sub signal_handler {
  exit 2;
}

$host = "172.22.4.40";
$port = "20005";

# nmon -s 30 -c 2879 -T -F gbwast.`date '+%Y%d%m_%H%M%S'`.nmon
$second = 30;
$count = 2878; # 30 * 2878 = 1 day - 1 minute
$dir = '/tmp';
$output_dir = 'nnmon';
$file_path = "$dir/$output_dir/" . `hostname|tr -d '\n'` . "." . `date '+%Y%m%d_%H%M%S'|tr -d '\n'` . ".nmon";

chdir($dir);

if ( ! -e nnmon )
{
  mkdir $output_dir;
}

$os = `uname -s`;
chomp($os);
if ( $os eq "AIX" )
{
  $instanceCount = 1;
  $command = "topas_nmon";
  $extraargs = "-O -d"
}
else
{
  $instanceCount = 2;
  $command = "nmon";
}

$args = " -s $second -c $count -T $extraargs -F $file_path";

$howmany = `ps -ef|grep nnmon_sender.pl|grep -v grep 2>/dev/null|wc -l`;
if ( $howmany > $instanceCount )
{
  #print "Only one instance allowed. Kill previously created instance first.\n";
  exit 1;
}

system "find $output_dir -name '*.nmon' -mtime +14 -exec rm {} \\;";
system "find $output_dir -name '*.nmon' -size -1000 -exec rm {} \\;";

$remote = IO::Socket::INET->new( Proto     => "tcp",
                                 PeerAddr  => $host,
                                 PeerPort  => $port,);
if ( ! $remote )
{
  print "Cannot connect remote nnmon server. Check host and port parameters.\n";
  exit 1;
}
$remote->autoflush(1);

open(NMON, $command . $args ." 2>/dev/null & |") or  die "Cannot run nmon.\n";
print $command . $args ." 2>/dev/null\n";
sleep 15;

open(NMONFILE, $file_path) or die "Cannot open nmon file.\n";

local $SIG{ALRM} = sub { print "Time Out.\n"; exit 4; };
local $SIG{PIPE} = sub { print "Remote host closed the connection.\n"; exit 5; };
alarm $second * 4;
while(1)
{
  $line = <NMONFILE>;
  if ( $line eq "" )
  {
    sleep 1;
    next;
  }
  alarm $second * 4;
  print $remote $line;
}
close($remote);

END {
  $_ = `ps -ef|grep $command|grep -v grep|grep "$args" 2>/dev/null`;
  ($kul, $pid) = /(\w+) +(\d+)/;
  print STDERR "Closing nmon process... $pid\n";
  if ( $pid > 1 )
  {
    system "kill -9 $pid";
  }
}
