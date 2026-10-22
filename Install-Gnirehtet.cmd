
@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Gnirehtet Automated Installer
color 0A

REM ==========================================================
REM GNIREHTET REVERSE TETHERING - CMD ONLY
REM Windows 10/11 x64
REM Install ADB, download Gnirehtet, verify SHA256,
REM install Android APK, and start reverse tethering.
REM ==========================================================

set "BASE=C:\ReverseUSB"
set "ADB_DIR=%BASE%\platform-tools"
set "GN_DIR=%BASE%\gnirehtet-rust-win64"
set "ADB_ZIP=%BASE%\platform-tools.zip"
set "GN_ZIP=%BASE%\gnirehtet-rust-win64-v2.5.1.zip"

set "ADB=%ADB_DIR%\adb.exe"
set "GN_EXE=%GN_DIR%\gnirehtet.exe"
set "GN_APK=%GN_DIR%\gnirehtet.apk"
set "GN_RUN=%GN_DIR%\gnirehtet-run.cmd"

set "ADB_URL=https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
set "GN_URL=https://github.com/Genymobile/gnirehtet/releases/download/v2.5.1/gnirehtet-rust-win64-v2.5.1.zip"
set "GN_SHA=7f5b1063e7895182aa60def1437e50363c3758144088dcd079037bb7c3c46a1c"

echo.
echo ==========================================================
echo             GNIREHTET AUTOMATED INSTALLER
echo ==========================================================
echo.

REM Check administrator access is not mandatory for all steps.
REM Create working directory.
if not exist "%BASE%\" md "%BASE%" 2>nul
if not exist "%BASE%\" (
    echo [ERROR] Cannot create %BASE%.
    goto :FAIL
)

REM Check required CMD utilities.
where.exe certutil.exe >nul 2>&1
if errorlevel 1 (
    echo [ERROR] certutil.exe is unavailable.
    goto :FAIL
)

REM Find ZIP extractor: Windows TAR or 7-Zip.
set "EXTRACTOR="

if exist "%SystemRoot%\System32\tar.exe" set "EXTRACTOR=TAR"

if not defined EXTRACTOR if exist "%ProgramFiles%\7-Zip\7z.exe" set "EXTRACTOR=%ProgramFiles%\7-Zip\7z.exe"
if not defined EXTRACTOR if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" set "EXTRACTOR=%ProgramFiles(x86)%\7-Zip\7z.exe"
if not defined EXTRACTOR if defined ProgramW6432 if exist "%ProgramW6432%\7-Zip\7z.exe" set "EXTRACTOR=%ProgramW6432%\7-Zip\7z.exe"

if not defined EXTRACTOR (
    echo [ERROR] ZIP extractor not found.
    echo Install 7-Zip or use Windows with tar.exe.
    goto :FAIL
)

REM ==========================================================
REM STEP 1 - DOWNLOAD AND EXTRACT ADB
REM ==========================================================
echo [1/7] Checking Android Platform Tools...

if not exist "%ADB%" (
    call :DOWNLOAD "%ADB_URL%" "%ADB_ZIP%"
    if errorlevel 1 goto :FAIL

    call :EXTRACT "%ADB_ZIP%" "%BASE%"
    if errorlevel 1 goto :FAIL
)

if not exist "%ADB%" (
    echo [ERROR] adb.exe not found.
    goto :FAIL
)

if not exist "%ADB_DIR%\AdbWinApi.dll" (
    echo [ERROR] AdbWinApi.dll not found.
    goto :FAIL
)

if not exist "%ADB_DIR%\AdbWinUsbApi.dll" (
    echo [ERROR] AdbWinUsbApi.dll not found.
    goto :FAIL
)

REM ==========================================================
REM STEP 2 - DOWNLOAD GNIREHTET
REM ==========================================================
echo.
echo [2/7] Checking Gnirehtet v2.5.1...

if not exist "%GN_EXE%" (
    call :DOWNLOAD "%GN_URL%" "%GN_ZIP%"
    if errorlevel 1 goto :FAIL
)

if exist "%GN_ZIP%" (
    echo Verifying official SHA-256...

    set "ACTUAL_SHA="

    for /f "skip=1 tokens=*" %%H in ('certutil -hashfile "%GN_ZIP%" SHA256 2^>nul') do (
        if not defined ACTUAL_SHA set "ACTUAL_SHA=%%H"
    )

    set "ACTUAL_SHA=!ACTUAL_SHA: =!"

    if not defined ACTUAL_SHA (
        echo [ERROR] Could not calculate archive hash.
        goto :FAIL
    )

    if /i not "!ACTUAL_SHA!"=="%GN_SHA%" (
        echo [ERROR] SHA-256 verification failed.
        echo The downloaded archive may be corrupted.
        del /q "%GN_ZIP%" 2>nul
        goto :FAIL
    )

    echo SHA-256 verification passed.

    if not exist "%GN_EXE%" (
        if not exist "%GN_DIR%\" md "%GN_DIR%" 2>nul

        call :EXTRACT "%GN_ZIP%" "%GN_DIR%"
        if errorlevel 1 goto :FAIL
    )
)

REM ==========================================================
REM STEP 3 - CHECK GNIREHTET FILES
REM ==========================================================
echo.
echo [3/7] Validating Gnirehtet files...

