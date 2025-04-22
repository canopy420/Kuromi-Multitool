@echo off
title Kuromi Multitool 
color 0D
chcp 65001 >nul

:: check if the script has admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please execute the script with admin.
    pause
    exit /b
)


:ASK_RESTORE
echo Do you want to create a system restore point? (recommended)
set /p restore=Type YES or NO: 
if /i "%restore%"=="yes" (
    echo [INFO] Creating restore point...
    powershell -Command "Checkpoint-Computer -Description 'Kuromi Restore Point' -RestorePointType 'MODIFY_SETTINGS'" 
    echo [INFO] Done! , The restore point was saved with the name "Kuromi Restore Point", a restart from the script is now necessary, you can skip this part next time.
    pause
    exit
) else (
    if /i "%restore%"=="no" (
        echo [INFO] Skipping restore point creation.
        timeout /t 3 >nul
        goto MENU
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 >nul
	cls
        goto ASK_RESTORE
    )
)

:MENU
cls
echo.
echo  ▀██ ▄█▀ █    ██  ██▀███   ▒█████    ███▄ ▄███▓  ██
echo   ██▄█▒  ██  ▓██▒▓██ ▒ ██▒▒██▒  ██▒ ▓██▒▀█▀ ██▒▒▓██
echo  ▓███▄░ ▓██  ▒██░▓██ ░▄█ ▒▒██░  ██▒ ▓██    ▓██░░▒██
echo  ▓██ █▄ ▓▓█  ░██░▒██▀▀█▄  ▒██   ██░ ▒██    ▒██  ░██
echo  ▒██▒ █▄▒▒█████▓ ░██▓ ▒██▒░ ████▓▒░▒▒██▒   ░██▒ ░██
echo  ▒ ▒▒ ▓▒ ▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░░ ▒░   ░  ░ ░▓ 
echo  ░ ░▒ ▒░ ░▒░ ░ ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░░  ░      ░  ▒ 
echo  ░ ░░ ░   ░░ ░ ░    ░   ░ ░ ░ ░ ▒   ░      ░     ▒ 
echo  ░  ░      ░        ░         ░ ░  ░       ░     ░  
echo.

for /F "tokens=1 delims=:" %%H in ("%time%") do set HORA=%%H

if "%HORA:~0,1%"=="0" set HORA=%HORA:~1,1%

set /a HORA_INT=%HORA%

if %HORA_INT% LSS 12 (
    echo Good morning, %USERNAME%, welcome to Kuromi.
) else (
    if %HORA_INT% LSS 18 (
        echo Good evening, %USERNAME%, welcome to Kuromi.
    ) else (
        echo Good night, %USERNAME%, welcome to Kuromi.
    )
)

echo.
echo canopy420.github.io
echo.
echo Last update: 22/4/2025
echo Version: Alpha 1.0
echo.
echo [1] System Optimization
echo [2] System Managment
echo [3] Program Installer Downloader
echo [4] Misc things
echo [0] Exit
echo.
set /p option=Select an option (0-4): 

if "%option%"=="1" goto OPTIMIZATION
if "%option%"=="2" goto SYSTEM
if "%option%"=="3" goto PROGRAMS
if "%option%"=="4" goto MISC
if "%option%"=="0" exit
else 
goto MENU


:OPTIMIZATION
cls
echo.
echo  ▀██ ▄█▀ █    ██  ██▀███   ▒█████    ███▄ ▄███▓  ██
echo   ██▄█▒  ██  ▓██▒▓██ ▒ ██▒▒██▒  ██▒ ▓██▒▀█▀ ██▒▒▓██
echo  ▓███▄░ ▓██  ▒██░▓██ ░▄█ ▒▒██░  ██▒ ▓██    ▓██░░▒██
echo  ▓██ █▄ ▓▓█  ░██░▒██▀▀█▄  ▒██   ██░ ▒██    ▒██  ░██
echo  ▒██▒ █▄▒▒█████▓ ░██▓ ▒██▒░ ████▓▒░▒▒██▒   ░██▒ ░██
echo  ▒ ▒▒ ▓▒ ▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░░ ▒░   ░  ░ ░▓ 
echo  ░ ░▒ ▒░ ░▒░ ░ ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░░  ░      ░  ▒ 
echo  ░ ░░ ░   ░░ ░ ░    ░   ░ ░ ░ ░ ▒   ░      ░     ▒ 
echo  ░  ░      ░        ░         ░ ░  ░       ░     ░  
echo.
echo System Optimization
echo.
echo [1] Clean temporal files and logs
echo [2] Disable Windows Telemetry
echo [3] Remove Windows bloatware
echo [4] Deactivate Unnecessary Services
echo [0] Go to main menu
echo.
set /p option=Select an option (0-4): 

