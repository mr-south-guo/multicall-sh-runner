:::: Hardlink runner for multiple sh-scripts
::
:: See `:showHelp` section at the bottom for details.

@echo off

setlocal EnableDelayedExpansion

set "_SCRIPT_NAME=%~n0"
set "_SCRIPT_DIR=%~dp0"

:parseArg
if "%1"=="" goto :parseArgEnd

if "%1"=="-o" (
    set "optOverwrite=yes"
    shift
) else if "%1"=="-r" (
    set "RUNNER_TARGET=%2"
    shift & shift
) else if "%1"=="-s" (
    set "SH_PATTERN=%2"
    shift & shift
) else if "%1"=="-h" (
    goto :showHelp
) else (
    echo "Unknow argument: %1"
    exit /b
)
goto :parseArg
:parseArgEnd

:: Default values
if "%RUNNER_TARGET%"=="" set "RUNNER_TARGET=%_SCRIPT_DIR%sh-runner.cmd"
if "%SH_PATTERN%"=="" set "SH_PATTERN=%_SCRIPT_DIR%*.sh"
if "%optOverwrite%"=="" set "optOverwrite=no"

echo Hardlink runner
echo ===============
echo.
echo runner target : %RUNNER_TARGET%
echo sh pattern    : %SH_PATTERN%
echo overwriting   : %optOverwrite%
echo.

if not exist "%RUNNER_TARGET%" (
    echo "%RUNNER_TARGET%" does not exist. Abort.
    exit /b
)

pause
echo.

for %%I in (%SH_PATTERN%) do (
    set "skipThisItem=no"
    if not exist "%%I" (
        echo No sh-script matching "%SH_PATTERN%" is found.
        exit /b
    )
    set "RUNNER_LINK=%%~dpnI.cmd"

    if "!RUNNER_LINK!"=="%RUNNER_TARGET%" (
        echo Will not link "%RUNNER_TARGET%" to itself.
        set "skipThisItem=yes"
    )

    if exist "!RUNNER_LINK!" (
        if "%optOverwrite%"=="yes" (
            echo File exist, overwriting: "!RUNNER_LINK!"
            del "!RUNNER_LINK!"
        ) else (
            echo File exist, skipping: "!RUNNER_LINK!"
            set "skipThisItem=yes"
        )
    )

    if "!skipThisItem!"=="no" (
        mklink /h "!RUNNER_LINK!" "%RUNNER_TARGET%"
    )
)
exit /b

:showHelp
echo Usage:
echo   %_SCRIPT_NAME% -h
echo   %_SCRIPT_NAME% ^[-o^] ^[-r RUNNER_TARGET^] ^[-s SH_PATTERN^]
echo.
echo Create runners for multiple sh-scripts matching SH_PATTERN, by hardlinking from RUNNER_TARGET.
echo.
echo     RUNNER_TARGET  The runner script to link from. Default is "./sh-runner.cmd"
echo     SH_PATTERN     The pattern to match for sh-script. Default is "./*.sh"
echo.
echo OPTIONS:
echo.
echo     -o     Overwrite if the linking runner file exists.
echo     -h     Show this help.
echo.
echo Example:
echo.
echo     %_SCRIPT_NAME% -o -r x:/dir1/sh-runner.cmd -s y:/dir2/*.sh

endlocal
