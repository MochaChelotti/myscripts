#!/bin/bash
#
# Look up the disposition of a front-end file, and determine
# if a partial file map is present.
#
# If the map is present and can be deleted, then give the option to the user.
#
Investigate() {
  export PGPASSWORD=sysdba
  f="$1"
  IFS=$'\n'
  if [ ! -d "/isys/tmp/pg/" ]; then
    mkdir "/isys/tmp/pg/"
  fi
  
  if [ -z "$1" ]; then
    echo "Syntax: investigatePartialMaps.sh [fileToCheck]"
    echo ""
    echo "Where [fileToCheck] is the file with data still left to process."
    return 1
  fi
  
  echo $f
  if [ ! -e "$f" ]; then
    echo "ERROR: File $f does not exist."
    return 1
  fi

  portfid="`getUniqueID "$f" | grep UniqueId | awk '{print $2}'`"
  if [ -z "$portfid" ]; then
    echo "ERROR: Unable to retrieve portfid from file system."
    return 1
  fi
  
  if [ -e "/home1/work/pfJournals/$portfid" ]; then
    echo "Partial file map: /home1/work/pfJournals/$portfid"
  else
    echo "ERROR: Partial file map /home1/work/pfJournals/$portfid does not exist."
    return 1
  fi
  
  gfout=`getfattr -e hex -d "$f" 2> /dev/null | grep "user.disp" | cut -d '=' -f 2`
  if [ -z "$gfout" ]; then
    echo "ERROR: File $f does not have a disposition set."
    return 1
  fi
  
  if [ "$gfout" != "0x01000000" -a "$gfout" != "0x02000000" ]; then
    echo "ERROR: Disposition of file $f is $gfout.  Escalation required."
    return 1
  fi
  
  echo "Disposition: $gfout"
  echo "XFS Bmap Chunk Count: `xfs_bmap "$f" | wc -l`"
  
  echo "Reading partial file journal /home1/work/pfJournals/$portfid..."
  pfreader "$portfid"
  read -p "Move /home1/work/pfJournals/$portfid? " response
  case "${response}" in 
    [yY]|[yY][eE][sS])
      mv /home1/work/pfJournals/$portfid /isys/tmp/pg/
      ;;
    *)
      echo "Skipping file /home1/work/pfJournals/$portfid."
      ;;
  esac
  echo ""
}

Investigate "$1"

