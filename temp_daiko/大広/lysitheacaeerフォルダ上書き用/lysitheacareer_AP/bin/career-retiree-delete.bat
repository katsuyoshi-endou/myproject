@echo off
REM
REM All Rights Reserved. Copyright 2003, 2004, Hitachi Systems & Services, Ltd.
REM �ސE�ҍ폜�o�b�`��jar�t�@�C���A�O��jar�t�@�C���A�V�X�e���v���p�e�B�t�@�C���̃f�B���N�g���̃p�X��
REM CLASSPATH�ɐݒ肷��B
REM �Ȃ��A�Q�Ƃ���jar�t�@�C���́A
REM career-retiree-delete.jar, career-util.jar, log4j-1.2.7.jar

REM *** �^�C�g���o�[�\�� ***
TITLE *** �ސE�ҍ폜�����icareer-retiree-delete.bat�j***

ECHO �ސE�ҍ폜�������J�n���܂��E�E�E

set CAREER_HOME=C:\lysitheacareer

REM ORACLE�h���C�o
set ORACLE_DB_HOME=D:\app\Administrator\product\12.2.0\dbhome_1
set JDBC_PATH=%ORACLE_DB_HOME%\jdbc\lib\ojdbc8.jar

REM �o�b�`���O�̏o�̓f�B���N�g��
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\retireeDelete

REM ---�����ݒ�START--
set PROPS=-Dsakujo_key=
set PROPS=%PROPS% -Dretiree_search_start=
set PROPS=%PROPS% -Dretiree_search_end=
set PROPS=%PROPS% -Dsakujo_tables=P21_ASSESSMENT_SINDAN_TBL:P22_GYOMU_HYOKA_TBL:P23_SKILL_HYOKA_TBL:P24_ASSESSMENT_HYOKA_TBL:P31_CAREER_CHALLENGE_TBL:P32_MORAL_SURVEY_TBL
REM ---�����ݒ�END--

set CLASSPATH=%CAREER_HOME%\lib\career-retiree-delete.jar;
set CLASSPATH=%CLASSPATH%%CAREER_HOME%\lib\career-util.jar;
set CLASSPATH=%CLASSPATH%%CAREER_HOME%\lib\log4j-1.2.7.jar;
set CLASSPATH=%CLASSPATH%%CAREER_HOME%\properties;
set CLASSPATH=%CLASSPATH%%JDBC_PATH%;

set JAVA_COMMAND="D:\Hitachi\Cosminexus\jdk\bin\java"

%JAVA_COMMAND% %PROPS% jp.co.hisas.career.batch.RetireeDelete %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\retireeDelete_Console.log

ECHO �ސE�ҍ폜�������I�����܂����E�E�E
