echo off

cd /d %~dp0

REM ***** ���ݒ� START *****
SET EXE_PATH= %CD%\\scripts\\

REM �ڑ����
SET SYSTEM_USER=SYSTEM
SET SYSTEM_USER_PW=SYSTEM
SET SID=CAREER
REM SET SID=127.0.0.1:1522/CAREER

REM �f�B���N�g���I�u�W�F�N�g���
SET DIR_NAME= LY_DMP_DIR
SET DIR_PATH= "D:\expdmp"
REM ***** ���ݒ� END *****

IF NOT EXIST %DIR_PATH% (
  ECHO �쐬��̃f�B���N�g�������݂��܂���B: %DIR_PATH%
) ELSE (
  sqlplus %SYSTEM_USER%/%SYSTEM_USER_PW%@%SID% @%EXE_PATH%02_CreateDirectory_SYSTEM.sql %DIR_NAME% %DIR_PATH%
)

pause