if "%option%"=="1" goto CLEAN_FILES
if "%option%"=="2" goto TELEMETRY
if "%option%"=="3" goto BLOATWARE
if "%option%"=="4" goto SERVICES
if "%option%"=="0" goto MENU
else
goto OPTIMIZATION


:CLEAN_FILES
echo [INFO] Cleaning temp files and Recycle Bin...
del /s /q %temp%\*
del /s /q C:\Windows\Prefetch\*
del /s /q C:\Windows\Temp\*
del /f /q %APPDATA%\Microsoft\Windows\Recent\*
rd /s /q C:\$Recycle.Bin
echo.
echo [INFO] Running Disk Cleanup for Windows Update and system junk...

net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
rd /s /q %windir%\SoftwareDistribution\Download
rd /s /q %windir%\SoftwareDistribution\DataStore
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo.
echo [INFO] Windows Update cache cleaned.
timeout /t 5 /nobreak >nul
echo.
cls
:ASK_COM
color 0C
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo [WARNING] THE SCRIPT IS ABOUT TO PERFORM A COMPONENT CLEANUP.
echo [WARNING] THIS IS A VERY AGRESIVE STEP, PLEASE READ THE README BEFORE CONTINUING.
set /p comask=DO YOU WANT TO CONTINUE?- YES OR NO: 
if /i "%comask%"=="no" (
    color 0D
    echo [INFO] Cleaning Completed.
    goto OPTIMIZATION
) else (
    if /i "%comask%"=="yes" (
	color 0D
	echo [INFO] Running component cleanup... This may take a while, its normal if the % gets stuck at some point
	timeout /t 5 /nobreak >nul
	start "" "%~dp0resources\caffeine\caffeine.exe"
	Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase
	taskkill /f /im caffeine.exe >nul 2>&1
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 >nul
	cls
        goto ASK_COM
    )
)



:TELEMETRY
echo [INFO] Disabling Windows Telemetry...
timeout /t 3 /nobreak >nul

sc stop DiagTrack
sc config DiagTrack start= disabled

sc stop dmwappushservice
sc config dmwappushservice start= disabled

sc stop diagnosticshub.standardcollector.service
sc config diagnosticshub.standardcollector.service start= disabled

echo.
echo [INFO] Deleting Telemtry tasks...
timeout /t 3 /nobreak >nul

schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable

echo.
echo [INFO] Changing regedit settings...
timeout /t 3 /nobreak >nul

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
echo.
echo [INFO] Telemetry deactivated.
pause
goto OPTIMIZATION


:BLOATWARE
cls
:ASK
color 0C
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo [WARNING] THIS WILL DELETE APPS YOU MAY FIND USEFUL, PLEASE CHECK THE README TO SEE THE APPS.
set /p siono=DO YOU WANT TO CONTINUE?- YES OR NO: 
if /i "%siono%"=="no" (
    color 0D
    goto OPTIMIZATION
) else (
    if /i "%siono%"=="yes" (
        goto CONTINUE_APPS
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 >nul
	cls
        goto ASK
    )
)
:CONTINUE_APPS
    color 0D
    echo.
    echo [INFO] Removing Windows bloatware.... (this may take a while)
    timeout /t 3 /nobreak >nul
    echo.

    set apps="Microsoft.WindowsCalculator" "Microsoft.WindowsCamera" "Microsoft.Windows.Photos" "microsoft.windowscommunicationsapps" "Microsoft.ZuneMusic" "Microsoft.ZuneVideo" "Microsoft.Office.OneNote" "Microsoft.WindowsAlarms" "Microsoft.WindowsMaps" "Microsoft.XboxApp" "Microsoft.MSPaint" "Microsoft.BingNews" "Microsoft.BingWeather" "Microsoft.SkypeApp" "Microsoft.OneDriveSync" "Microsoft.XboxGamingOverlay" "Microsoft.Xbox.TCUI" "Microsoft.XboxIdentityProvider" "Microsoft.549981C3F5F10" "Microsoft.MicrosoftSolitaireCollection" "Microsoft.Todos" "Microsoft.3DViewer" "Microsoft.MixedReality.Portal" "Microsoft.Getstarted" "Microsoft.Clipchamp" "Microsoft.YourPhone" "Microsoft.WindowsFeedbackHub"

    for %%a in (%apps%) do (
        echo Removing: %%a
        powershell -Command "Get-AppxPackage -Name %%a | Remove-AppxPackage -ErrorAction SilentlyContinue; exit"
    )

