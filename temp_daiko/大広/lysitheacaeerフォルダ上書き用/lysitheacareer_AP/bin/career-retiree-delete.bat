@echo off
REM
REM All Rights Reserved. Copyright 2003, 2004, Hitachi Systems & Services, Ltd.
REM 退職者削除バッチのjarファイル、外部jarファイル、システムプロパティファイルのディレクトリのパスを
REM CLASSPATHに設定する。
REM なお、参照するjarファイルは、
REM career-retiree-delete.jar, career-util.jar, log4j-1.2.7.jar

REM *** タイトルバー表示 ***
TITLE *** 退職者削除処理（career-retiree-delete.bat）***

ECHO 退職者削除処理を開始します・・・

set CAREER_HOME=C:\lysitheacareer

REM ORACLEドライバ
set ORACLE_DB_HOME=D:\app\Administrator\product\12.2.0\dbhome_1
set JDBC_PATH=%ORACLE_DB_HOME%\jdbc\lib\ojdbc8.jar

REM バッチログの出力ディレクトリ
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\retireeDelete

REM ---条件設定START--
set PROPS=-Dsakujo_key=
set PROPS=%PROPS% -Dretiree_search_start=
set PROPS=%PROPS% -Dretiree_search_end=
set PROPS=%PROPS% -Dsakujo_tables=P21_ASSESSMENT_SINDAN_TBL:P22_GYOMU_HYOKA_TBL:P23_SKILL_HYOKA_TBL:P24_ASSESSMENT_HYOKA_TBL:P31_CAREER_CHALLENGE_TBL:P32_MORAL_SURVEY_TBL
REM ---条件設定END--

set CLASSPATH=%CAREER_HOME%\lib\career-retiree-delete.jar;
set CLASSPATH=%CLASSPATH%%CAREER_HOME%\lib\career-util.jar;
set CLASSPATH=%CLASSPATH%%CAREER_HOME%\lib\log4j-1.2.7.jar;
set CLASSPATH=%CLASSPATH%%CAREER_HOME%\properties;
set CLASSPATH=%CLASSPATH%%JDBC_PATH%;

set JAVA_COMMAND="D:\Hitachi\Cosminexus\jdk\bin\java"

%JAVA_COMMAND% %PROPS% jp.co.hisas.career.batch.RetireeDelete %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\retireeDelete_Console.log

ECHO 退職者削除処理が終了しました・・・
