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


:FIRST_CHECK

if exist "%~dp0%resources\kuromi_log.txt" (
    goto MENU
) else (
	goto LICENSE
   
)


:LICENSE
echo LICENSE AGREEMENT
echo.
echo IMPORTANT: READ THIS AGREEMENT CAREFULLY BEFORE USING THE SOFTWARE.
echo.
echo THIS PROJECT IS UNDER THE MIT LICENSE.
echo Copyright (c) 2025 Kryx/Canopy
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
echo to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
echo and/or sell copies of the Software, and to permit persons to whom the Software is provided to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
echo.
echo The creator does not take responsibility for any problems that arise from the use of this software. This includes, 
echo but is not limited to, hardware damage, software malfunctions, or any other issue that may occur.
echo.
set /p agreement=Type yes to accept the agreement and use the software: 
if /i "%agreement%"=="no" (
    cls
    echo [INFO] The script will close in 5 seconds.
    timeout /t 5 >nul
    exit /b
) else (
    if /i "%agreement%"=="yes" (
	cls
	echo Use Kuromi at your own risk.
	timeout /t 3 >nul
	goto :PRERUN
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 >nul
	cls
        goto :LICENSE
    )
)




:PRERUN
cls
echo The script will now perform a pre-run proccess, the script will ask you questions so please make sure you respond them.
echo.
echo Please , reboot your computer before running Kuromi, this will allow pending updates and unnecesary procces to end before Kuromi could affect them.
echo.
echo Remember to read the README.txt

pause
cls
echo [INFO] Checking hardware...
echo.
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance Win32_ComputerSystem).Manufacturer"') do set "vm_manu=%%i"
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance Win32_ComputerSystem).Model"') do set "vm_model=%%i"

echo Manufacturer: %vm_manu%
echo Model: %vm_model%

echo %vm_manu% | find /i "VMware" >nul && set IS_VM=1
echo %vm_manu% | find /i "innotek" >nul && set IS_VM=1
echo %vm_manu% | find /i "Oracle" >nul && set IS_VM=1
echo %vm_manu% | find /i "Microsoft" >nul && echo %vm_model% | find /i "Virtual" >nul && set IS_VM=1
echo %vm_manu% | find /i "QEMU" >nul && set IS_VM=1
echo %vm_manu% | find /i "Parallels" >nul && set IS_VM=1

if defined IS_VM (
	echo.
    echo [INFO] Looks like you are on a virtual machine.
	echo.
    echo [INFO] Some things of the script may not work properly or not work at all on virtual machines.
	echo.
    pause
) 

echo [INFO] Checking if 'wmic' is available...
timeout /t 3 /nobreak >nul
where wmic >nul 2>nul
if %errorlevel% NEQ 0 (
    echo.
    echo [INFO] 'wmic' not found. restoring required tool... 
    echo.
    wmic
    exit
    if %errorlevel% NEQ 0 (
        echo.
        echo [ERROR] Failed to or restore 'wmic'.
        pause
        exit /b
    )
    echo.
    echo [INFO] 'wmic' successfully restored.
    pause
 	goto ASK_RESTORE
) else (
    echo.
    echo [INFO] 'wmic' is already available.
    pause 
   goto ASK_RESTORE
)



:ASK_RESTORE
cls
echo Do you want to create a system restore point? (recommended)
set /p restore=Type YES or NO: 
if /i "%restore%"=="yes" (
    echo [INFO] Creating restore point...
    powershell -Command "Checkpoint-Computer -Description 'Kuromi Restore Point' -RestorePointType 'MODIFY_SETTINGS'" 
    echo [INFO] Done! , The restore point was saved with the name "Kuromi Restore Point".
    pause
    echo > %~dp0resources\kuromi_log.txt
	goto FINAL_PRE
) else (
    if /i "%restore%"=="no" (
        echo [INFO] Skipping restore point creation.
        timeout /t 3 >nul
	echo > %~dp0resources\kuromi_log.txt
	pause
	cls
	goto FINAL_PRE
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 >nul
	cls
        goto ASK_RESTORE
    )
)


:FINAL_PRE

set /p reboot=A computer reboot is considered recommended, type "yes" if you want to reboot your computer now, type "no" if you want to reboot manually:  

