::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDNEcCCNP363A7sI+9TZ2uSLrU4WGvppLMHNivrebrFduBW2INh9mFtWiMMNMBlNcB6kbQR6rHZH1g==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal enabledelayedexpansion

if "%~1"=="" goto HELP
if /i "%~1"=="help" goto HELP
if /i "%~1"=="unlock" goto UNLOCK
if /i "%~1"=="lock" goto LOCK
if /i "%~1"=="status" goto STATUS
if /i "%~1"=="reboot" goto REBOOT_ADB
if /i "%~1"=="fastboot" goto REBOOT_FASTBOOT

echo usage: bunlock ^<command^>
echo.
echo commands:
echo   lock                                 Locks the device
echo   unlock                               Unlocks the device
echo   status                               Shows bootloader status
echo   reboot [bootloader] [recovery]       Reboot the device, optionally enter the bootloader or recovery
echo   help                                 Show this help message
exit /b


:UNLOCK
title BUnlock Bootloader Unlock Interactive
cls
net session >nul 2>&1

if %errorlevel% neq 0 (
    echo To run this script you must run it as administrator.
    pause
    exit /b
)

echo ==============================================
echo    Android BUnlock Bootloader Unlock Wizard
echo ==============================================
echo.

:U_STEP1
echo 1. Checking if the device is connected...
echo If you are asked whether you want to allow USB debugging, say allow.
adb devices
set /p choice="Is your device visible? (Y/N): "
if /I "%choice%"=="Y" goto U_STEP2
if /I "%choice%"=="N" goto U_STEP1
echo Please enter Y or N
goto U_STEP1

:U_STEP2
echo.
echo 2. Checking android version...
for /f "delims=" %%i in ('adb shell getprop ro.build.version.release 2^>nul') do set android_version=%%i
if "%android_version%"=="" set android_version=0
echo Your android version is: %android_version%

for /f "tokens=1 delims=." %%a in ("%android_version%") do set major_version=%%a
if "%major_version%"=="" set major_version=0

if %major_version% LSS 5 (
    echo.
    color 0C
    echo This script cannot unlock the bootloader on Android 1-4. Please use software like SP Flash Tool or Odin.
    color 07
    pause
    exit /b
)

color 0A
echo You are using Android %major_version%. You can start unlocking the bootloader.
color 07

:U_STEP3
echo.
echo 3. The phone reboots into fastboot mode...
adb reboot bootloader
timeout /t 5
set /p choice="Did you reboot the phone in fastboot mode? (Y/N): "
if /I "%choice%"=="Y" goto U_STEP4
if /I "%choice%"=="N" goto U_STEP3
echo Please enter Y or N
goto U_STEP3

:U_STEP4
echo.
echo 4. Checking device list with fastboot...
fastboot devices
set /p choice="Is your device visible? (Y/N): "
if /I "%choice%"=="Y" goto U_STEP5
if /I "%choice%"=="N" goto U_STEP4
echo Please enter Y or N
goto U_STEP4

:U_STEP5
echo.
echo 5. Bootloader unlocking process is starting...
if %major_version% GEQ 9 (
    fastboot flashing unlock
    echo (Select Yes in the warning on the device)
) else (
    fastboot oem unlock
    echo (Select Yes in the warning on the device)
)
set /p choice="Did you accept the warning? (Y/N): "
if /I "%choice%"=="Y" goto U_STEP6
if /I "%choice%"=="N" goto U_STEP5
echo Please enter Y or N
goto U_STEP5

:U_STEP6
echo.
echo 6. Checking bootloader status...
fastboot getvar unlocked
set /p choice="Output unlocked: yes? (Y/N): "
if /I "%choice%"=="Y" goto U_END
if /I "%choice%"=="N" goto U_STEP6
echo Please enter Y or N
goto U_STEP6

:U_END
echo.
color 0A
echo ==============================
echo        PROCESS COMPLETED
echo ==============================
color 07
echo.
echo The process is complete. What do you want to do now?
echo [S] Android Shell
echo [E] Exit From Wizard
echo [R] Reboot The Phone
echo [L] Lock Bootloader
choice /c SERL /n
if errorlevel 4 goto LOCK
if errorlevel 3 (
    echo Rebooting your phone...
    fastboot reboot
    echo Rebooted your phone.
    pause
    exit /b
)
if errorlevel 2 (
    echo Exiting...
    pause
    exit /b
)
if errorlevel 1 (
    adb shell
    pause
    exit /b
)
exit /b


:LOCK
title BUnlock Bootloader Lock Interactive
cls
net session >nul 2>&1

if %errorlevel% neq 0 (
    echo To run this script you must run it as administrator.
    pause
    exit /b
)
echo ==============================================
echo    Android BUnlock Bootloader Lock Wizard
echo ==============================================
echo.

:L_STEP1
echo 1. Checking if the device is connected...
echo If you are asked whether you want to allow USB debugging, say allow.
adb devices
set /p choice="Is your device visible? (Y/N): "
if /I "%choice%"=="Y" goto L_STEP2
if /I "%choice%"=="N" goto L_STEP1
echo Please enter Y or N
goto L_STEP1

