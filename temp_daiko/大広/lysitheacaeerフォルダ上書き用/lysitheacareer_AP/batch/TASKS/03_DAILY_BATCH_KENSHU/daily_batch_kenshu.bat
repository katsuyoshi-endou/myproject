@ECHO ON

rem ======================================================================
rem  �����o�b�`(���C)�o�b�`
rem ======================================================================
title �����o�b�`(���C)�o�b�`

rem ---------------------
rem �o�b�`�ݒ�
rem ---------------------
Set TASKS_BATCH_HOME=%~dp0
Set BATCH_PARENT_PATH="C:\lysitheacareer\bin"
CD /D %TASKS_BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%
Set TASKS_LOG_NAME=daily_batch_kenshu
Set RET_ERRORLEVEL=0

rem log�t�H���_�̑��݃`�F�b�N
if not exist %TASKS_BATCH_HOME%\log (
goto error_exit
)

rem ���O�t�@�C���ݒ�
Set logname_dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set logname_tm=%time: =0%
Set logname_ts=%logname_tm:~0,2%%logname_tm:~3,2%%logname_tm:~6,2%
Set TASKS_LOG_NAME=%TASKS_LOG_NAME%_%logname_dt%_%logname_ts%.log

call :getdts
echo [%dt_s%_%ts_c%]:�������J�n���܂��B >> %TASKS_BATCH_HOME%log\%TASKS_LOG_NAME%

rem ------------------------------------
rem �{����
rem ------------------------------------


rem ------------------------------------
rem �����o�b�`(���C)
rem ------------------------------------


rem ------------------------------------
rem �{����
rem ------------------------------------


rem ------------------------------------
rem ��ԑJ�ڃo�b�`
rem ------------------------------------
call %BATCH_PARENT_PATH%\jyotaiSeni.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem ���F�Җ����F�~�ϒʒm���[�����M�o�b�`
rem ------------------------------------
call %BATCH_PARENT_PATH%\sendSyoninsyaMisyouninChikusekiMail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem �Ǘ��Җ������~�ϒʒm���[�����M�o�b�`
rem ------------------------------------
call %BATCH_PARENT_PATH%\sendKanrisyaMisyoriChikusekiMail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem ��u���O�t�H���[���[���o�b�`
rem ------------------------------------
call %BATCH_PARENT_PATH%\send-followmail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem ���C��t�H���[���[���o�b�`
rem ------------------------------------
call %BATCH_PARENT_PATH%\sendKensyugoFollowMail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem ���C���ڍs�o�b�`
rem ------------------------------------
call %BATCH_PARENT_PATH%\kensyurekiIko.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem ���C�f�[�^�폜�o�b�`
rem ------------------------------------
call %BATCH_PARENT_PATH%\kensyuDataSakujyo.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem �J�u�ʒm�o�b�`
rem ------------------------------------
rem call %BATCH_PARENT_PATH%\sendKaikoTuchiMail.bat
rem if %ERRORLEVEL% == 8 (
rem set RET_ERRORLEVEL=8
rem )

rem ---------------------
rem ���s���ʂ��m�F
rem ---------------------
if %RET_ERRORLEVEL% == 0 (
goto normal_exit
)
if %RET_ERRORLEVEL% == 8 (
goto error_exit
)

rem ---------------------
rem ����I��
rem ---------------------
:normal_exit
call :getdts
echo [%dt_s%_%ts_c%]:����������I�����܂����B >> %TASKS_BATCH_HOME%log\%TASKS_LOG_NAME%

exit /B 0

rem ---------------------
rem �ُ�I��
rem ---------------------
:error_exit
call :getdts
echo [%dt_s%_%ts_c%]:�������ُ�I�����܂����B >> %TASKS_BATCH_HOME%log\%TASKS_LOG_NAME%

exit /B 8

rem ---------------------
rem ���s�����̎擾
rem ---------------------
:getdts
Set dt_s=%date:~-10,4%/%date:~-5,2%/%date:~-2,2%
Set tm=%time: =0%
Set ts_c=%tm:~0,2%:%tm:~3,2%:%tm:~6,2%
exit /b

