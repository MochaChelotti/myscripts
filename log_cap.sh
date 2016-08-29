#!/bin/sh

while : ; do
   DATE=`date +%Y%m%d_%H%M`
   server_log server_2 -a -s | gzip -c > /home/nasadmin/ts2/s2_${DATE}.log.gz
   sleep 60
done
