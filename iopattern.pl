#!/usr/bin/perl
#

use warnings;
use strict;

#
#MAIN main
#

if ( scalar @ARGV != 4 )
{
  print "Error - scriptIO fileSize randomSeed script1 script2\n";
  exit 1;
}
my $fileSize = $ARGV[0];
my $seed = $ARGV[1];
my $script1 = $ARGV[2];
my $script2 = $ARGV[3];
if ($fileSize < 100000000)
{
  print "Sorry, fileSize must be >= 100000000\n";
  exit 1;
}

my $offset = 0;
my $length = 0;
my %sections = ();


#
# create script1 file that'll write the whole file in a single swoop
#
open (FILE, ">", $script1) or die;
print FILE "create\n";
print FILE "WRITE,0,$fileSize\n";
print FILE "close\n";
print FILE "SAVESTATE,startStep2.state\n";
close FILE;

#
# create script2 file that'll do the random IO pattern
# this script needs to load the state from the 1st script and re-open the file
#
open (FILE, ">",$script2) or die;
print FILE "LOADSTATE,startStep2.state\n";
print FILE "open\n";

srand($seed);
while ($offset < $fileSize - (5 * 1048576))
{
  $length = 16*int((1048576 + rand(4 * 1048576))/16);
  $sections{$offset} = $length;
  $offset += $length;
}
$sections{$offset} = $fileSize - $offset;
#foreach $offset ( sort { $a <=> $b } (keys %sections) )
my $counter = 0;
foreach $offset (keys %sections)
{
  last if ++$counter > 2000;
  $length = $sections{$offset};
  print FILE "READ,$offset,1024\n";
  for(my $x = 0; $x < 40; $x++)
  {
    my $cmd = ( rand(2) > 1 ) ? "READ" : "WRITE";
    my $cmdOffset = 16 * int(rand($length)/16) + $offset;
    my $cmdLength = 16*int((1024 + rand($length-1024))/16);
    print FILE "$cmd,$cmdOffset,$cmdLength\n";
  }
}
print FILE "close\n";
close FILE;