:L_STEP2
echo.
echo 2. Checking android version...
for /f "delims=" %%i in ('adb shell getprop ro.build.version.release 2^>nul') do set android_version=%%i
if "%android_version%"=="" set android_version=0
echo Your android version is: %android_version%

for /f "tokens=1 delims=." %%a in ("%android_version%") do set major_version=%%a
if "%major_version%"=="" set major_version=0

if %major_version% LSS 5 (
    echo.
    color 0C
    echo This script cannot lock the bootloader on Android 1-4. Please use software like SP Flash Tool or Odin.
    color 07
    pause
    exit /b
)
color 0A
echo You are using Android %major_version%. You can start locking the bootloader.
color 07

:L_STEP3
echo.
echo 3. The phone reboots into fastboot mode...
adb reboot bootloader
timeout /t 5
set /p choice="Did you reboot the phone in fastboot mode? (Y/N): "
if /I "%choice%"=="Y" goto L_STEP4
if /I "%choice%"=="N" goto L_STEP3
echo Please enter Y or N
goto L_STEP3

:L_STEP4
echo.
echo 4. Checking device list with fastboot...
fastboot devices
set /p choice="Is your device visible? (Y/N): "
if /I "%choice%"=="Y" goto L_STEP5
if /I "%choice%"=="N" goto L_STEP4
echo Please enter Y or N
goto L_STEP4

:L_STEP5
echo.
echo 5. Bootloader locking process is starting...
if %major_version% GEQ 9 (
    fastboot flashing lock
    echo (Select Yes in the warning on the device)
) else (
    fastboot oem lock
    echo (Select Yes in the warning on the device)
)
set /p choice="Did you accept the warning? (Y/N): "
if /I "%choice%"=="Y" goto L_STEP6
if /I "%choice%"=="N" goto L_STEP5
echo Please enter Y or N
goto L_STEP5

:L_STEP6
echo.
echo 6. Checking bootloader status...
fastboot getvar unlocked
set /p choice="Output unlocked: no? (Y/N): "
if /I "%choice%"=="Y" goto L_END
if /I "%choice%"=="N" goto L_STEP6
echo Please enter Y or N
goto L_STEP6

:L_END
echo.
color 0A
echo ==============================
echo        PROCESS COMPLETED
echo ==============================
color 07
echo.
echo The process is complete. What do you want to do now?
echo [S] Android Shell
echo [E] Exit From Wizard
echo [R] Reboot The Phone
echo [U] Unlock Bootloader
choice /c SERU /n
if errorlevel 4 goto UNLOCK
if errorlevel 3 (
    echo Rebooting your phone...
    fastboot reboot
    echo Rebooted your phone.
    pause
    exit /b
)
if errorlevel 2 (
    echo Exiting...
    pause
    exit /b
)
if errorlevel 1 (
    adb shell
    pause
    exit /b
)
exit /b


:STATUS
set /p choice="You may need to run this script as administrator. Will you continue? (Y/N): "
if /I "%choice%"=="Y" continue
if /I "%choice%"=="N" exit /b
for /f "delims=" %%i in ('adb shell getprop ro.boot.flash.locked 2^>nul') do set blstatus=%%i
if "%blstatus%"=="0" (
    color 0A
    echo Bootloader Status: Unlocked
    color 07
    pause
    exit /b
) else (
    if "%blstatus%"=="1" (
        color 0C
        echo Bootloader Status: Locked
        color 07
        pause
        exit /b
    ) else (
        color 0E
        echo Failed to check bootloader status. Please connect your device if you haven't already.
        color 07
        pause
        exit /b
    )
)


:REBOOT_ADB
net session >nul 2>&1

if %errorlevel% neq 0 (
    echo To run this script you must run it as administrator.
    pause
    exit /b
)
if "%~2"=="" (
    echo Rebooting device normally (adb reboot)...
    adb reboot
    exit /b
)
if /i "%~2"=="bootloader" (
    echo Rebooting device into bootloader (adb reboot bootloader)...
    adb reboot bootloader
    exit /b
)
if /i "%~2"=="recovery" (
    echo Rebooting device into recovery (adb reboot recovery)...
    adb reboot recovery
    exit /b
)
echo Invalid option: %~2
exit /b


:REBOOT_FASTBOOT
net session >nul 2>&1

if %errorlevel% neq 0 (
    echo To run this script you must run it as administrator.
    pause
    exit /b
)
if /i "%~2"=="reboot" (
    if "%~3"=="" (
        echo Rebooting device (fastboot reboot)...
        fastboot reboot
        exit /b
    )
    if /i "%~3"=="bootloader" (
        echo Rebooting device into bootloader (fastboot reboot bootloader)...
        fastboot reboot bootloader
        exit /b
    )
    if /i "%~3"=="recovery" (
        echo Rebooting device into recovery (fastboot reboot recovery)...
        fastboot reboot recovery
        exit /b
    )
    echo Invalid option: %~3
    exit /b
) else (
    echo Usage: bunlock fastboot reboot [bootloader^|recovery]
    exit /b
)


:HELP
echo usage: bunlock ^<command^>
echo.
echo commands:
echo   lock                                 Locks the device
echo   unlock                               Unlocks the device
echo   status                               Shows bootloader status
echo   reboot [bootloader] [recovery]       Reboot the device, optionally enter the bootloader or recovery
echo   help                                 Show this help message
exit /b