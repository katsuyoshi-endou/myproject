echo off

cd /d %~dp0
SET EXE_PATH= %CD%

call .\TASKS\01_STOP_J2EE-WEB\stop_j2ee-web.bat

cd %EXE_PATH%

call .\TASKS\02_START_J2EE-WEB\start_j2ee-web.bat

pause
