@Echo off
REM Parse the date into a YYYYMMDD environment variable
SET datvar=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
@echo Starting %datvar% backup job >>c:\FLbackup.log

@Echo Setting up FLhook and tools backups
@Echo Setting up FLhook and tools backups >>c:\FLBackup.log
REM Copy FLHook dlls and ini, and backup/restart scripts to a folder in the flhook_plugins dir to include it in the backup.
mkdir "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup"
mkdir "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\scripts"
mkdir "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\restart"
mkdir "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\tools"

copy /Y "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook*.dll" "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup"
copy /Y "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook.ini" "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup"
copy /Y "C:\Program Files\Microsoft Games\Freelancer\EXE\zlib.dll" "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup"
copy /Y "C:\backup*.bat" "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\scripts"
copy /Y "C:\restart.bat" "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\scripts"
copy /Y "C:\Program Files\Microsoft Games\Freelancer\EXE\restart\*.*" "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\restart"
copy /Y "C:\Program Files\Microsoft Games\Freelancer\EXE\tools\*.*" "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\tools

@echo Backing up files to archive
@echo Backing up files to archive >>c:\FLbackup.log
REM Backup the files using the variable to insert date in name of backup archive.
start "" /low /B /wait "C:\Program Files\7-Zip\7z.exe" a E:\Backup\PlayerFiles_%datvar%.7z -ssw -r "C:\Accts\Multiplayer*"
start "" /low /B /wait "C:\Program Files\7-Zip\7z.exe" a E:\Backup\ServerFiles_%datvar%.7z -ssw -r "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins"

@Echo cleaning up after backup
@Echo cleaning up after backup >>c:\FLbackup.log
REM Delete the serverrelated backupfiles from the flhook_plugin dir after it has been included in todays backup
rmdir /S /Q "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\scripts\"
rmdir /S /Q "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\restart\"
rmdir /S /Q "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\tools\"
rmdir /S /Q "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_plugins\flhookbackup\"

@Echo Copying from primary to secondary backup location
@Echo Copying from primary to secondary backup location >>c:\FLbackup.log
REM Copy from backup primary location to secondary location
copy E:\Backup\??????Files_%datvar%.7z C:\Backup\

@echo Copying to remote backup location
@echo Copying to remote backup location >> c:\FLbackup.log

ncftpput -bb -u dsbackup -p <pass> backup.example.com / e:\Backup\ServerFiles_%datvar%.7z
ncftpput -b -u dsbackup -p <pass> backup.example.com / e:\Backup\PlayerFiles_%datvar%.7z

@Echo Renaming chatlog and event log.
@Echo Renaming chatlog and event log >>c:\FLbackup.log
REM rename the chatlog, so a fresh one begins.
Ren "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_logs\chats.log" chats_%datvar%.log
Ren "C:\Program Files\Microsoft Games\Freelancer\EXE\flhook_logs\events.log" events_%datvar%.log

REM Clear out the variable.
SET datvar=

@Echo Backup finished >>C:\FLbackup.log
@Echo Backup finished