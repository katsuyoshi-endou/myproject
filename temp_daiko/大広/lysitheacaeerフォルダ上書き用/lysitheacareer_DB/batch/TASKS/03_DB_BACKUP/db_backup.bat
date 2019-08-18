ECHO ON
cd /d %~pd0
REM ##################################################
REM ﾌｧｲﾙ名	：db_backup.bat
REM 機能	：データベースEXPORT
REM               アプリケーションスキーマのダンプファイルを取得する。
REM               取得したダンプファイルは1世代分、BKフォルダに保存する。
REM 戻り値	：0：正常終了 8：異常終了
REM 外部ﾌｧｲﾙ：なし
REM 出力ﾌｧｲﾙ：あり(CAREER.DMP)
REM ##################################################
REM HOME設定
SET BATCH_HOME=%~dp0
CD /D %BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%

rem バッチID
Set BATCH_ID=db_backup

REM ログファイル名
Set BATCH_LOG_PATH=C:\lysitheacareer\batch\TASKS\03_DB_BACKUP\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

REM 接続インスタンス
Set SID=CAREER

REM ##################################################
REM パラメータ定義部
REM ##################################################

REM 【システムユーザID】
SET DB_USER_ID=system

REM 【システムユーザパスワード】
SET DB_USER_PW=system

REM 【対象スキーマのユーザ名】
REM 【CAREERスキーマ】
SET BACKUP_TARGET=CAREER

REM バックアップファイル作成先
SET DMP_FILE=C:\lysitheacareer\dmp
SET DMP_FILE_BK=C:\lysitheacareer\dmp\bk

REM バックアップファイルコピー先
SET DMP_FILE_COPY=D:\datapump

REM データパンプコマンドは同名のダンプファイルが既に存在しているとエラーとなるため移動する。
if not exist %DMP_FILE_BK%\nul mkdir %DMP_FILE_BK%
move %DMP_FILE%\*.* %DMP_FILE_BK%

REM ##################################################
REM 処理実行部
REM ##################################################
Echo ***** DBバックアップ、退避バッチ START ***** > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

EXPDP %DB_USER_ID%/%DB_USER_PW%@%SID% DIRECTORY=LY_DMP_DIR DUMPFILE=CAREER.DMP SCHEMAS=%BACKUP_TARGET% LOGFILE=%BACKUP_TARGET%.LOG

FIND /I "ORA-" %DMP_FILE%\%BACKUP_TARGET%.LOG
IF %ERRORLEVEL% == 0 (EXIT /B 8)

REM Dドライブにコピーする処理
if exist %DMP_FILE%\CAREER.DMP (
	copy %DMP_FILE%\CAREER.DMP %DMP_FILE_COPY%\CAREER.DMP
)

Echo ***** DBバックアップ、退避バッチ END ***** >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
EXIT /B 0
