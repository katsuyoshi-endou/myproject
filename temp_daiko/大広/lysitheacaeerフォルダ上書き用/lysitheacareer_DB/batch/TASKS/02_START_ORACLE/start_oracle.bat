Rem ******************************************************************
Rem *  �����T�v  �FDB�ċN����̃T�[�r�X�N��                 *
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
Set BATCH_ID=start_oracle

REM ���O�t�@�C����
Set BATCH_LOG_PATH=C:\lysitheacareer\Batch\TASKS\04_START_ORACLE\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

Echo ***** Oracle�N���o�b�` START ***** > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%


Rem ******************************************************************
Rem *  �T�[�r�X�N��
Rem ******************************************************************
Echo "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET START "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET START "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

Rem ******************************************************************
Rem *  �I������
Rem ******************************************************************
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo ***** Oracle�N���o�b�` END   ***** >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

EXIT /B 0
