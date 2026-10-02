@echo off
setlocal enabledelayedexpansion
title LNMIIT Login Utility - Quick Setup & Installer

:: Change directory to script folder
cd /d "%~dp0"
set "EXT_DIR=%~dp0"
:: Strip trailing backslash if present
if "%EXT_DIR:~-1%"=="\" set "EXT_DIR=%EXT_DIR:~0,-1%"

cls
echo =====================================================================
echo           LNMIIT LOGIN UTILITY - ONE-CLICK INSTALLER (WINDOWS)
echo =====================================================================
echo.
echo   [!] Extension Directory: "%EXT_DIR%"
echo.

:: Detect Browsers
set "CHROME_EXE="
set "BRAVE_EXE="
set "EDGE_EXE="

if exist "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" set "CHROME_EXE=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
if not defined CHROME_EXE if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME_EXE=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined CHROME_EXE if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME_EXE=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"

if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe" set "BRAVE_EXE=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"
if not defined BRAVE_EXE if exist "%ProgramFiles%\BraveSoftware\Brave-Browser\Application\brave.exe" set "BRAVE_EXE=%ProgramFiles%\BraveSoftware\Brave-Browser\Application\brave.exe"

if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "EDGE_EXE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not defined EDGE_EXE if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "EDGE_EXE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"

echo Detected Browsers on your system:
if defined CHROME_EXE ( echo   - Google Chrome: Found ) else ( echo   - Google Chrome: Not found )
if defined BRAVE_EXE ( echo   - Brave Browser: Found ) else ( echo   - Brave Browser: Not found )
if defined EDGE_EXE ( echo   - Microsoft Edge: Found ) else ( echo   - Microsoft Edge: Not found )
echo.

:: Copy extension path to Windows clipboard automatically
echo %EXT_DIR%| clip
echo   [OK] Extension path has been copied to your clipboard!
echo.
echo =====================================================================
echo   CHOOSE AN ACTION:
echo =====================================================================
echo   [1] Guided Setup: Open Extensions Page (Recommended for permanent use)
echo   [2] Quick Launch: Start Chrome with Extension pre-loaded
echo   [3] Quick Launch: Start Brave with Extension pre-loaded
echo   [4] Quick Launch: Start Edge with Extension pre-loaded
echo   [5] Package Extension into a clean .zip file (for sharing)
echo   [6] Exit
echo.
set /p "choice=Enter your choice (1-6) [default: 1]: "
if "%choice%"=="" set "choice=1"

if "%choice%"=="1" goto GUIDED_INSTALL
if "%choice%"=="2" goto LAUNCH_CHROME
if "%choice%"=="3" goto LAUNCH_BRAVE
if "%choice%"=="4" goto LAUNCH_EDGE
if "%choice%"=="5" goto PACKAGE_ZIP
if "%choice%"=="6" goto END

:GUIDED_INSTALL
cls
echo =====================================================================
echo            PERMANENT SETUP IN 3 EASY STEPS (10 SECONDS)
echo =====================================================================
echo.
echo   Step 1: Your browser extensions page is opening now.
echo   Step 2: Turn ON "Developer mode" (toggle in the top-right corner).
echo   Step 3: Click "Load unpacked" (top-left button).
echo   Step 4: Press [Ctrl + V] in the folder path and press Enter!
echo.
echo   * The path was already copied to your clipboard:
echo     "%EXT_DIR%"
echo.
echo =====================================================================
echo.

:: Open the extensions management URL in the best available browser
if defined CHROME_EXE (
    start "" "%CHROME_EXE%" "chrome://extensions"
) else if defined BRAVE_EXE (
    start "" "%BRAVE_EXE%" "brave://extensions"
) else if defined EDGE_EXE (
    start "" "%EDGE_EXE%" "edge://extensions"
) else (
    start "" "chrome://extensions"
)
pause
goto END

:LAUNCH_CHROME
if not defined CHROME_EXE (
    echo [Error] Google Chrome executable was not found.
    pause
    goto END
)
echo Launching Google Chrome with LNMIIT Login Utility...
start "" "%CHROME_EXE%" --load-extension="%EXT_DIR%" "https://172.22.2.6/connect/PortalMain"
goto END

:LAUNCH_BRAVE
if not defined BRAVE_EXE (
    echo [Error] Brave Browser executable was not found.
    pause
    goto END
)
echo Launching Brave Browser with LNMIIT Login Utility...
start "" "%BRAVE_EXE%" --load-extension="%EXT_DIR%" "https://172.22.2.6/connect/PortalMain"
goto END

:LAUNCH_EDGE
if not defined EDGE_EXE (
    echo [Error] Microsoft Edge executable was not found.
    pause
    goto END
)
echo Launching Microsoft Edge with LNMIIT Login Utility...
start "" "%EDGE_EXE%" --load-extension="%EXT_DIR%" "https://172.22.2.6/connect/PortalMain"
goto END

:PACKAGE_ZIP
cls
echo Packaging LNMIIT Login Utility into a release zip...
powershell -NoProfile -ExecutionPolicy Bypass -File "%EXT_DIR%\scripts\package.ps1"
pause
goto END

:END
exit /b 0
