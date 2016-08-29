@echo off
REM Set your own java options in environment variable JAVA_OPTS
REM For example, to give it a larger heap
REM   export JAVA_OPTS=-Xmx1024m
REM
REM Type the following command to get the help page.
REM   vtop-filter-stats.bat -h

setlocal enabledelayedexpansion
java %JAVA_OPTS% -cp "%~dp0\lib\vtop-core.jar" com.vmware.vtop.cli.StatsFilter %*
