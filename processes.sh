#!/bin/bash
# filename: SCRIPT1.sh
 
# if running dont start
# list all pids running with our program name, take out our pid, if one still in list, then others running (exit status 0). exit if others running.
if ps ax | egrep -v "grep|watch" | grep "SCRIPT1" | awk '{print $1}' | grep -v $$ | grep -q .; then
    echo "$0 STILL RUNNING - CLOSING";
    exit 1
fi
 
### rest of the script ###
