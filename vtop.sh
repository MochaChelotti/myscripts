#!/bin/sh
#Set your own java options in environment variable JAVA_OPTS
#For example, to give it a larger heap
#   export JAVA_OPTS=-Xmx1024m
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

java $JAVA_OPTS -cp "$SCRIPTPATH/lib/vtop-ui.jar" com.vmware.vtop.VTopMain $@
