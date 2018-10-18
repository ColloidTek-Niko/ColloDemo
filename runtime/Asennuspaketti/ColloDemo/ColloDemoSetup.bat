@echo off

SET currentPath=%~dp0
SET destinationPath=%USERPROFILE%\Roaming\Collo\ColloDemo\

mkdir %destinationPath%data
copy /Y %currentPath%data %destinationPath%data


ECHO .