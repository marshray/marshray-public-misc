set regkey_base=hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options&rem

set regkey_exe=RzWizard.exe&rem
reg query "%regkey_base%\%regkey_exe%"
reg add "%regkey_base%\%regkey_exe%" /v Debugger /d "%systemroot%\system32\cmd.exe /k echo blocked" /f

set regkey_exe=RzWizardService.exe&rem
reg query "%regkey_base%\%regkey_exe%"
reg add "%regkey_base%\%regkey_exe%" /v Debugger /d "%systemroot%\system32\cmd.exe /k echo blocked" /f
