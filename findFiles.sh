#!/bin/sh
#
# Finds a specified gridfid on all known ExaGrid servers,
# including local and remote systems, listing the system's
# NIC1 IP address along with the version chain size, if the
# gridfid was found.
#
FindFiles() {
  assetDbQuery() 
  {
    master=`getMasterIp`
    exagrid-psql -p 5435 -h $master -A -t -d assets -c "$1"
  }

  export LD_LIBRARY_PATH=:/isys/lib
  FID=`echo ${1} | cut -b 1-36`
  FIDDIR=/home1`/isys/bin/test/LocateGridFile $FID`
  
  servers=`assetDbQuery "select exagridipaddress from gridresource where adminstatus != 'Decommissioned';" | sort`

  for line in $servers; do
    echo "$line: `ssh -o GSSAPIAuthentication=no -o StrictHostKeyChecking=no $line "find $FIDDIR -name \"$FID*\"" | wc -l`"
  done
}

FindFiles $1