echo.
echo [INFO] Apps removed succesfully
echo [INFO] please note that some apps can reappear when you update Windows.
echo [INFO] A restart from the script is neccesary before continuing.
pause> nul
exit

:SERVICES
cls
:ASK_SER
color 0C
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo [WARNING] PLEASE, READ THE README BEFORE CONTINUING YOU MAY FIND SOME OF THESE SERVICES USEFULL! 
set /p askser=DO YOU WANT TO CONTINUE?- YES OR NO: 
if /i "%askser%"=="no" (
    color 0D
    goto OPTIMIZATION
) else (
    if /i "%askser%"=="yes" (
	color 0D
        goto CONTINUE_SER
    ) else (
	cls
        echo Invalid input.
        timeout /t 3 >nul
	cls
        goto ASK_SER
    )
)

:CONTINUE_SER
set SERVICES=WerSvc RemoteAccess TermService UmRdpService RemoteDesktop TabletInputService WbioSrvc DPS FDPHost FDResPub WMPNetworkSvc XboxGipSvc XblAuthIdMgrSvc XblGameSaveSvc XboxNetApiSvc SysMain BthHFSrv BthAvrcpSvc BthLEEnum
for %%S in (%SERVICES%) do (
    echo Deactivating %%S...
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)

:: Printer thing
echo.
:ASK_PRINT
echo [INFO] Do you want to turn off printer services?
set /p PRINTCHOICE=Type YES or No: 
if /i "%PRINTCHOICE%"=="no" (
	echo [INFO] Unnecessary services deactivated
	pause
	goto OPTIMIZATION
) else (
    if /i "%PRINTCHOICE%"=="yes" (
	sc stop Spooler >nul 2>&1
	sc config Spooler start= disabled >nul 2>&1
    	sc stop IPPPrint >nul 2>&1
   	sc config IPPPrint start= disabled >nul 2>&1
	echo.
	echo. [INFO] Printer services deactivated
	pause
	goto OPTIMIZATION
    ) else (
	cls
        echo Invalid input.
        timeout /t 3 >nul
	cls
        goto ASK_PRINT
    )
)



:SYSTEM
cls
echo.
echo  ▀██ ▄█▀ █    ██  ██▀███   ▒█████    ███▄ ▄███▓  ██
echo   ██▄█▒  ██  ▓██▒▓██ ▒ ██▒▒██▒  ██▒ ▓██▒▀█▀ ██▒▒▓██
echo  ▓███▄░ ▓██  ▒██░▓██ ░▄█ ▒▒██░  ██▒ ▓██    ▓██░░▒██
echo  ▓██ █▄ ▓▓█  ░██░▒██▀▀█▄  ▒██   ██░ ▒██    ▒██  ░██
echo  ▒██▒ █▄▒▒█████▓ ░██▓ ▒██▒░ ████▓▒░▒▒██▒   ░██▒ ░██
echo  ▒ ▒▒ ▓▒ ▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░░ ▒░   ░  ░ ░▓ 
echo  ░ ░▒ ▒░ ░▒░ ░ ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░░  ░      ░  ▒ 
echo  ░ ░░ ░   ░░ ░ ░    ░   ░ ░ ░ ░ ▒   ░      ░     ▒ 
echo  ░  ░      ░        ░         ░ ░  ░       ░     ░  
echo.
echo System Managment
echo.
echo [1] Check network traffic
echo [2] Check all system info
echo [3] Desinfect
echo [4] Fix internet problems
echo [0] Go back to main menu
echo.

set /p monitoreo=Select an option (0-4): 

if "%monitoreo%"=="1" netstat /nbf
if "%monitoreo%"=="2" systeminfo 
if "%monitoreo%"=="3" goto DESINFECT
if "%monitoreo%"=="4" goto INTERNET
if "%monitoreo%"=="0" goto MENU
else
goto SYSTEM

:DESINFECT
cls
:ASK_VIRUS
color 0C
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo [WARNING] THIS WILL START A VIRUS SCAN, THIS MAY TAKE A WHILE.
set /p askvirus=DO YOU WANT TO CONTINUE?- YES OR NO: 
if /i "%askvirus%"=="no" (
    color 0D
    goto SYSTEM
) else (
    if /i "%askvirus%"=="yes" (
        goto CONTINUE_DESINFECT
    ) else (
	cls
        echo Invalid input.
        timeout /t 3 >nul
        goto ASK_VIRUS
	cls
    )
)

