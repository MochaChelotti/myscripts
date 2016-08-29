#! /bin/sh
# S.M 3/7/2012
# This script takes a sharename as input and sets its already queued replication requests to higher priority 
# than the rest of the replication requests in the dmsmeta data base
# 

Sname="`echo $0| awk -F'/' '{print $NF}'`"
Version="2.1"
# Version 2.1 fixes an issue wehere the IPs of different servers got concatinated.
#PRIORITY='0000000000:000000'
PRIORITY='1111111111:111111'

# This feature was introduced in 4.1.4 code so let us make sure we are on this code
ExagGridVersion="`grep productId /isys/upgrade/Status.xml | awk -F'productId' '{print $2}' | awk -F'"' '{print $2}' | awk -F'.' '{print $1$2$3}'`"
if [ "$ExagGridVersion" -ge 414 ]
then
	continue
else
	echo "You must be running version 4.1.4 or higher for this functionality to work."
	exit 1
fi
export LD_LIBRARY_PATH=:/isys/lib
export PGPASSWORD="sysdba"

clear
echo
echo "$Sname: Versions $Version"

trap '
        echo "exiting due to INT signal."
	exit
'  INT


IAM="`grep dsmState /isys/conf/isys.xml | awk -F'value' '{print $2}' | awk -F'"' '{print $2}'`"

if [ "$IAM" != "MasterState" ]
then
	echo "Please run $Sname on the master server."
	exit
fi

echo -e "\n\nFound the following replicated shares"
echo
echo "       FileCollectionID                 Share Name"
echo "------------------------------------    ----------"
psql -U sysdba -d assets -c "select
                                fc.label as file_collection_name,
                                fc.name as file_collection_uuid,
                                fc.deletestate,
                                count(repo.name)
                                from
                                filecollection fc, policy p, replicationtarget rt, repository repo
                                where
                                fc.policy = p.id and
                                rt.policy = p.id and
                                rt.repository = repo.id and
                                fc.deletestate = 'NoAction'
                                group by fc.name, fc.label, fc.deletestate having count(repo.name) <> 1;
                                "  | grep '-' | grep -v '+' | awk '{printf("%-40s%s\n",$3,$1)}' | tee /tmp/tmpfcid
echo "------------------------------------    ----------"
echo;echo

if [ ! -s /tmp/tmpfcid ]
then
	echo "No replicated shares found."
	echo
	exit
fi
while true
do
	echo -e "Enter a FileCollectionID or a sharename from above list: \c"
	read FCID
	grep -w $FCID /tmp/tmpfcid > /dev/null
	if [ "$?" -ne 0 ]
	then	
        	echo "Input error."
	else
		FCID="`grep -w $FCID /tmp/tmpfcid | awk '{print $1}'`"
		ShareName="`grep -w $FCID /tmp/tmpfcid | awk '{print $2}'`"
		break
	fi
done


# Get a list of server in this site to send the sql query to

GridNet="`nicinfo | grep NIC1| awk '{print $7}' | awk -F'.' '{print $1"."$2"."$3}'`"
MyIp="`nicinfo | grep NIC1| awk '{print $7}'`"
AllServersInThisSite="`psql  -A -t -U sysdba assets -c "select exagridipaddress from gridresource; " | grep -w $GridNet`"

if [ -z "$AllServersInThisSite" ]
then
	#this is the only server
	echo "Unable to get Srver list from this site."
	exit 1
fi

for server in $AllServersInThisSite
do
	echo
	ServerName="`psql  -A -t -U sysdba assets -c "select label from gridresource where exagridipaddress='$server';"`" 
	echo "Setting replication priority for $ShareName on server $ServerName"
	ssh -o StrictHostKeyChecking=no $server "export PGPASSWORD="sysdba"; psql -U sysdba -d dmsmeta -p 5433 -c \"update replicationrequest_ set oldestqueuedtx_='$PRIORITY' where transactionstream_='$FCID';\""
done
