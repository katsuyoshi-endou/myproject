@echo off
REM *** タイトルバー表示 ***
TITLE *** 教育研修歴移動（kensyurekiIko.bat） ***

ECHO 教育研修歴移動処理を開始します・・・

REM *** バッチ使用環境変数登録 ***

REM Application設定パス
set LYSITHEACAREER_HOME=C:\lysitheacareer

REM バッチログの出力ディレクトリ
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\kensyurekiIko

REM ライブラリパス
set LYSITHEACAREER_LIB_DIR=%LYSITHEACAREER_HOME%\lib
set LYSITHEACAREER_BATCH_UTIL=%LYSITHEACAREER_LIB_DIR%\career-util.jar
set LYSITHEACAREER_BATCH_LOG4J=%LYSITHEACAREER_LIB_DIR%\log4j-1.2.7.jar

REM ORACLEドライバ
set ORACLE_DB_HOME=D:\app\Administrator\product\12.2.0\dbhome_1
set JDBC_PATH=%ORACLE_DB_HOME%\jdbc\lib\ojdbc8.jar

REM 研修系バッチJAR
set LYSITHEACAREER_BATCH=%LYSITHEACAREER_LIB_DIR%\learningPh1.jar

set LYSITHEACAREER_BATCH_CLASSPATH=%LYSITHEACAREER_BATCH_UTIL%;%LYSITHEACAREER_BATCH_LOG4J%;%JDBC_PATH%;%LYSITHEACAREER_BATCH%

set LYSITHEACAREER_PROP_DIR=%LYSITHEACAREER_HOME%\properties
set LYSITHEACAREER_PROP_FILE=%LYSITHEACAREER_PROP_DIR%\batch_system.properties

REM --引数設定項目----------------------

REM 移動方式
set IDO_HOUSIKI=2

REM 移動起算月
set IDO_KISAN_TUKI=1

REM 移動起算日
set IDO_KISAN_HI=366

REM ログファイルパス
set LOG_FILE_PATH=%LYSITHEACAREER_HOME%\log\batch\kensyurekiiko

REM 成績変換フラグ
set SEISEKI_HENKAN_FLG=0

REM 未修了移動フラグ
set MISYURYO_IDO_FLG=0

REM -----------------------------------
set PROPS=-DidoHousiki="%IDO_HOUSIKI%"
set PROPS=%PROPS% -DidoKisanTuki="%IDO_KISAN_TUKI%"
set PROPS=%PROPS% -DidoKisanHi="%IDO_KISAN_HI%"
set PROPS=%PROPS% -DlogFilePath="%LOG_FILE_PATH%"
set PROPS=%PROPS% -DseisekiHenkanFlg="%SEISEKI_HENKAN_FLG%"
set PROPS=%PROPS% -DmisyuryoIdoFlg="%MISYURYO_IDO_FLG%"

REM JAVAコマンド
REM JAVAコマンド
set JAVA_COMMAND="D:\Hitachi\Cosminexus\jdk\bin\java"

REM "*** 教育研修歴移動処理実行 ***"
%JAVA_COMMAND% -cp .;%LYSITHEACAREER_BATCH_CLASSPATH% %PROPS% jp.co.hisas.addon.batch.learning.kensyurekiiko.MoveTrainingHistoryBatch %LYSITHEACAREER_PROP_FILE% %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\kensyurekiIko_Console.log

ECHO 教育研修歴移動処理が終了しました・・・