:CONTINUE_DESINFECT
echo[INFO] Starting virus scanning....
timeout /t 5 /nobreak >nul
color 0D
set "cleaner_path=%~dp0resources\desinfect\malwarebytes_adwcleaner\adwcleaner.exe"

if exist "%cleaner_path%" (
    start "" "%~dp0resources\caffeine\caffeine.exe"
    echo [INFO] ADW Cleaner found, running scan... DON'T CLOSE ANY WINDOW THAT MAY POP UP
    start /wait "" "%cleaner_path%" /eula /clean /noreboot 
    start /wait "" "%cleaner_path%" /uninstall
    taskkill /f /im caffeine.exe >nul 2>&1
    echo.
    echo [INFO] Scan completed.
	pause
	goto SYSTEM
) else (
    echo [ERROR] FILE NOT FOUND at %cleaner_path%
	pause
	goto SYSTEM
)

:INTERNET

cls
:ASK_INT
color 0C
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo [WARNING] PLEASE CHECK THE README BEFORE RUNNING THIS PART OF THE SCIPT
set /p asknet=DO YOU WANT TO CONTINUE?- YES OR NO: 
if /i "%asknet%"=="no" (
    color 0D
    goto SYSTEM
) else (
    if /i "%asknet%"=="yes" (
        goto CONTINUE_NET
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 /nobreak >nul
	cls
        goto ASK_INT
    )
)



:CONTINUE_NET
color 0D
echo [INFO] CREATING A FOLDER BACKUP
timeout /t 3 /nobreak >nul
set "backup_base=%~dp0NET_BACKUP"
if not exist "%backup_base%" mkdir "%backup_base%"


for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    set "day=%%a"
    set "month=%%b"
    set "year=%%c"
)
for /f "tokens=1-2 delims=:" %%i in ("%time%") do (
    set "hour=%%i"
    set "minute=%%j"
)
set "folder=%backup_base%\%year%-%month%-%day%_%hour%%minute%"

set "folder=%folder: =0%"

mkdir "%folder%"

echo [INFO] Saving IP config...
netsh interface ip show config > "%folder%\config_ip.txt"
timeout /t 3 /nobreak >nul

echo [INFO] STARTING INTERNET CONFIG
timeout /t 5 /nobreak >nul

echo [INFO] Releasing IP...
ipconfig /release

echo [INFO] Renewing IP...
ipconfig /renew

echo [INFO] Cleaning DNS cache...
ipconfig /flushdns

echo [INFO] Renewing DNS...
ipconfig /registerdns

echo [INFO] Configuring TCP...
netsh int tcp set heuristics disabled

echo [INFO] Configuring TCP autotuning...
netsh int tcp set global autotuninglevel=normal

echo [INFO] Activating RSS...
netsh int tcp set global rss=enabled
timeout /t 3 /nobreak >nul
echo.
echo [INFO] INTERNET CONFIGURATION FINISHED
pause
goto SYSTEM



:MISC

cls
echo.
echo  ▀██ ▄█▀ █    ██  ██▀███   ▒█████    ███▄ ▄███▓  ██
echo   ██▄█▒  ██  ▓██▒▓██ ▒ ██▒▒██▒  ██▒ ▓██▒▀█▀ ██▒▒▓██
echo  ▓███▄░ ▓██  ▒██░▓██ ░▄█ ▒▒██░  ██▒ ▓██    ▓██░░▒██
echo  ▓██ █▄ ▓▓█  ░██░▒██▀▀█▄  ▒██   ██░ ▒██    ▒██  ░██
echo  ▒██▒ █▄▒▒█████▓ ░██▓ ▒██▒░ ████▓▒░▒▒██▒   ░██▒ ░██
echo  ▒ ▒▒ ▓▒ ▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░░ ▒░   ░  ░ ░▓ 
echo  ░ ░▒ ▒░ ░▒░ ░ ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░░  ░      ░  ▒ 
echo  ░ ░░ ░   ░░ ░ ░    ░   ░ ░ ░ ░ ▒   ░      ░     ▒ 
echo  ░  ░      ░        ░         ░ ░  ░       ░     ░  
echo.
echo Misc Things
echo.
echo [1] Check errors in disk
echo [2] Setup virtual RAM
echo [3] Defragment Disk
echo [4] Remove Microsoft Edge
echo [0] Go to main menu
echo.
set /p option=Select an option (0-4): 

if "%option%"=="1" goto CHECK_DISK
if "%option%"=="2" goto VIRT_RAM
if "%option%"=="3" goto DEFRAG_DISK
if "%option%"=="4" goto EDGE
if "%option%"=="0" goto MENU
else
goto MISC

