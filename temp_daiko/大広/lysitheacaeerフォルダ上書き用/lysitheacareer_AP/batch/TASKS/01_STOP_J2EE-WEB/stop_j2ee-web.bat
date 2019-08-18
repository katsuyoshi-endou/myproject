@ECHO OFF

REM HOME設定
SET BATCH_HOME=%~dp0
CD /D %BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%

rem ======================================================================
rem  Cosminexus 論理サーバ停止バッチ
rem ======================================================================

title Cosminexus 論理サーバ停止バッチ

rem ---------------------
REM バッチ設定
rem ---------------------
rem 【AP接続情報】パス設定
Set AP_SET_PATH=C:\lysitheacareer\Batch\BatchSetting\setEnvAP.bat

rem バッチID
Set BATCH_ID=stop_j2ee-web

REM ログファイル名
Set BATCH_LOG_PATH=C:\lysitheacareer\Batch\TASKS\01_STOP_J2EE-WEB\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

rem ----------------------------------------------------------------------
rem  Cosminexus 論理サーバ停止バッチ
rem ----------------------------------------------------------------------
REM logフォルダの存在チェック
if not exist %BATCH_LOG_PATH% (
set ERRORLEVEL=8
EXIT /B %ERRORLEVEL%
)

rem 処理開始
call :getdts
echo [%dt_s%_%ts_c%][%BATCH_ID%]:WEB/APサービスの停止処理を開始します。 > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%


rem ---------------------
rem 必須ファイルチェック
rem ---------------------
rem 【AP接続情報】関連取得
call :getdts
if not exist %AP_SET_PATH% (
echo [%dt_s%_%ts_c%][%BATCH_ID%]:必須ファイルが存在しません。^(%AP_SET_PATH%^) >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Set RET_ERRORLEVEL=8
goto end_func
)


rem ---------------------
rem 本処理
rem ---------------------
call %AP_SET_PATH%

echo アプリケーションの起動・停止
%COSMI_BIN_DIR%\mngsvrutil -m %COSMI_HOST_NAME%:28080 -u %COSMI_USER% -p %COSMI_PASSWORD% -t %WEB_SVR_NAME% -s -l 300 stop server
%COSMI_BIN_DIR%\mngsvrutil -m %COSMI_HOST_NAME%:28080 -u %COSMI_USER% -p %COSMI_PASSWORD% -t %J2EE_SVR_NAME1% -s -l 300 stop server
set RET_ERRORLEVEL=%ERRORLEVEL%


rem ---------------------
rem 終了処理
rem ---------------------
:end_func
call :getdts
rem 終了メッセージ出力
if %RET_ERRORLEVEL% EQU 0 ( 
echo [%dt_s%_%ts_c%][%BATCH_ID%]:WEB/APサービスの停止処理が正常終了しました。 >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
)

if %RET_ERRORLEVEL% EQU 8 (
echo [%dt_s%_%ts_c%][%BATCH_ID%]:WEB/APサービスの停止処理が異常終了しました。 >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
)

:lastexit
exit /B %RET_ERRORLEVEL%

:getdts
Set dt_s=%date:~-10,4%/%date:~-5,2%/%date:~-2,2%
Set tm=%time: =0%
Set ts_c=%tm:~0,2%:%tm:~3,2%:%tm:~6,2%
exit /b
