@echo off
title Kuromi Wmic Installer
color 0D
chcp 65001 >nul


net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please execute the script with admin.
    pause
    exit /b
)


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
echo Welcome to the Kuromi wmic installer
echo.
:: Check if wmic is available
echo [INFO] Checking if 'wmic' is available...
timeout /t 3 /nobreak >nul
where wmic >nul 2>nul
if %errorlevel% NEQ 0 (
    echo [INFO] 'wmic' not found. Installing required tool...
    dism /online /enable-feature /featurename:Microsoft-Windows-Management-Infrastructure /all /norestart
    if %errorlevel% NEQ 0 (
        echo [ERROR] Failed to install or restore 'wmic'.
        pause
        exit /b
    )
    echo.
    echo [INFO] 'wmic' successfully installed or restored. Please reboot your computer
    pause
    exit /b
) else (
    echo.
    echo [INFO] 'wmic' is already available.
    pause 
    exit /b
)