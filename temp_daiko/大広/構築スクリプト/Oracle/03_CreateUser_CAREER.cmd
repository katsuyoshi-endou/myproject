echo off

cd /d %~dp0

REM ***** ���ݒ� START *****
SET EXE_PATH= %CD%\\scripts\\

REM �ڑ����
SET SYSTEM_USER=SYSTEM
SET SYSTEM_USER_PW=SYSTEM
SET SID=CAREER
REM SET SID=127.0.0.1:1522/CAREER

sqlplus system/system@CAREER @%EXE_PATH%03_CreateUser_CAREER.sql

pause