if not exist "%GN_EXE%" (
    echo [ERROR] gnirehtet.exe not found.
    goto :FAIL
)

if not exist "%GN_APK%" (
    echo [ERROR] gnirehtet.apk not found.
    goto :FAIL
)

if not exist "%GN_RUN%" (
    echo [ERROR] gnirehtet-run.cmd not found.
    goto :FAIL
)

set "PATH=%ADB_DIR%;%GN_DIR%;%PATH%"

REM ==========================================================
REM STEP 4 - START ADB AND CHECK PHONE
REM ==========================================================
echo.
echo [4/7] Starting ADB...

"%ADB%" start-server
if errorlevel 1 (
    echo [ERROR] Failed to start ADB.
    goto :FAIL
)

echo.
echo Connected devices:
"%ADB%" devices

echo.
echo Confirm on your Android phone:
echo - USB debugging is enabled.
echo - USB data cable is connected.
echo - The ADB authorization prompt is accepted.
echo.
pause

set "DEVICE="
set /a DEVICE_COUNT=0

for /f "tokens=1,2" %%A in ('"%ADB%" devices') do (
    if "%%B"=="device" (
        set /a DEVICE_COUNT+=1
        set "DEVICE=%%A"
    )
)

if "!DEVICE_COUNT!"=="0" (
    echo [ERROR] No authorized ADB device found.
    goto :FAIL
)

if not "!DEVICE_COUNT!"=="1" (
    echo [ERROR] More than one authorized device detected.
    echo Disconnect other Android devices and retry.
    goto :FAIL
)

echo Selected device: !DEVICE!

REM ==========================================================
REM STEP 5 - INSTALL APK
REM ==========================================================
echo.
echo [5/7] Installing Gnirehtet APK...

"%ADB%" -s "!DEVICE!" install -r "%GN_APK%"
if errorlevel 1 (
    echo [ERROR] APK installation failed.
    goto :FAIL
)

REM ==========================================================
REM STEP 6 - VERIFY PACKAGE
REM ==========================================================
echo.
echo [6/7] Verifying Android package...

set "PKG_RESULT="
for /f "delims=" %%P in ('"%ADB%" -s "!DEVICE!" shell pm path com.genymobile.gnirehtet 2^>nul') do (
    set "PKG_RESULT=%%P"
)

if not defined PKG_RESULT (
    echo [ERROR] Gnirehtet package verification failed.
    goto :FAIL
)

echo !PKG_RESULT!

REM ==========================================================
REM STEP 7 - RUN GNIREHTET
REM ==========================================================
echo.
echo [7/7] Starting reverse tethering...
echo.
echo Approve the VPN connection request on your phone.
echo Keep this CMD window open while using the connection.
echo Press Ctrl+C to stop.
echo.

cd /d "%GN_DIR%"
call "%GN_RUN%"

echo.
echo Gnirehtet has stopped or disconnected.
echo Run this script again to reconnect.
pause
exit /b 0

REM ==========================================================
REM SUBROUTINE: DOWNLOAD
REM ==========================================================
:DOWNLOAD
set "DL_URL=%~1"
set "DL_OUT=%~2"

if exist "%DL_OUT%" del /q "%DL_OUT%" 2>nul

echo Downloading %DL_OUT% ...

where.exe curl.exe >nul 2>&1
if not errorlevel 1 (
    curl.exe -fL --retry 2 --connect-timeout 20 "%DL_URL%" -o "%DL_OUT%"
    if not errorlevel 1 if exist "%DL_OUT%" exit /b 0
)

if exist "%DL_OUT%" del /q "%DL_OUT%" 2>nul

where.exe bitsadmin.exe >nul 2>&1
if not errorlevel 1 (
    bitsadmin.exe /transfer GnirehtetDownload /download /priority normal "%DL_URL%" "%DL_OUT%" >nul 2>&1
    if not errorlevel 1 if exist "%DL_OUT%" exit /b 0
)

echo [ERROR] Download failed.
echo Check internet access, TLS support, proxy, and firewall.
exit /b 1

REM ==========================================================
REM SUBROUTINE: EXTRACT ZIP
REM ==========================================================
:EXTRACT
set "ARCHIVE=%~1"
set "DEST=%~2"

if not exist "%ARCHIVE%" (
    echo [ERROR] Archive not found: %ARCHIVE%
    exit /b 1
)

if not exist "%DEST%\" md "%DEST%" 2>nul

if /i "%EXTRACTOR%"=="TAR" (
    tar.exe -xf "%ARCHIVE%" -C "%DEST%"
    if errorlevel 1 (
        echo [ERROR] TAR extraction failed.
        exit /b 1
    )
) else (
    "%EXTRACTOR%" x -y "-o%DEST%" "%ARCHIVE%"
    if errorlevel 1 (
        echo [ERROR] 7-Zip extraction failed.
        exit /b 1
    )
)

exit /b 0

REM ==========================================================
REM ERROR HANDLER
REM ==========================================================
:FAIL
echo.
echo ==========================================================
echo INSTALLATION OR CONNECTION FAILED
echo Review the error message above before retrying.
echo ==========================================================
echo.
pause
exit /b 1
