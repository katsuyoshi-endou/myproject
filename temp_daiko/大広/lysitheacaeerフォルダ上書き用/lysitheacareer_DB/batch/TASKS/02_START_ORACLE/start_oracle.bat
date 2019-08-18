Rem ******************************************************************
Rem *  処理概要  ：DB再起動後のサービス起動                 *
Rem ******************************************************************

Rem ******************************************************************
Rem *  初期処理
Rem ******************************************************************
REM HOME設定
SET BATCH_HOME=%~dp0
CD /D %BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%

rem バッチID
Set BATCH_ID=start_oracle

REM ログファイル名
Set BATCH_LOG_PATH=C:\lysitheacareer\Batch\TASKS\04_START_ORACLE\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

Echo ***** Oracle起動バッチ START ***** > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%


Rem ******************************************************************
Rem *  サービス起動
Rem ******************************************************************
Echo "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET START "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET START "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

Rem ******************************************************************
Rem *  終了処理
Rem ******************************************************************
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo ***** Oracle起動バッチ END   ***** >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

EXIT /B 0
