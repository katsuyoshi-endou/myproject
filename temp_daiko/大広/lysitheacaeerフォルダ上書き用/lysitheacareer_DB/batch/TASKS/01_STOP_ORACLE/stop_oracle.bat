Rem ******************************************************************
Rem *  �����T�v  �FDB�ċN���O�̃T�[�r�X��~                 *
Rem *              �T�[�r�X��~�݂̂ŁA�t�F�[���Z�[�t������          *
Rem *              Oracle��Shutdown�R�}���h�͎��s���Ȃ�              *
Rem ******************************************************************

Rem ******************************************************************
Rem *  ��������
Rem ******************************************************************
REM HOME�ݒ�
SET BATCH_HOME=%~dp0
CD /D %BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%

rem �o�b�`ID
Set BATCH_ID=stop_oracle

REM ���O�t�@�C����
Set BATCH_LOG_PATH=C:\lysitheacareer\Batch\TASKS\03_STOP_ORACLE\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

Echo ***** Oracle��~�o�b�` START ***** > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%


Rem ******************************************************************
Rem *  �T�[�r�X��~
Rem ******************************************************************
Echo "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET STOP "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET STOP "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

Rem ******************************************************************
Rem *  �I������
Rem ******************************************************************
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo ***** Oracle��~�o�b�` END   ***** >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

EXIT /B 0