:EDGE
::THIS EDGE SCRIPT WASNT MADE BY ME, ALL CREDITS GO TO: Britec & Dave Kirkwood
taskkill /F /IM msedge.exe  >nul 2>&1


CD %HOMEDRIVE%%HOMEPATH%\Desktop
echo %CD%


REM ************ Main process *****************

echo *** Removing Microsoft Edge ***
call :killdir C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe
call :killdir "C:\Program Files (x86)\Microsoft\Edge"
call :killdir "C:\Program Files (x86)\Microsoft\EdgeUpdate"
call :killdir "C:\Program Files (x86)\Microsoft\EdgeCore"
call :killdir "C:\Program Files (x86)\Microsoft\EdgeWebView"
echo *** Modifying registry ***
call :editreg
echo *** Removing shortcuts ***
call :delshortcut "C:\Users\Public\Desktop\Microsoft Edge.lnk"
call :delshortcut "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"
call :delshortcut "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk"
echo Finished!
pause
exit

REM ************ KillDir: Take ownership and remove a directory *****************

:killdir
echo|set /p=Removing dir %1
if exist %1 (
	takeown /a /r /d Y /f %1 > NUL
	icacls %1 /grant administrators:f /t > NUL
	rd /s /q %1 > NUL
	if exist %1 (
		echo ...Failed.
	) else (
		echo ...Deleted.
	)
) else (
	echo ...does not exist.
)
exit /B 0

REM ************ Edit registry to add do not update Edge key *****************

:editreg
echo|set /p=Editting registry
echo Windows Registry Editor Version 5.00 > RemoveEdge.reg
echo. >> RemoveEdge.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate] >> RemoveEdge.reg
echo "DoNotUpdateToEdgeWithChromium"=dword:00000001 >> RemoveEdge.reg
echo. >> RemoveEdge.reg
echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{9459C573-B17A-45AE-9F64-1857B5D58CEE}] >> RemoveEdge.reg

regedit /s RemoveEdge.reg
del RemoveEdge.reg
echo Regedit logs removed.
exit /B 0

:: Delete Microsoft Edge Folders
rmdir /s /q "C:\Program Files (x86)\Microsoft\Edge"
rmdir /s /q "C:\Program Files (x86)\Microsoft\EdgeCore"
rmdir /s /q "C:\Program Files (x86)\Microsoft\EdgeWebView"
rmdir /s /q "C:\Program Files (x86)\Microsoft\Temp"

:: Delete Edge Icons, from all users
for /f "delims=" %%a in ('dir /b "C:\Users"') do (
del /S /Q "C:\Users\%%a\Desktop\edge.lnk" >nul 2>&1
del /S /Q "C:\Users\%%a\Desktop\Microsoft Edge.lnk" >nul 2>&1)

:: Delete additional files
if exist "C:\Windows\System32\MicrosoftEdgeCP.exe" (
for /f "delims=" %%a in ('dir /b "C:\Windows\System32\MicrosoftEdge*"') do (
takeown /f "C:\Windows\System32\%%a" > NUL 2>&1
icacls "C:\Windows\System32\%%a" /inheritance:e /grant "%UserName%:(OI)(CI)F" /T /C > NUL 2>&1
del /S /Q "C:\Windows\System32\%%a" > NUL 2>&1))

:delshortcut
echo|set /p=Removing shortcut %1
if exist %1 (
	del %1
	echo Done!.
	pause
	goto MISC
) else (
	echo Done!.
	pause
	goto MISC
)

:VIRT_RAM

cls
echo [INFO] This option will help you configure your Virtual Memory (Page File) settings.
echo [WARNING] Incorrect settings can lead to system instability or performance issues.
echo [WARNING] Proceed with caution and understand the recommendations given by Kuromi.
echo.
pause

start "" "%~dp0resources\caffeine\caffeine.exe"
:: Get system RAM in MB using PowerShell 
echo [INFO] Detecting system RAM...
for /f %%a in ('powershell -Command "(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB -as [int]"') do (
    set ram_mb=%%a
)
if defined ram_mb (
    echo [INFO] Your system has approximately %ram_mb% MB of RAM.
    echo.
) else (
    echo [ERROR] Could not detect system RAM, The script will proceed with default recommendations (assuming 2GB)
    set ram_mb=2048
    echo.
)

