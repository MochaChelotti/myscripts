#!/bin/perl 
 use Time::Local;
 open LOG, ">log.txt" or die "Cannot open log.txt $!";
 my $date = localtime;
 my $a=1;

 # CHANGE NUMBER OF TESTS AND TIME BETWEEN THEM BELOW ##################
 my $b=5;  #number of tests to run
 my $c=1;  #seconds to sleep
 #
 print LOG "Iperf started on $date\n";
 print LOG "Number of tests run $b\n\n";

   while ($a <= $b){
       $date = localtime;
       print "Starting test $a of $b on $date\n\n";  

 ##CHANGE SERVER IP AND TCP WINDOW BELOW ##
 my $result = `iperf -c 172.20.240.43 -w 128k`;           #client side to server only 
 ##
       my $num = sprintf "%3d",$a;    
       print "$result\n\n";
       print LOG "Test $num $date\n";
       print LOG "$result\n\n";
       sleep $c;
       $a = ++$a;
 }
 close LOG;
 my $now = time();
 open LOG,  "log.txt" or die "Cannot open log.txt $!";
 open LOGP, ">log_parse$now.txt" or die "cannot open log_parse.txt $!";

 my @raw   = <LOG>;
 my @data  = grep/Mbits|Kbits/,@raw;         # get speed results
 my @time1 = grep/Test/,@raw;          # get test time
 my @ip    = grep/local/,@raw;         # get ip
 my @start = grep/Iperf started/,@raw; # get start time
 my @tpc   = grep/TCP window/,@raw;    # get tcp window size

 for (@data){ s#^.*]\s+(.*)#$1#}
 #for (@data){ s#(^.*)sec\s+(.*)MBytes\s+(.*)Mbits/sec.*#$1 $2 $3#}
 for (@time1){ s#(^.*)2005.*#$1#}
 for (@ip){ s#(^.*local\s+)(.*)(port.*with\s+)(.*)port.*#CLIENT IP $2  SERVER IP $4#}

 chomp @time1;
 chomp @data;
 chomp @ip;                                  
 chomp @start;
 chomp @tpc;

 print "$start[0]\n";
 print "$tpc[0]\n";
 print "$ip[0]\n\n";
        
 print "                               Interval      Transfer     Bandwidth\n";

   for (0 .. $#time1){
       print join(' ',$time1[$_], $data[$_]), $/;
 }

 print LOGP "$start[0]\n";
 print LOGP "$tpc[0]\n";
 print LOGP "$ip[0]\n\n";
 print LOGP "                                Interval      Transfer     Bandwidth\n";

   for (0 .. $#time1){
       print LOGP join(' ',$time1[$_], $data[$_]), $/;
 }

 close LOG;
 close LOGP;
