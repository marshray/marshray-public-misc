@echo off

(set backup-file=%USERPROFILE%\capslock-to-ctrl - backup.reg.txt)

echo vvvvvvvvvvvvvvvvvv "%backup-file%" vvvvvvvvvvvvvvvvvv
type "%backup-file%" 2>nul
echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ "%backup-file%" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

reg query "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" >>"%backup-file%"


echo vvvvvvvvvvvvvvvvvv current vvvvvvvvvvvvvvvvvv
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ current ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

rem *** Just make capslock another left control
rem ***     1D003A00 (caps lock 0x003A) -> (left ctrl 0x001D)
@echo on
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d ^
00000000^
00000000^
02000000^
1D003A00^
00000000 /f
@echo off

echo vvvvvvvvvvvvvvvvvv resulting vvvvvvvvvvvvvvvvvv
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ resulting ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
