@echo off
setlocal EnableDelayedExpansion EnableExtensions
set "ERRORLEVEL="
echo vvvvvvvvvvvvvvv %~nx0 vvvvvvvvvvvvvvv

for %%F in (%0) do set "this_script_dir=%%~dpF"
set "this_script_dir=%this_script_dir:~0,-1%"
rem echo this_script_dir="%this_script_dir%"
for %%F in (%0) do set "this_script_fn=%%~nxF"
rem echo this_script_fn="%this_script_fn%"

set Path=%Path%;%SystemRoot%\System32\OpenSSH

set "od_computer_bin=%OneDrive%\computers\%COMPUTERNAME%\bin"
if not exist "%od_computer_bin%" "od_computer_bin="
rem echo od_computer_bin="%od_computer_bin%"

if "%od_computer_bin%" EQU "" goto :no_onedrive_computername_bin

set "od_append_env_20_clean_cmd=%od_computer_bin%\append-env-20-clean.cmd"
if not exist "%od_append_env_20_clean_cmd%" set "od_append_env_20_clean_cmd="
rem echo od_append_env_20_clean_cmd="%od_append_env_20_clean_cmd%"

:no_onedrive_computername_bin

echo od_append_env_20_clean_cmd=%od_append_env_20_clean_cmd%
echo Path=%Path%

echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ %~nx0 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
endlocal& ^
set "od_computer_bin=%od_computer_bin%"& ^
set "od_append_env_20_clean_cmd=%od_append_env_20_clean_cmd%"& ^
set Path=%Path%& ^
rem

if "%od_append_env_20_clean_cmd%" NEQ "" call "%od_append_env_20_clean_cmd%"
set "od_append_env_20_clean_cmd="

echo od_computer_bin=%od_computer_bin%
