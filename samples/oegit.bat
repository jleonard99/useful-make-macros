@echo off
rem ...
set errorlevel=
REM start "NPP" "C:\Program Files\Notepad++\notepad++.exe" %1 %2 %3 %4 %5 %6
"C:\Program Files\Notepad++\notepad++.exe" %1 %2 %3 %4 %5 %6
exit /b %errorlevel%
