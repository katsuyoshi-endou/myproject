@ECHO OFF

REM HOME�ݒ�
SET BATCH_HOME=%~dp0
CD /D %BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%

rem ======================================================================
rem  Cosminexus �_���T�[�o��~�o�b�`
rem ======================================================================

title Cosminexus �_���T�[�o��~�o�b�`

rem ---------------------
REM �o�b�`�ݒ�
rem ---------------------
rem �yAP�ڑ����z�p�X�ݒ�
Set AP_SET_PATH=C:\lysitheacareer\Batch\BatchSetting\setEnvAP.bat

rem �o�b�`ID
Set BATCH_ID=stop_j2ee-web

REM ���O�t�@�C����
Set BATCH_LOG_PATH=C:\lysitheacareer\Batch\TASKS\01_STOP_J2EE-WEB\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

rem ----------------------------------------------------------------------
rem  Cosminexus �_���T�[�o��~�o�b�`
rem ----------------------------------------------------------------------
REM log�t�H���_�̑��݃`�F�b�N
if not exist %BATCH_LOG_PATH% (
set ERRORLEVEL=8
EXIT /B %ERRORLEVEL%
)

rem �����J�n
call :getdts
echo [%dt_s%_%ts_c%][%BATCH_ID%]:WEB/AP�T�[�r�X�̒�~�������J�n���܂��B > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%


rem ---------------------
rem �K�{�t�@�C���`�F�b�N
rem ---------------------
rem �yAP�ڑ����z�֘A�擾
call :getdts
if not exist %AP_SET_PATH% (
echo [%dt_s%_%ts_c%][%BATCH_ID%]:�K�{�t�@�C�������݂��܂���B^(%AP_SET_PATH%^) >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Set RET_ERRORLEVEL=8
goto end_func
)


rem ---------------------
rem �{����
rem ---------------------
call %AP_SET_PATH%

echo �A�v���P�[�V�����̋N���E��~
%COSMI_BIN_DIR%\mngsvrutil -m %COSMI_HOST_NAME%:28080 -u %COSMI_USER% -p %COSMI_PASSWORD% -t %WEB_SVR_NAME% -s -l 300 stop server
%COSMI_BIN_DIR%\mngsvrutil -m %COSMI_HOST_NAME%:28080 -u %COSMI_USER% -p %COSMI_PASSWORD% -t %J2EE_SVR_NAME1% -s -l 300 stop server
set RET_ERRORLEVEL=%ERRORLEVEL%


rem ---------------------
rem �I������
rem ---------------------
:end_func
call :getdts
rem �I�����b�Z�[�W�o��
if %RET_ERRORLEVEL% EQU 0 ( 
echo [%dt_s%_%ts_c%][%BATCH_ID%]:WEB/AP�T�[�r�X�̒�~����������I�����܂����B >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
)

if %RET_ERRORLEVEL% EQU 8 (
echo [%dt_s%_%ts_c%][%BATCH_ID%]:WEB/AP�T�[�r�X�̒�~�������ُ�I�����܂����B >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
)

:lastexit
exit /B %RET_ERRORLEVEL%

:getdts
Set dt_s=%date:~-10,4%/%date:~-5,2%/%date:~-2,2%
Set tm=%time: =0%
Set ts_c=%tm:~0,2%:%tm:~3,2%:%tm:~6,2%
exit /b
