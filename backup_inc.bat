@Echo off
REM Parse the date into a YYYYMMDD environment variable
SET datvar=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
SET timvar=%TIME:~0,2%%TIME:~3,2%

@echo Starting %datvar%_%timvar% backup job >>c:\FLbackup.log
@echo Backing up files to archive - incremental backup
@echo Backing up files to archive - incremental backup >>c:\FLbackup.log
REM Backup the files using the variable to insert date in name of backup archive.
start "" /low /B /wait "C:\Program Files\7-Zip\7z.exe" u e:\Backup\PlayerFiles_%datvar%.7z -u- -up0q3x2z0!E:\Backup\PlayerFiles_Inc_%datvar%_%timvar%.7z -ssw -r "C:\Accts\Multiplayer*"

copy E:\Backup\PlayerFiles_inc_%datvar%_%timvar%.7z C:\Backup\


REM Clear out the variable.
SET datvar=
set timvar=
@Echo Backup finished >>C:\FLbackup.log
@Echo Backup finished