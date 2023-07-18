@echo off
@setlocal enableextensions
@cd /d "%~dp0"

echo "Processing .example files."
echo " Note that this will overwrite renamed outputs and may destroy data!"

:PROMPT
SET /P CONFIRM="Are you sure you want to continue(Y/[N])?"
IF /I "%CONFIRM%"=="Y" GOTO PROCESS
IF /I "%CONFIRM%"=="y" GOTO PROCESS
IF /I "%CONFIRM%"=="Yes" GOTO PROCESS
IF /I "%CONFIRM%"=="yes" GOTO PROCESS
IF /I "%CONFIRM%"=="YES" GOTO PROCESS
IF /I "%CONFIRM%"=="n" GOTO CANCEL
IF /I "%CONFIRM%"=="N" GOTO CANCEL
IF /I "%CONFIRM%"=="no" GOTO CANCEL
IF /I "%CONFIRM%"=="NO" GOTO CANCEL
IF /I "%CONFIRM%"=="No" GOTO CANCEL

GOTO PROMPT

:PROCESS
for %%f in (*.example) do (
    @REM move "%%f" "%%~dpf%%~nf"
    copy "%%f" "%%~nf"
    echo "Processed %%~nf..."
)

GOTO END

:END
echo "Processing complete."
endlocal
pause
exit

:CANCEL
echo "Processing Cancelled."
endlocal
exit
