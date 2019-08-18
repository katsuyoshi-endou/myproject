Rem ******************************************************************
Rem *  処理概要  ：DB再起動前のサービス停止                 *
Rem *              サービス停止のみで、フェールセーフさせる          *
Rem *              OracleのShutdownコマンドは実行しない              *
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
Set BATCH_ID=stop_oracle

REM ログファイル名
Set BATCH_LOG_PATH=C:\lysitheacareer\Batch\TASKS\03_STOP_ORACLE\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

Echo ***** Oracle停止バッチ START ***** > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%


Rem ******************************************************************
Rem *  サービス停止
Rem ******************************************************************
Echo "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET STOP "OracleOraDB12Home1TNSListenerCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
NET STOP "OracleServiceCAREER" >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

Rem ******************************************************************
Rem *  終了処理
Rem ******************************************************************
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Echo ***** Oracle停止バッチ END   ***** >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

EXIT /B 0
