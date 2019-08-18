echo off

cd /d %~dp0

REM ***** 環境設定 START *****
SET EXE_PATH= %CD%\\scripts\\

REM 接続情報
SET SYSTEM_USER=SYSTEM
SET SYSTEM_USER_PW=SYSTEM
SET SID=CAREER
REM SET SID=127.0.0.1:1522/CAREER

REM ディレクトリオブジェクト情報
SET DIR_NAME= LY_DMP_DIR
SET DIR_PATH= "D:\expdmp"
REM ***** 環境設定 END *****

IF NOT EXIST %DIR_PATH% (
  ECHO 作成先のディレクトリが存在しません。: %DIR_PATH%
) ELSE (
  sqlplus %SYSTEM_USER%/%SYSTEM_USER_PW%@%SID% @%EXE_PATH%02_CreateDirectory_SYSTEM.sql %DIR_NAME% %DIR_PATH%
)

pause
