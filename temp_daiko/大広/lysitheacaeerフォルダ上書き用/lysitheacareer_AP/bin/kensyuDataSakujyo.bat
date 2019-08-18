@echo off
REM *** �^�C�g���o�[�\�� ***
TITLE *** ���C�n�f�[�^�폜�ikensyuDataSakujo.bat�j ***

ECHO ���C�n�f�[�^�폜�������J�n���܂��E�E�E

REM *** �o�b�`�g�p���ϐ��o�^ ***

REM Application�ݒ�p�X
set CAREER_HOME=C:\lysitheacareer

REM �o�b�`���O�̏o�̓f�B���N�g��
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\kensyuDataSakujyo

REM ���C�u�����p�X
set CAREER_LIB_DIR=%CAREER_HOME%\lib
set CAREER_BATCH_UTIL=%CAREER_LIB_DIR%\career-util.jar
set CAREER_BATCH_LOG4J=%CAREER_LIB_DIR%\log4j-1.2.7.jar

REM ORACLE�h���C�o
set ORACLE_DB_HOME=D:\app\Administrator\product\12.2.0\dbhome_1
set JDBC_PATH=%ORACLE_DB_HOME%\jdbc\lib\ojdbc8.jar

REM ���C�n�o�b�`JAR
set LYSITHEACAREER_BATCH=%CAREER_LIB_DIR%\learningPh1.jar

set LYSITHEACAREER_BATCH_CLASSPATH=%CAREER_BATCH_UTIL%;%CAREER_BATCH_LOG4J%;%JDBC_PATH%;%LYSITHEACAREER_BATCH%

set LYSITHEACAREER_PROP_DIR=%CAREER_HOME%\properties
set LYSITHEACAREER_PROP_FILE=%LYSITHEACAREER_PROP_DIR%\batch_system.properties

REM --�����ݒ荀��----------------------

REM �폜����
set SAKUJYO_HOUSIKI=2

REM �폜�N�Z��
set SAKUJYO_KISAN_TUKI=A

REM �폜�N�Z��
set SAKUJYO_KISAN_HI=396

REM ���O�t�@�C���p�X
set LOG_FILE_PATH=%CAREER_HOME%\log\batch\kensyusakujyo

REM �e�e�[�u���̍폜�t���O�ݒ�
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

REM JAVA�R�}���h
set JAVA_COMMAND="D:\Hitachi\Cosminexus\jdk\bin\java"

REM "*** ���C�n�f�[�^�폜�������s ***"
%JAVA_COMMAND% -cp .;%LYSITHEACAREER_BATCH_CLASSPATH% %PROPS% jp.co.hisas.addon.batch.learning.kensyudatasakujyo.DeleteClassBatch %LYSITHEACAREER_PROP_FILE% %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\kensyuDataSakujyo_Console.log

ECHO ���C�n�f�[�^�폜�������I�����܂����E�E�E
