echo off

cd /d %~dp0

REM ***** К¬ЛЂРЁТи START *****
SET EXE_PATH= %CD%\\scripts\\

REM РЏС±ПоХс
SET SYSTEM_USER=SYSTEM
SET SYSTEM_USER_PW=SYSTEM
SET SID=CAREER
REM SET SID=127.0.0.1:1522/CAREER
REM ***** К¬ЛЂРЁТи END *****

sqlplus %SYSTEM_USER%/%SYSTEM_USER_PW%@%SID% @%EXE_PATH%01_CreateTablespace_CAREER.sql
pause
