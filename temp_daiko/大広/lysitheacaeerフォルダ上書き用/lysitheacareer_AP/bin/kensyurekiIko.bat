@echo off
REM *** �^�C�g���o�[�\�� ***
TITLE *** ���猤�C���ړ��ikensyurekiIko.bat�j ***

ECHO ���猤�C���ړ��������J�n���܂��E�E�E

REM *** �o�b�`�g�p���ϐ��o�^ ***

REM Application�ݒ�p�X
set LYSITHEACAREER_HOME=C:\lysitheacareer

REM �o�b�`���O�̏o�̓f�B���N�g��
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\kensyurekiIko

REM ���C�u�����p�X
set LYSITHEACAREER_LIB_DIR=%LYSITHEACAREER_HOME%\lib
set LYSITHEACAREER_BATCH_UTIL=%LYSITHEACAREER_LIB_DIR%\career-util.jar
set LYSITHEACAREER_BATCH_LOG4J=%LYSITHEACAREER_LIB_DIR%\log4j-1.2.7.jar

REM ORACLE�h���C�o
set ORACLE_DB_HOME=D:\app\Administrator\product\12.2.0\dbhome_1
set JDBC_PATH=%ORACLE_DB_HOME%\jdbc\lib\ojdbc8.jar

REM ���C�n�o�b�`JAR
set LYSITHEACAREER_BATCH=%LYSITHEACAREER_LIB_DIR%\learningPh1.jar

set LYSITHEACAREER_BATCH_CLASSPATH=%LYSITHEACAREER_BATCH_UTIL%;%LYSITHEACAREER_BATCH_LOG4J%;%JDBC_PATH%;%LYSITHEACAREER_BATCH%

set LYSITHEACAREER_PROP_DIR=%LYSITHEACAREER_HOME%\properties
set LYSITHEACAREER_PROP_FILE=%LYSITHEACAREER_PROP_DIR%\batch_system.properties

REM --�����ݒ荀��----------------------

REM �ړ�����
set IDO_HOUSIKI=2

REM �ړ��N�Z��
set IDO_KISAN_TUKI=1

REM �ړ��N�Z��
set IDO_KISAN_HI=366

REM ���O�t�@�C���p�X
set LOG_FILE_PATH=%LYSITHEACAREER_HOME%\log\batch\kensyurekiiko

REM ���ѕϊ��t���O
set SEISEKI_HENKAN_FLG=0

REM ���C���ړ��t���O
set MISYURYO_IDO_FLG=0

REM -----------------------------------
set PROPS=-DidoHousiki="%IDO_HOUSIKI%"
set PROPS=%PROPS% -DidoKisanTuki="%IDO_KISAN_TUKI%"
set PROPS=%PROPS% -DidoKisanHi="%IDO_KISAN_HI%"
set PROPS=%PROPS% -DlogFilePath="%LOG_FILE_PATH%"
set PROPS=%PROPS% -DseisekiHenkanFlg="%SEISEKI_HENKAN_FLG%"
set PROPS=%PROPS% -DmisyuryoIdoFlg="%MISYURYO_IDO_FLG%"

REM JAVA�R�}���h
REM JAVA�R�}���h
set JAVA_COMMAND="D:\Hitachi\Cosminexus\jdk\bin\java"

REM "*** ���猤�C���ړ��������s ***"
%JAVA_COMMAND% -cp .;%LYSITHEACAREER_BATCH_CLASSPATH% %PROPS% jp.co.hisas.addon.batch.learning.kensyurekiiko.MoveTrainingHistoryBatch %LYSITHEACAREER_PROP_FILE% %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\kensyurekiIko_Console.log

ECHO ���猤�C���ړ��������I�����܂����E�E�E