if /i "%reboot%"=="yes" (
    echo [INFO] REBOOTING IN 10 SECONDS...
	shutdown /r /t 10
	pause
	exit /b
	
) else (
    if /i "%restore%"=="no" (
	echo.
	echo [INFO] You have selected to reboot manually, make sure to do it!
	echo.
	echo [INFO] The script will now close, you can open it again whenever you want.
	pause
	exit /b
    ) else (
	cls
        echo Invalid input.
	timeout /t 3 >nul
	cls
        goto FINAL_PRE
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
echo Kryx.Dev is my website!
echo.
echo Last update: 20/9/2025
echo Version: Beta 1.0
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
echo [5] Deactivate Windows Gaming mode and Game bar
echo [6] Optimize Windows in general
echo [0] Go to main menu
echo.
set /p option=Select an option (0-6): 

if "%option%"=="1" goto CLEAN_FILES
if "%option%"=="2" goto TELEMETRY
if "%option%"=="3" goto BLOATWARE
if "%option%"=="4" goto SERVICES
if "%option%"=="5" goto WINGAME
if "%option%"=="6" goto OPTGEN
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
echo.
echo [INFO] Cleaning Recycle Bin...
echo.
rd /s /q C:\$Recycle.Bin
echo.
echo [INFO] Recycle Bin cleaned.

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

    set apps="Microsoft.WindowsCalculator" "Microsoft.WindowsCamera" "Microsoft.Windows.Photos" "microsoft.windowscommunicationsapps" "Microsoft.ZuneMusic" "Microsoft.ZuneVideo" "Microsoft.Office.OneNote" "Microsoft.WindowsAlarms" "Microsoft.WindowsMaps" "Microsoft.XboxApp" "Microsoft.MSPaint" "Microsoft.BingNews" "Microsoft.BingWeather" "Microsoft.SkypeApp" "Microsoft.OneDriveSync" "Microsoft.XboxGamingOverlay" "Microsoft.Xbox.TCUI" "Microsoft.XboxIdentityProvider" "Microsoft.549981C3F5F10" "Microsoft.MicrosoftSolitaireCollection" "Microsoft.Todos" "Microsoft.Microsoft3DViewer" "Microsoft.MixedReality.Portal" "Microsoft.Getstarted" "Microsoft.Clipchamp" "Microsoft.YourPhone" "Microsoft.WindowsFeedbackHub" "king.com.CandyCrushSaga" "TikTok.TikTok" "4DF9E0F8.Netflix" "Facebook.Instagram" "Facebook.Facebook" "LinkedInforWindows" "Disney.37853FC22B2CE" "GAMELOFTSA.MarchofEmpires" "king.com.BubbleWitch3Saga" "Microsoft.GetHelp" "Microsoft.MicrosoftOfficeHub"     "Microsoft.WindowsSoundRecorder" "Microsoft.People" "Microsoft.BingSearch" "Microsoft.MicrosoftStickyNotes" "Microsoft.XboxGameOverlay" "Microsoft.XboxSpeechToTextOverlay" 


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
set SERVICES=WerSvc RemoteAccess TermService UmRdpService RemoteDesktop TabletInputService WbioSrvc DPS FDPHost FDResPub WMPNetworkSvc XboxGipSvc XblAuthIdMgrSvc XblGameSaveSvc XboxNetApiSvc SysMain RetailDemo SCardSvr Fax XblAuthManager XblGameSave CscService
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
	cls
	goto BLUEASK
) else (
    if /i "%PRINTCHOICE%"=="yes" (
	sc stop Spooler >nul 2>&1
	sc config Spooler start= disabled >nul 2>&1
    	sc stop IPPPrint >nul 2>&1
   	sc config IPPPrint start= disabled >nul 2>&1
	echo.
	echo. [INFO] Printer services deactivated
	pause
	goto BLUEASK
    ) else (
	cls
        echo Invalid input.
        timeout /t 3 >nul
	cls
        goto ASK_PRINT
    )
)


:BLUEASK

echo.
echo [INFO] Do you want to turn off Bluetooth services? This can cause problems with Bluetooth headphones and others
set /p BLUECHOICE=Type YES or No: 
if /i "%BLUECHOICE%"=="no" (
	cls
	echo [INFO] Unnecessary services deactivated
	pause
	goto OPTIMIZATION
) else (
    if /i "%BLUECHOICE%"=="yes" (

	net stop BthHFSrv
	net stop BthAvrcpSvc
	net stop BthLEEnum

	sc config BthHFSrv start= disabled
	sc config BthAvrcpSvc start= disabled
	sc config BthLEEnum start= disabled

	echo.
	echo. [INFO] Bluetooth services deactivated
	pause
	goto OPTIMIZATION
    ) else (
	cls
        echo Invalid input.
        timeout /t 3 >nul
	cls
        goto BLUEASK
    )
)


:WINGAME

echo [INFO] Deactivating Windows Game mode...
echo.
timeout /t 3 /nobreak >nul
echo.
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v UseNexusForGameBar /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v ShowStartupTips /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v value /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo [INFO] Deactivating Windows Game bar...
echo.
timeout /t 3 /nobreak >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

sc stop "XboxGameBar" >nul 2>&1
sc config "XboxGameBar" start= disabled >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "DisableGameDVR" /t REG_DWORD /d 1 /f

echo.
echo [INFO] Game mode and Game bar deactivated succesfully
pause
goto OPTIMIZATION

:OPTGEN

echo [INFO] Reducing shutdown and app timeout delays...
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 1000 /f
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f

echo [INFO] Disabling unnecessary visual effects...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

echo [INFO] Disabling SysMain (Superfetch) service...
sc stop "SysMain"
sc config "SysMain" start=disabled

echo [INFO] Disabling Xbox Game Monitoring...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /v Start /t REG_DWORD /d 4 /f

echo [INFO] Disabling Maps and Content Delivery Manager services...
sc stop "MapsBroker"
sc config "MapsBroker" start=disabled
sc stop "CDPSvc"
sc config "CDPSvc" start=disabled

echo [INFO] Disabling Tips, Tricks, and Suggestions...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f

echo.
echo [INFO] The system is now a little more faster
pause
goto OPTIMIZATION


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

if "%monitoreo%"=="1" netstat /nbf & echo. & echo [INFO] Press any key to got back to the system menu & pause > nul
if "%monitoreo%"=="2" systeminfo & echo. & echo [INFO] Press any key to got back to the system menu & pause > nul
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
echo [4] Uninstall Microsoft Edge
echo [5] Uninstall Microsoft Copilot
echo [6] Remove Ads in File Explorer
echo [7] Enchance privacy
echo [8] Disable Windows Suggested Content
echo [9] Disable Sensor Services
echo [10] Disable Special Keys
echo [11] Fix and check Windows Image/Files
echo [0] Go to main menu
echo.
set /p option=Select an option (0-10): 

if "%option%"=="1" goto CHECK_DISK
if "%option%"=="2" goto VIRT_RAM
if "%option%"=="3" goto DEFRAG_DISK
if "%option%"=="4" goto EDGE
if "%option%"=="5" goto COPILOT
if "%option%"=="6" goto ADSEXPO
if "%option%"=="7" goto PRIVACY
if "%option%"=="8" goto SUGCON
if "%option%"=="9" goto SENSORES
if "%option%"=="10" goto SPECIALKEYS
if "%option%"=="11" goto CHECK_WINDOWS
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
    echo.
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
    color 0D
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

:COPILOT
cls
echo [INFO] Removing Microsoft Copilot AI...

sc stop "Microsoft Copilot" >nul 2>&1
sc config "Microsoft Copilot" start= disabled >nul 2>&1

schtasks /delete /tn "Microsoft\Windows\Shell\Copilot" /f >nul 2>&1
schtasks /delete /tn "Microsoft\Windows\Shell\CopilotAutoUpdate" /f >nul 2>&1

reg delete "HKCU\Software\Microsoft\Windows\Shell\Copilot" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Copilot" /f >nul 2>&1

powershell -Command "Get-AppxPackage *Copilot* | Remove-AppxPackage"

echo.
echo [INFO] Microsoft Copilot was removed
pause
goto MISC

:ADSEXPO

cls
echo [INFO] Removing File Explorer ads...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowRecommendations /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowContentSuggestions /t REG_DWORD /d 0 /f


echo.
echo [INFO] The File Explorer ads were removed
pause
goto MISC


:PRIVACY
cls
echo.
echo [INFO] Removing geolocating services and sensors...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableLocation /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableSensors /t REG_DWORD /d 1 /f

echo [INFO] Removing handwriting and typing personalization...

reg add "HKCU\Software\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f

echo [INFO] Disabling Activity History (Timeline)

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f

echo [INFO] Disabling Advertising ID...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

echo [INFO] Disabling Windows Spotlight on lock screen...

reg add "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f

echo [INFO] Disabling suggested apps...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableConsumerFeatures /t REG_DWORD /d 1 /f

echo [INFO] Disabling cloud clipboard synchronization...

reg add "HKCU\Software\Microsoft\Clipboard" /v EnableCloudClipboard /t REG_DWORD /d 0 /f

echo [INFO] Disabling Cortana...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

echo [INFO] Disabling Windows feedback prompts...

reg add "HKCU\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v PeriodInNanoSeconds /t REG_QWORD /d 0 /f

echo.
echo [INFO] The system is now more private
pause
goto MISC


:SUGCON
cls
echo [INFO] Disabling Windows suggested notifications and ads...
echo.

:: Disable Start menu suggestions
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f

:: Disable lock screen suggestions
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f

:: Disable other system suggestions
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f

:: Disable suggestions in the Settings app
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f

echo.
echo [INFO] Windows Suggested content disabled, remember to restart your computer for the effects to take change.
pause
goto MISC

:SENSORES

cls
echo [INFO] Disabling location sensors...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v LastUsedTimeStop /t REG_QWORD /d 0 /f
echo.
echo [INFO] Location sensors deactivated
pause
goto MISC

:SPECIALKEYS
cls
echo [INFO] Deactivating special keys..
:: Sticky Keys
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f
:: Filter Keys
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f
:: Toggle Keys
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f
echo.
echo [INFO] Special Keys deactivated.
pause
goto MISC



:CHECK_WINDOWS

cls
echo [INFO] The script will now check and repair the Windows image...
echo [INFO] This will take some time...
start "" "%~dp0resources\caffeine\caffeine.exe"
echo.

DISM /Online /Cleanup-Image /RestoreHealth
echo.
sfc /scannow
echo.

taskkill /f /im caffeine.exe >nul 2>&1
echo [INFO] The Windows image was checked and fixed.

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
echo [INFO] All the installers are their x64 version
echo.
echo [INFO] This will change the appearance of the script
echo.
echo [1] Chrome               	[10] Spotify				[19] Brave Browser
echo [2] Firefox               	[11] Steam				[20] OBS Studio
echo [3] VLC                   	[12] DirectX End-Use Runtime		[0] Go to Main Menu
echo [4] 7-Zip                 	[13] Visual C++ Redistributable 
echo [5] Discord               	[14] .NET Runtime 
echo [6] VSCodium              	[15] WinRAR 
echo [7] VS Code              	[16] qBittorrent 
echo [8] Visual Studio Comm.   	[17] Tor Browser
echo [9] notepad ++			[18] Librewolf
echo.
set /p option=Select an option (0-19): 

if "%option%"=="1" goto DOWNLOAD_CHROME
if "%option%"=="2" goto DOWNLOAD_FIREFOX
if "%option%"=="3" goto DOWNLOAD_VLC
if "%option%"=="4" goto DOWNLOAD_7ZIP
if "%option%"=="5" goto DOWNLOAD_DISCORD
if "%option%"=="6" goto DOWNLOAD_VSCODIUM
if "%option%"=="7" goto DOWNLOAD_VSCODE
if "%option%"=="8" goto DOWNLOAD_VISUALSTUDIO
if "%option%"=="9" goto DOWNLOAD_NOTEPAD
if "%option%"=="10" goto DOWNLOAD_SPOTIFY
if "%option%"=="11" goto DOWNLOAD_STEAM
if "%option%"=="12" goto DOWNLOAD_DIRECTX
if "%option%"=="13" goto DOWNLOAD_VCREDIST
if "%option%"=="14" goto DOWNLOAD_DOTNET
if "%option%"=="15" goto DOWNLOAD_WINRAR
if "%option%"=="16" goto DOWNLOAD_QBITTORRENT
if "%option%"=="17" goto DOWNLOAD_TOR
if "%option%"=="18" goto DOWNLOAD_LIBREWOLF
if "%option%"=="19" goto DOWNLOAD_BRAVE
if "%option%"=="20" goto DOWNLOAD_OBS
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
call :download "https://www.7-zip.org/a/7z2409-x64.exe" "7zip-x64.exe"
goto PROGRAMS

:DOWNLOAD_DISCORD
echo [INFO] Downloading Discord installer...
call :download "https://discord.com/api/download?platform=win" "DiscordSetup.exe"
goto PROGRAMS

:DOWNLOAD_VSCODIUM
echo [INFO] Downloading VSCodium installer (User Installer)...
call :download "https://github.com/VSCodium/vscodium/releases/download/1.99.32846/VSCodiumUserSetup-x64-1.99.32846.exe" "VSCodiumUserSetup-x64-1.99.32846.exe"
goto PROGRAMS

:DOWNLOAD_VSCODE
echo [INFO] Downloading Visual Studio Code installer...
call :download "https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/VSCodeUserSetup-x64-1.99.3.exe" "VSCodeSetup.exe"
goto PROGRAMS

:DOWNLOAD_VISUALSTUDIO
echo [INFO] Downloading Visual Studio Community installer (Web Installer)...
echo [WARNING] This is a web installer and requires an internet connection during installation.
echo.
call :download "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=community&channel=Release&version=VS2022&source=VSLandingPage&cid=2030:b1c3859cb8904aae80b186ce0a134f5c" "VisualStudioSetup.exe"
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
echo.
call :download "https://download.microsoft.com/download/1/7/1/1718ccc4-6315-4d8e-9543-8e28a4e18c4c/dxwebsetup.exe" "DirectXSetup.exe"
goto PROGRAMS

:DOWNLOAD_VCREDIST
echo [INFO] Downloading Visual C++ Redistributable (x64) - Latest Supported...
echo [WARNING] You might need to install other versions depending on the applications you use.
echo.
call :download "https://download.microsoft.com/download/9/3/f/93fcf1e7-e6a4-478b-96e7-d4b285925b00/vc_redist.x64.exe" "VC_Redist_x64.exe"
goto PROGRAMS

:DOWNLOAD_DOTNET
echo [INFO] Downloading .NET Desktop Runtime (x64) - Latest Stable...
echo [WARNING] You might need the SDK or other versions depending on your development needs.
echo.
call :download "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.408/dotnet-sdk-8.0.408-win-x64.exe" "dotnet-sdk-8.0.408-win-x64.exe"
goto PROGRAMS

:DOWNLOAD_WINRAR
echo [INFO] Downloading WinRAR (64-bit) - English...
call :download "https://www.rarlab.com/rar/winrar-x64-624.exe" "WinRAR_x64.exe"
goto PROGRAMS

:DOWNLOAD_QBITTORRENT
echo [INFO] Downloading qBittorrent (64-bit) - Stable...
call :download "https://cold4.gofile.io/download/web/ef2d2449-f68b-41cd-a210-d974df05cfca/qbittorrent_5.1.0_x64_setup.exe" "qBittorrent_x64.exe"
goto PROGRAMS

:DOWNLOAD_NOTEPAD
echo [INFO] Downloading Notepad ++...
call :download "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.8/npp.8.8.Installer.x64.exe" "Notepadpp_8.8_x64.exe"
goto PROGRAMS


:DOWNLOAD_TOR
echo [INFO] Downloading Tor Browser...
call :download "https://www.torproject.org/dist/torbrowser/14.5.1/tor-browser-windows-x86_64-portable-14.5.1.exe" "Tor-Browser_x64.exe"
goto PROGRAMS

:DOWNLOAD_BRAVE
echo [INFO] Downloading Brave Browser...
call :download "https://referrals.brave.com/latest/BraveBrowserSetup-BRV002.exe" "BraveBrowserSetup.exe"
goto PROGRAMS

:DOWNLOAD_LIBREWOLF
echo [INFO] Downloading Librewolf...
call :download "https://gitlab.com/api/v4/projects/44042130/packages/generic/librewolf/143.0-1/librewolf-143.0-1-windows-x86_64-setup.exe" "Librewolf_v143.0-1_x86_x64.exe"
goto PROGRAMS

:DOWNLOAD_OBS
echo [INFO] Downloading Librewolf...
call :download "https://cdn-fastly.obsproject.com/downloads/OBS-Studio-31.1.2-Windows-x64-Installer.exe" 
"OBS-Studio-31.1.2-Windows-x64-Installer.exe"
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



