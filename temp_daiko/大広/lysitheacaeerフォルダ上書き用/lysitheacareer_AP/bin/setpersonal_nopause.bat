@echo off
REM *** タイトルバー表示 ***
TITLE *** パーソナル情報登録（setpersonal.bat） ***

ECHO パーソナル情報登録処理を開始します・・・

REM Application設定パス
set CAREER_HOME=C:\lysitheacareer
set CLIENT_JAR_DIR=%CAREER_HOME%\bin\lib-cosmi

REM JARのパスを指定
set LOG4J_JAR=%CAREER_HOME%\lib\log4j-1.2.7.jar
set CAREER_UTIL_JAR=%CAREER_HOME%\lib\career-util.jar
set VELOCITY_JAR=%CAREER_HOME%\lib\velocity-1.3.1.jar;%CAREER_HOME%\lib\velocity-dep-1.3.1.jar
set BATCH_APP_JAR=%CAREER_HOME%\lib\import-personal.jar

REM プロパティファイル配置ディレクトリ
set PROPERTY_DIR=%CAREER_HOME%\properties

REM batch_system.propertyファイルの設定
set BATCH_SYSTEMPROPERTY=%PROPERTY_DIR%\batch_system.properties

REM バッチログの出力ディレクトリ
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\setpersonal

REM JDKホームディレクトリ
set PRF_HOME=%COSMINEXUS_HOME%\PRF
set JDK_HOME=%COSMINEXUS_HOME%
set JAVA_HOME=%COSMINEXUS_HOME%\jdk
set PATH=%PRF_HOME%\bin;%TPB_HOME%\bin;%JAVA_HOME%\bin;%PATH%

REM 環境により変更が必要な設定 ------------------- ここまで

rem CosminexusAP
set EJB_JAR=%CLIENT_JAR_DIR%\stubs.jar
set EJB_JAR=%EJB_JAR%;%CLIENT_JAR_DIR%\1.jar
set EJB_JAR=%EJB_JAR%;%CLIENT_JAR_DIR%\2.jar
set EJB_JAR=%EJB_JAR%;%CLIENT_JAR_DIR%\3.jar
set EJB_JAR=%EJB_JAR%;%CLIENT_JAR_DIR%\4.jar
set EJB_JAR=%EJB_JAR%;%CLIENT_JAR_DIR%\5.jar
set EJB_JAR=%EJB_JAR%;%CLIENT_JAR_DIR%\6.jar

set VBJORB=%COSMINEXUS_HOME%\TPB\lib\vbjorb.jar
set VBSEC=%COSMINEXUS_HOME%\TPB\lib\vbsec.jar
set CPRF=%COSMINEXUS_HOME%\PRF\lib\cprf.jar
set HNTRLIBMJ=%Program Files (x86)%\Hitachi\HNTRLib2\classes\hntrlibMj.jar
set HITJ2EE=%COSMINEXUS_HOME%\CC\lib\hitj2ee.jar
set HIEJBCLIENTSTATIC=%COSMINEXUS_HOME%\CC\client\lib\HiEJBClientStatic.jar
set COSMI_JAR=%VBJORB%;%VBSEC%;%CPRF%;%HNTRLIBMJ%;%HITJ2EE%;%HIEJBCLIENTSTATIC%

REM クラスパス指定
set CLASSPATH=%BATCH_APP_JAR%;%LOG4J_JAR%;%CAREER_UTIL_JAR%;%VELOCITY_JAR%;%PROPERTY_DIR%;%EJB_JAR%
set CLASSPATH=%CLASSPATH%;%COSMI_JAR%

REM 引数パラメータ
set INPUT_FILE_PATH=%CAREER_HOME%\setpersonal\personal.csv
set LOG_FILE_PATH1=%OUT_LOG_DIR%\setpersonal.csv

REM Javaコマンド設定
set JAVA_COMMAND=%COSMINEXUS_HOME%\TPB\bin\vbj

REM "*** パーソナル情報登録処理実行 ***"
%JAVA_COMMAND% -VBJclasspath %CLASSPATH% jp.co.hisas.addon.batch.import_personal.import_personal.ImportPersonal %INPUT_FILE_PATH% %LOG_FILE_PATH1% %BATCH_SYSTEMPROPERTY%

ECHO パーソナル情報登録処理が終了しました・・・

