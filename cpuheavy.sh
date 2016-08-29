#Looks for top processes consuming CPU cycles and sorts by top 10 useful for CPU 0% idle
ps -eo pmem,pcpu,pid,args | tail -n +2 | sort -rnk 1 | head
