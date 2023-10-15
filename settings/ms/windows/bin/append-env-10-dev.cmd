@echo off
set "ERRORLEVEL="
echo vvvvvvvvvvvvvvv %~nx0 vvvvvvvvvvvvvvv

for %%F in (%0) do set "this_script_dir=%%~dpF"
set "this_script_dir=%this_script_dir:~0,-1%"
rem echo this_script_dir="%this_script_dir%"
for %%F in (%0) do set "this_script_fn=%%~nxF"
rem echo this_script_fn="%this_script_fn%"

echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ %~nx0 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

set "append_env_10_clean_cmd=%this_script_dir%\append-env-10-clean.cmd"
if not exist "%append_env_10_clean_cmd%" (
    echo Expecting file: "%append_env_10_clean_cmd%"
    exit /b 1
)

call "%append_env_10_clean_cmd%"
set "append_env_10_clean_cmd="

set "od_append_env_25_dev_cmd=%od_computer_bin%\append-env-25-dev.cmd"
if not exist "%od_append_env_25_dev_cmd%" (
    echo Expecting file: "%od_append_env_25_dev_cmd%"
    exit /b 1
)

call "%od_append_env_25_dev_cmd%"
set "od_append_env_25_dev_cmd="
