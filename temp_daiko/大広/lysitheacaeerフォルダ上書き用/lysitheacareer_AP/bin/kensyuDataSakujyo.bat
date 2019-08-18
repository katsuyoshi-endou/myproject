@echo off
REM *** タイトルバー表示 ***
TITLE *** 研修系データ削除（kensyuDataSakujo.bat） ***

ECHO 研修系データ削除処理を開始します・・・

REM *** バッチ使用環境変数登録 ***

REM Application設定パス
set CAREER_HOME=C:\lysitheacareer

REM バッチログの出力ディレクトリ
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\kensyuDataSakujyo

REM ライブラリパス
set CAREER_LIB_DIR=%CAREER_HOME%\lib
set CAREER_BATCH_UTIL=%CAREER_LIB_DIR%\career-util.jar
set CAREER_BATCH_LOG4J=%CAREER_LIB_DIR%\log4j-1.2.7.jar

REM ORACLEドライバ
set ORACLE_DB_HOME=D:\app\Administrator\product\12.2.0\dbhome_1
set JDBC_PATH=%ORACLE_DB_HOME%\jdbc\lib\ojdbc8.jar

REM 研修系バッチJAR
set LYSITHEACAREER_BATCH=%CAREER_LIB_DIR%\learningPh1.jar

set LYSITHEACAREER_BATCH_CLASSPATH=%CAREER_BATCH_UTIL%;%CAREER_BATCH_LOG4J%;%JDBC_PATH%;%LYSITHEACAREER_BATCH%

set LYSITHEACAREER_PROP_DIR=%CAREER_HOME%\properties
set LYSITHEACAREER_PROP_FILE=%LYSITHEACAREER_PROP_DIR%\batch_system.properties

REM --引数設定項目----------------------

REM 削除方式
set SAKUJYO_HOUSIKI=2

REM 削除起算月
set SAKUJYO_KISAN_TUKI=A

REM 削除起算日
set SAKUJYO_KISAN_HI=396

REM ログファイルパス
set LOG_FILE_PATH=%CAREER_HOME%\log\batch\kensyusakujyo

REM 各テーブルの削除フラグ設定
set L02_SAKUJYO_FLG=1
set L12_L13_L14_SAKUJYO_FLG=1
set L17_SAKUJYO_FLG=1
set L94_SAKUJYO_FLG=1

REM -----------------------------------
set PROPS=-DsakujyoHousiki="%SAKUJYO_HOUSIKI%"
set PROPS=%PROPS% -DsakujyoKisanTuki="%SAKUJYO_KISAN_TUKI%"
set PROPS=%PROPS% -DsakujyoKisanHi="%SAKUJYO_KISAN_HI%"
set PROPS=%PROPS% -DlogFilePath="%LOG_FILE_PATH%"
set PROPS=%PROPS% -Dl02SakujyoFlg="%L02_SAKUJYO_FLG%"
set PROPS=%PROPS% -Dl12L13L14SakujyoFlg="%L12_L13_L14_SAKUJYO_FLG%"
set PROPS=%PROPS% -Dl17SakujyoFlg="%L17_SAKUJYO_FLG%"
set PROPS=%PROPS% -Dl94SakujyoFlg="%L94_SAKUJYO_FLG%"

REM JAVAコマンド
set JAVA_COMMAND="D:\Hitachi\Cosminexus\jdk\bin\java"

REM "*** 研修系データ削除処理実行 ***"
%JAVA_COMMAND% -cp .;%LYSITHEACAREER_BATCH_CLASSPATH% %PROPS% jp.co.hisas.addon.batch.learning.kensyudatasakujyo.DeleteClassBatch %LYSITHEACAREER_PROP_FILE% %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\kensyuDataSakujyo_Console.log

ECHO 研修系データ削除処理が終了しました・・・
