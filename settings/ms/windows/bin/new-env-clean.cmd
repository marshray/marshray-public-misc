@echo off
setlocal EnableDelayedExpansion EnableExtensions
set "ERRORLEVEL="
echo vvvvvvvvvvvvvvv %~nx0 vvvvvvvvvvvvvvv

for %%F in (%0) do set "this_script_dir=%%~dpF"
set "this_script_dir=%this_script_dir:~0,-1%"
rem echo this_script_dir="%this_script_dir%"
for %%F in (%0) do set "this_script_fn=%%~nxF"
rem echo this_script_fn="%this_script_fn%"

set "append_env_10_clean_cmd=%this_script_dir%\append-env-10-clean.cmd"
if not exist "%append_env_10_clean_cmd%" (
    echo Expecting file: "%append_env_10_clean_cmd%"
    exit /b 1
)

set Path=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem

echo Path=%Path%

echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ %~nx0 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
endlocal& ^
set "append_env_10_clean_cmd=%append_env_10_clean_cmd%"& ^
set "Path=%Path%"& ^
rem

call "%append_env_10_clean_cmd%"
(set append_env_10_clean_cmd=)

%*