:: Recommendations based on RAM (Ensuring Integer Arithmetic)
echo [RECOMMENDATIONS]
echo Based on your system RAM, here are some general recommendations for the Initial and Maximum size of your Virtual Memory (in MB):
echo.
if %ram_mb% LSS 2048 (
    echo.
    echo [RECOMMENDATION] For systems with less than 2GB RAM:
    echo   Initial Size: 1.5 times your RAM (Recommended: Round up to the next multiple of 100)
    set /a recommended_initial=(%ram_mb% * 3 + 1) / 2
    echo   Recommended Initial Size: %recommended_initial% MB
    echo   Maximum Size: 3 times your RAM (Recommended: Round up to the next multiple of 100)
    set /a recommended_maximum=%ram_mb% * 3
    echo   Recommended Maximum Size: %recommended_maximum% MB
) else if %ram_mb% LSS 4096 (
    echo.
    echo [RECOMMENDATION] For systems with 2GB to 4GB RAM:
    echo   Initial Size: Equal to your RAM
    set recommended_initial=%ram_mb%
    echo   Recommended Initial Size: %recommended_initial% MB
    echo   Maximum Size: 1.5 to 2 times your RAM (Recommended: Round up to the next multiple of 100)
    set /a recommended_maximum=%ram_mb% * 2
    echo   Recommended Maximum Size: %recommended_maximum% MB
) else (
    echo.
    echo [RECOMMENDATION] For systems with more than 4GB RAM:
    echo   Initial Size: Equal to or slightly less than your RAM
    set recommended_initial=%ram_mb%
    echo   Recommended Initial Size: %recommended_initial% MB
    echo   Maximum Size: 1.5 times your RAM (Recommended: Round up to the next multiple of 100)
    set /a recommended_maximum=(%ram_mb% * 3 + 1) / 2
    echo   Recommended Maximum Size: %recommended_maximum% MB
    echo.
    echo [INFO] For systems with ample RAM, you might consider letting Windows manage the page file size automatically for optimal performance
)
echo.

:CONFIGURE_VM
set /p initial_size="Enter the desired Initial Size (in MB, or 'auto' for automatic): "

:: Clean the input to remove non-numeric characters like "MB" or spaces
set initial_size=%initial_size:MB=%
set initial_size=%initial_size: =%

:: Check if the input is a valid number
echo Checking Initial Size: %initial_size%

:: Validate that initial_size is a positive integer
for /f "delims=" %%i in ("%initial_size%") do (
    set /a test=%%i >nul 2>&1
    if errorlevel 1 goto :INVALID_INPUT
)

:: If valid, continue to get the maximum size
set /p maximum_size="Enter the desired Maximum Size (in MB): "

:: Clean the maximum size input to remove non-numeric characters like "MB" or spaces
set maximum_size=%maximum_size:MB=%
set maximum_size=%maximum_size: =%

:: Check if the maximum size is a valid number
echo Checking Maximum Size: %maximum_size%

for /f "delims=" %%i in ("%maximum_size%") do (
    set /a test=%%i >nul 2>&1
    if errorlevel 1 goto :INVALID_INPUT
)

:: Check if Maximum Size is greater than or equal to Initial Size
if %maximum_size% LSS %initial_size% goto :MAX_TOO_SMALL

:ASK_CONRAM
echo.
echo [CONFIRMATION] You are about to set the Virtual Memory with the following settings:
echo   Initial Size: %initial_size% MB
echo   Maximum Size: %maximum_size% MB
echo.
set /p confirm=Do you want to apply these settings?- YES or NO: 
if /i "%confirm%"=="no" (
    goto MISC
) else (
    if /i "%confirm%"=="yes" (
        goto APPLY_SETTINGS
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 /nobreak >nul
	cls
        goto ASK_CONRAM
    )
)

:SET_AUTOMATIC
echo.
echo [INFO] Setting Virtual Memory to be managed automatically by Windows
echo.
goto :APPLY_AUTOMATIC

:APPLY_SETTINGS
echo.
echo [INFO] Attempting to apply the specified Virtual Memory settings
echo.
wmic computersystem set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%initial_size%,MaximumSize=%maximum_size%
echo.
echo [INFO] Virtual Memory settings applied. You will need to restart your computer for the changes to take effect
goto :END

:APPLY_AUTOMATIC
echo.
echo [INFO] Attempting to set Virtual Memory to be managed automatically by Windows
wmic computersystem set AutomaticManagedPagefile=True
echo.
echo [INFO] Virtual Memory set to be managed automatically, you will need to restart your computer for the changes to take effect
goto :END

:INVALID_INPUT
echo.
echo [ERROR] Invalid input. Please enter a valid positive integer for the size
echo.
goto :CONFIGURE_VM

:MAX_TOO_SMALL
echo.
echo [ERROR] Maximum Size must be greater than or equal to the Initial Size
echo.
goto :CONFIGURE_VM

