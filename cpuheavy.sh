#sorts cpu cycles helpful in troubleshooting performance issues 
ps -eo pmem,pcpu,pid,args | tail -n +2 | sort -rnk 1 | head
