@echo off
REM
REM All Rights Reserved. Copyright (C) 2004, Hitachi Systems & Services, Ltd.
REM 

REM *** �^�C�g���o�[�\�� ***
TITLE *** ���C�Ǘ��Җ������~�ϒʒm���M�����isendKanrisyaMisyoriChikusekiMail.bat�j ***

ECHO ���C�Ǘ��Җ������~�ϒʒm���M�������J�n���܂��E�E�E

REM *** �o�b�`�g�p���ϐ��o�^ ***

REM ���ɂ��ύX���K�v�Ȑݒ� ------------------- ��������

REM Application�ݒ�p�X
set CAREER_HOME=C:\lysitheacareer
set CLIENT_JAR_DIR=%CAREER_HOME%\bin\lib-cosmi

REM JAR�̃p�X���w��
set LOG4J_JAR=%CAREER_HOME%\lib\log4j-1.2.7.jar
set CAREER_UTIL_JAR=%CAREER_HOME%\lib\career-util.jar
set VELOCITY_JAR=%CAREER_HOME%\lib\velocity-1.3.1.jar;%CAREER_HOME%\lib\velocity-dep-1.3.1.jar
set BATCH_APP_JAR=%CAREER_HOME%\lib\kanrisyaMisyoriChikuseki-batch.jar

REM �v���p�e�B�t�@�C���z�u�f�B���N�g��
set PROPERTY_DIR=%CAREER_HOME%\properties

REM batch_system.property�t�@�C���̐ݒ�
set BATCH_SYSTEMPROPERTY=%PROPERTY_DIR%\batch_system.properties

REM �o�b�`���O�̏o�̓f�B���N�g��
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\misyorichikuseki

REM JDK�z�[���f�B���N�g��
set PRF_HOME=%COSMINEXUS_HOME%\PRF
set JDK_HOME=%COSMINEXUS_HOME%
set JAVA_HOME=%COSMINEXUS_HOME%\jdk
set PATH=%PRF_HOME%\bin;%TPB_HOME%\bin;%JAVA_HOME%\bin;%PATH%

REM ���惁�[���A�h���X�̐ݒ�
set PROPS=-DToMailAddress=soujuku@daiko.co.jp

REM ���M�҃��[���A�h���X�̐ݒ�
set PROPS=%PROPS% -DFromMailAddress=soujuku@daiko.co.jp

REM ���ɂ��ύX���K�v�Ȑݒ� ------------------- �����܂�

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

REM �N���X�p�X�w��
set CLASSPATH=%BATCH_APP_JAR%;%LOG4J_JAR%;%CAREER_UTIL_JAR%;%VELOCITY_JAR%;%PROPERTY_DIR%;%EJB_JAR%
set CLASSPATH=%CLASSPATH%;%COSMI_JAR%

REM Java�R�}���h�ݒ�
set JAVA_COMMAND=%COSMINEXUS_HOME%\TPB\bin\vbj

REM "*** ���C�Ǘ��Җ������~�ϒʒm���M�������s ***"
%JAVA_COMMAND% -VBJclasspath %CLASSPATH% %PROPS% jp.co.hisas.addon.batch.learning.misyorichikuseki.main.MisyoriChikuseki %BATCH_SYSTEMPROPERTY% %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\misyorichikuseki_Console.log

ECHO ���C�Ǘ��Җ������~�ϒʒm���M�������I�����܂����E�E�E