:END
taskkill /f /im caffeine.exe >nul 2>&1
pause
exit /b

:CHECK_DISK
cls
color 0C
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo [WARNING] Running disk check can take a long time.
echo.
echo Available Drives:
wmic logicaldisk get Caption
echo.
set /p drive_check="Enter the drive letter to check (e.g., C): "
color 0D
echo [INFO] Running disk check on drive %drive_check%...
chkdsk %drive_check%: /f /r
echo [INFO] Disk check completed.
pause
goto MISC

:DEFRAG_DISK
cls
color 0C
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo WARNING.
echo [INFO] This option will defragment your hard drive to improve performance.
echo [WARNING] Do NOT interrupt the defragmentation process.
set /p defdisk=Do you want to continue?- YES or NO: 
if /i "%defdisk%"=="no" (
    goto MISC
) else (
    if /i "%defdisk%"=="yes" (
        goto DEFRADISK
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 /nobreak >nul
	cls
        goto DEFRAG_DISK
    )
)


:DEFRADISK
echo.
echo Available Drives:
wmic logicaldisk get Caption

echo.
set /p drive_defrag="Enter the drive letter to defragment (e.g., C): "
color 0D
start "" "%~dp0resources\caffeine\caffeine.exe"
echo [INFO] Starting defragmentation on drive %drive_defrag%...
defrag %drive_defrag%: /O /H /V

echo.
taskkill /f /im caffeine.exe >nul 2>&1
echo [INFO] Defragmentation completed.
pause
goto MISC


:PROGRAMS
cls
echo.
echo  ▀██ ▄█▀ █    ██  ██▀███   ▒█████    ███▄ ▄███▓  ██
echo   ██▄█▒  ██  ▓██▒▓██ ▒ ██▒▒██▒  ██▒ ▓██▒▀█▀ ██▒▒▓██
echo  ▓███▄░ ▓██  ▒██░▓██ ░▄█ ▒▒██░  ██▒ ▓██    ▓██░░▒██
echo  ▓██ █▄ ▓▓█  ░██░▒██▀▀█▄  ▒██   ██░ ▒██    ▒██  ░██
echo  ▒██▒ █▄▒▒█████▓ ░██▓ ▒██▒░ ████▓▒░▒▒██▒   ░██▒ ░██
echo  ▒ ▒▒ ▓▒ ▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░░ ▒░   ░  ░ ░▓ 
echo  ░ ░▒ ▒░ ░▒░ ░ ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░░  ░      ░  ▒ 
echo  ░ ░░ ░   ░░ ░ ░    ░   ░ ░ ░ ░ ▒   ░      ░     ▒ 
echo  ░  ░      ░        ░         ░ ░  ░       ░     ░  
echo.
echo Program Installer Downloader
echo.
echo [1] Download Chrome
echo [2] Download Firefox
echo [3] Download VLC
echo [4] Download 7zip
echo [5] Download Discord
echo [6] Download VSCodium
echo [7] Download VS Code
echo [8] Download Visual Studio Community
echo [9] Download Spotify
echo [10] Download Steam
echo [11] Download DirectX End-User Runtime
echo [12] Download Visual C++ Redistributable (x64)
echo [13] Download .NET Desktop Runtime (x64)
echo [14] Download WinRAR (64-bit)
echo [15] Download qBittorrent (64-bit)
echo [0] Go to main menu
echo.
set /p option=Select an option (0-4): 

if "%option%"=="1" goto DOWNLOAD_CHROME
if "%option%"=="2" goto DOWNLOAD_FIREFOX
if "%option%"=="3" goto DOWNLOAD_VLC
if "%option%"=="4" goto DOWNLOAD_7ZIP
if "%option%"=="5" goto DOWNLOAD_DISCORD
if "%option%"=="6" goto DOWNLOAD_VSCODIUM
if "%option%"=="7" goto DOWNLOAD_VSCODE
if "%option%"=="8" goto DOWNLOAD_VISUALSTUDIO
if "%option%"=="9" goto DOWNLOAD_SPOTIFY
if "%option%"=="10" goto DOWNLOAD_STEAM
if "%option%"=="11" goto DOWNLOAD_DIRECTX
if "%option%"=="12" goto DOWNLOAD_VCREDIST
if "%option%"=="13" goto DOWNLOAD_DOTNET
if "%option%"=="14" goto DOWNLOAD_WINRAR
if "%option%"=="15" goto DOWNLOAD_QBITTORRENT
if "%option%"=="0" goto MENU
else
goto PROGRAMS

