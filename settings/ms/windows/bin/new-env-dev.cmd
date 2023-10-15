@echo off
setlocal EnableDelayedExpansion EnableExtensions
set "ERRORLEVEL="
echo vvvvvvvvvvvvvvv %~nx0 vvvvvvvvvvvvvvv

for %%F in (%0) do set "this_script_dir=%%~dpF"
set "this_script_dir=%this_script_dir:~0,-1%"
rem echo this_script_dir="%this_script_dir%"
for %%F in (%0) do set "this_script_fn=%%~nxF"
rem echo this_script_fn="%this_script_fn%"

set "append_env_10_dev_cmd=%this_script_dir%\append-env-10-dev.cmd"
if not exist "%append_env_10_dev_cmd%" (
    echo Expecting file: "%append_env_10_dev_cmd%"
    exit /b 1
)

set Path=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem

echo Path=%Path%

echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ %~nx0 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
endlocal& ^
set "append_env_10_dev_cmd=%append_env_10_dev_cmd%"& ^
set "Path=%Path%"& ^
rem

call "%append_env_10_dev_cmd%"
(set append_env_10_dev_cmd=)

echo CARGO_HOME=%CARGO_HOME%
echo Path=%Path%
echo RUST_BACKTRACE=%RUST_BACKTRACE%
echo RUSTUP_HOME=%RUSTUP_HOME%
echo TEMP=%TEMP%
echo TMP=%TMP%

%*
