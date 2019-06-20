@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

net stop "Tenable Nessus"
del "%ALLUSERSPROFILE%\Tenable\Nessus\nessus\ext.db"
del "%ALLUSERSPROFILE%\Tenable\Nessus\nessus\global.db"
del "%ALLUSERSPROFILE%\Tenable\Nessus\nessus\upgrades.db"
net start "Tenable Nessus"