:DOWNLOAD_CHROME
echo [INFO] Downloading Google Chrome installer...
call :download " https://dl.google.com/chrome/install/latest/chrome_installer.exe" "ChromeSetup.exe"
goto PROGRAMS

:DOWNLOAD_FIREFOX
echo [INFO] Downloading Mozilla Firefox installer...
call :download "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US" "FirefoxSetup.exe"
goto PROGRAMS

:DOWNLOAD_VLC
echo [INFO] Downloading VLC Media Player installer...
call :download "https://download.videolan.org/pub/videolan/vlc/last/win64/vlc-setup.exe" "vlc-setup.exe"
goto PROGRAMS

:DOWNLOAD_7ZIP
echo [INFO] Downloading 7-Zip installer...
call :download "https://www.7-zip.org/a/7z2409-x64.exe" "7z2407-x64.exe"
goto PROGRAMS

:DOWNLOAD_DISCORD
echo [INFO] Downloading Discord installer...
call :download "https://discord.com/api/download?platform=win" "DiscordSetup.exe"
goto PROGRAMS

:DOWNLOAD_VSCODIUM
echo [INFO] Downloading VSCodium installer (User Installer)...
call :download "https://github.com/VSCodium/vscodium/releases/download/1.99.32562/VSCodiumUserSetup-x64-1.99.32562.exe" "VSCodiumUserSetup-x64-1.99.32562.exe"
goto PROGRAMS

:DOWNLOAD_VSCODE
echo [INFO] Downloading Visual Studio Code installer...
call :download "https://go.microsoft.com/fwlink/?LinkID=620882" "VSCodeSetup.exe"
goto PROGRAMS

:DOWNLOAD_VISUALSTUDIO
echo [INFO] Downloading Visual Studio Community installer (Web Installer)...
echo [WARNING] This is a web installer and requires an internet connection during installation.
call :download "https://aka.ms/vs/17/release/vs_installer.exe" "VisualStudioSetup.exe"
goto PROGRAMS

:DOWNLOAD_SPOTIFY
echo [INFO] Downloading Spotify installer...
call :download "https://download.scdn.co/SpotifySetup.exe" "SpotifySetup.exe"
goto PROGRAMS

:DOWNLOAD_STEAM
echo [INFO] Downloading Steam installer...
call :download "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe" "SteamSetup.exe"
goto PROGRAMS

:DOWNLOAD_DIRECTX
echo [INFO] Downloading DirectX End-User Runtime Web Installer...
echo [WARNING] This is a web installer and requires an internet connection during installation.
call :download "https://download.microsoft.com/download/1/7/1/1718ccc4-6315-4d8e-9543-8e28a4e18c4c/dxwebsetup.exe" "DirectXSetup.exe"
goto PROGRAMS

:DOWNLOAD_VCREDIST
echo [INFO] Downloading Visual C++ Redistributable (x64) - Latest Supported...
echo [WARNING] You might need to install other versions depending on the applications you use.
call :download "https://download.microsoft.com/download/9/3/f/93fcf1e7-e6a4-478b-96e7-d4b285925b00/vc_redist.x64.exe" "VC_Redist_x64.exe"
goto PROGRAMS

:DOWNLOAD_DOTNET
echo [INFO] Downloading .NET Desktop Runtime (x64) - Latest Stable...
echo [WARNING] You might need the SDK or other versions depending on your development needs.
call :download "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-8.0.408-windows-x64-installer"
goto PROGRAMS

:DOWNLOAD_WINRAR
echo [INFO] Downloading WinRAR (64-bit) - English...
call :download "https://www.rarlab.com/rar/winrar-x64-624.exe" "WinRAR_x64.exe"
goto PROGRAMS

:DOWNLOAD_QBITTORRENT
echo [INFO] Downloading qBittorrent (64-bit) - Stable...
call :download "https://sourceforge.net/projects/qbittorrent/files/latest/download" "qBittorrent_x64.exe"
goto PROGRAMS



:download
set "download_url=%~1"
set "file_name=%~2"
set "download_folder=%~dp0KUROMI_SETUPS"

if not exist "%download_folder%" mkdir "%download_folder%"

echo.
echo [INFO] Downloading "%file_name%" from "%download_url%" to "%download_folder%"...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%download_url%', '%download_folder%/%file_name%')"
if exist "%download_folder%/%file_name%" (
    echo.
    echo [INFO] Download complete! The installer was saved in "%download_folder%".
    pause
    goto PROGRAMS
) else (
    echo.
    echo [ERROR] Download failed or the file was not saved correctly.
    pause
    goto PROGRAMS
)
pause
exit /b



