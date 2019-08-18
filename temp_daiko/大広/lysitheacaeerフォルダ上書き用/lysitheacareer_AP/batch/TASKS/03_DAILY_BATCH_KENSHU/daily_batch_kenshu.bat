@ECHO ON

rem ======================================================================
rem  日次バッチ(研修)バッチ
rem ======================================================================
title 日次バッチ(研修)バッチ

rem ---------------------
rem バッチ設定
rem ---------------------
Set TASKS_BATCH_HOME=%~dp0
Set BATCH_PARENT_PATH="C:\lysitheacareer\bin"
CD /D %TASKS_BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%
Set TASKS_LOG_NAME=daily_batch_kenshu
Set RET_ERRORLEVEL=0

rem logフォルダの存在チェック
if not exist %TASKS_BATCH_HOME%\log (
goto error_exit
)

rem ログファイル設定
Set logname_dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set logname_tm=%time: =0%
Set logname_ts=%logname_tm:~0,2%%logname_tm:~3,2%%logname_tm:~6,2%
Set TASKS_LOG_NAME=%TASKS_LOG_NAME%_%logname_dt%_%logname_ts%.log

call :getdts
echo [%dt_s%_%ts_c%]:処理を開始します。 >> %TASKS_BATCH_HOME%log\%TASKS_LOG_NAME%

rem ------------------------------------
rem 本処理
rem ------------------------------------


rem ------------------------------------
rem 日次バッチ(研修)
rem ------------------------------------


rem ------------------------------------
rem 本処理
rem ------------------------------------


rem ------------------------------------
rem 状態遷移バッチ
rem ------------------------------------
call %BATCH_PARENT_PATH%\jyotaiSeni.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem 承認者未承認蓄積通知メール送信バッチ
rem ------------------------------------
call %BATCH_PARENT_PATH%\sendSyoninsyaMisyouninChikusekiMail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem 管理者未処理蓄積通知メール送信バッチ
rem ------------------------------------
call %BATCH_PARENT_PATH%\sendKanrisyaMisyoriChikusekiMail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem 受講直前フォローメールバッチ
rem ------------------------------------
call %BATCH_PARENT_PATH%\send-followmail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem 研修後フォローメールバッチ
rem ------------------------------------
call %BATCH_PARENT_PATH%\sendKensyugoFollowMail.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem 研修歴移行バッチ
rem ------------------------------------
call %BATCH_PARENT_PATH%\kensyurekiIko.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem 研修データ削除バッチ
rem ------------------------------------
call %BATCH_PARENT_PATH%\kensyuDataSakujyo.bat
if %ERRORLEVEL% == 8 (
set RET_ERRORLEVEL=8
)

rem ------------------------------------
rem 開講通知バッチ
rem ------------------------------------
rem call %BATCH_PARENT_PATH%\sendKaikoTuchiMail.bat
rem if %ERRORLEVEL% == 8 (
rem set RET_ERRORLEVEL=8
rem )

rem ---------------------
rem 実行結果を確認
rem ---------------------
if %RET_ERRORLEVEL% == 0 (
goto normal_exit
)
if %RET_ERRORLEVEL% == 8 (
goto error_exit
)

rem ---------------------
rem 正常終了
rem ---------------------
:normal_exit
call :getdts
echo [%dt_s%_%ts_c%]:処理が正常終了しました。 >> %TASKS_BATCH_HOME%log\%TASKS_LOG_NAME%

exit /B 0

rem ---------------------
rem 異常終了
rem ---------------------
:error_exit
call :getdts
echo [%dt_s%_%ts_c%]:処理が異常終了しました。 >> %TASKS_BATCH_HOME%log\%TASKS_LOG_NAME%

exit /B 8

rem ---------------------
rem 実行時刻の取得
rem ---------------------
:getdts
Set dt_s=%date:~-10,4%/%date:~-5,2%/%date:~-2,2%
Set tm=%time: =0%
Set ts_c=%tm:~0,2%:%tm:~3,2%:%tm:~6,2%
exit /b

