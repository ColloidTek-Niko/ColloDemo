@echo off
set cnt=0
for %%A in (A*) do set /a cnt+=1
echo File count = %cnt%
set /a cnt=%cnt%+1

SET MY_PATH=%~dp0
"%MY_PATH%PLLCLI.EXE" "A %cnt%.mat" 35:55:2000 -a4 -e6 -k -r5

ECHO .