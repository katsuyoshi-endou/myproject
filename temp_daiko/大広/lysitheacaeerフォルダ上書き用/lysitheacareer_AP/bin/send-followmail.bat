@echo off
rem All Rights Reserved. Copyright 2003-2019, Hitachi Systems & Services, Ltd.

REM *** タイトルバー表示 ***
TITLE *** フォローメール送信（send-followmail.bat） ***

ECHO フォローメール送信処理を開始します・・・

REM *** バッチ使用環境変数登録 ***

REM 環境により変更が必要な設定 ------------------- ここから

REM Application設定パス
set CAREER_HOME=C:\lysitheacareer
set CLIENT_JAR_DIR=%CAREER_HOME%\bin\lib-cosmi

REM JARのパスを指定
set LOG4J_JAR=%CAREER_HOME%\lib\log4j-1.2.7.jar
set CAREER_UTIL_JAR=%CAREER_HOME%\lib\career-util.jar
set VELOCITY_JAR=%CAREER_HOME%\lib\velocity-1.3.1.jar;%CAREER_HOME%\lib\velocity-dep-1.3.1.jar
set BATCH_APP_JAR=%CAREER_HOME%\lib\send-followmail.jar

REM プロパティファイル配置ディレクトリ
set PROPERTY_DIR=%CAREER_HOME%\properties

REM batch_system.propertyファイルの設定
set BATCH_SYSTEMPROPERTY=%PROPERTY_DIR%\batch_system.properties

REM バッチログの出力ディレクトリ
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\followmail

REM JDKホームディレクトリ
set PRF_HOME=%COSMINEXUS_HOME%\PRF
set JDK_HOME=%COSMINEXUS_HOME%
set JAVA_HOME=%COSMINEXUS_HOME%\jdk
set PATH=%PRF_HOME%\bin;%TPB_HOME%\bin;%JAVA_HOME%\bin;%PATH%

REM アプリケーションのアドレス
set AP_ADDRESS=corbaname::localhost:900

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

REM ※プロパティファイルを読み込む処理を実装していない為、bat側で設定
set PROPS=-Djava.naming.factory.initial=com.hitachi.software.ejb.jndi.InsContextFactory
set PROPS=%PROPS% -Djava.naming.provider.url=%AP_ADDRESS%
set PROPS=%PROPS% -Dejbserver.jndi.cache=off
set PROPS=%PROPS% -Ddedicated.connection=true

REM Javaコマンド設定
set JAVA_COMMAND=%COSMINEXUS_HOME%\TPB\bin\vbj

REM "*** フォローメール送信処理実行 ***"
%JAVA_COMMAND% -VBJclasspath %CLASSPATH% %PROPS% jp.co.hisas.career.batch.learning.sendfollowmail.main.FollowMailSender %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\followmail_Console.log
