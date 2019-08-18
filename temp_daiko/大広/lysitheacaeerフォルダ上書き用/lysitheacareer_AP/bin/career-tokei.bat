@echo off
REM
REM All Rights Reserved. Copyright (C) 2004, Hitachi Systems & Services, Ltd.
REM

REM *** �^�C�g���o�[�\�� ***
TITLE *** �A�Z�X�����g���v�����icareer-tokei.bat�j***

ECHO �A�Z�X�����g���v���J�n���܂��E�E�E

REM *** �o�b�`�g�p���ϐ��o�^ ***

REM ���ɂ��ύX���K�v�Ȑݒ� ------------------- ��������
REM Application�ݒ�p�X
set CAREER_HOME=C:\lysitheacareer
set CLIENT_JAR_DIR=%CAREER_HOME%\bin\lib-cosmi

REM JAR�̃p�X���w��
set LOG4J_JAR=%CAREER_HOME%\lib\log4j-1.2.7.jar
set CAREER_UTIL_JAR=%CAREER_HOME%\lib\career-util.jar
set VELOCITY_JAR=%CAREER_HOME%\lib\velocity-1.3.1.jar;%CAREER_HOME%\lib\velocity-dep-1.3.1.jar
set BATCH_APP_JAR=%CAREER_HOME%\lib\career-tokei.jar

REM �v���p�e�B�t�@�C���z�u�f�B���N�g��
set PROPERTY_DIR=%CAREER_HOME%\properties

REM batch_system.property�t�@�C���̐ݒ�
set BATCH_SYSTEMPROPERTY=%PROPERTY_DIR%\batch_system.properties

REM �o�b�`���O�̏o�̓f�B���N�g��
set OUT_LOG_DIR=%CAREER_HOME%\log\batch\careerTokei

REM JDK�z�[���f�B���N�g��
set PRF_HOME=%COSMINEXUS_HOME%\PRF
set JDK_HOME=%COSMINEXUS_HOME%
set JAVA_HOME=%COSMINEXUS_HOME%\jdk
set PATH=%PRF_HOME%\bin;%TPB_HOME%\bin;%JAVA_HOME%\bin;%PATH%

REM --�����ݒ�START--
set PROPS=-Dtokei_syokusyu=
set PROPS=%PROPS% -Dtokei_kubun=
set PROPS=%PROPS% -Dtokei_start=
set PROPS=%PROPS% -Dtokei_last=
REM --�����ݒ�END--

REM ���ɂ��ύX���K�v�Ȑݒ� ------------------- �����܂�

REM �A�v���P�[�V������JAR�t�@�C��
REM set BASE_JAR=%CAREER_HOME%\bin\lib\baseEJB.jar
REM set BATCH_JAR=%CAREER_HOME%\bin\lib\batchEJB.jar
REM set DEPARTMENT_JAR=%CAREER_HOME%\bin\lib\departmentEJB.jar
REM set LEARNING_JAR=%CAREER_HOME%\bin\lib\learningEJB.jar
REM set PERSONAL_JAR=%CAREER_HOME%\bin\lib\personalEJB.jar
REM set PLAN_JAR=%CAREER_HOME%\bin\lib\planEJB.jar
REM set EJB_JAR=%BASE_JAR%;%BATCH_JAR%;%DEPARTMENT_JAR%;%LEARNING_JAR%;%PERSONAL_JAR%;%PLAN_JAR%

rem CosminexusAP
set EJB_JAR=%EJB_JAR%;%CLIENT_JAR_DIR%\stubs.jar
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

REM "*** �A�Z�X�����g���v�������s ***"
%JAVA_COMMAND% -VBJclasspath %CLASSPATH% %PROPS% jp.co.hisas.career.batch.Tokei %BATCH_SYSTEMPROPERTY% %OUT_LOG_DIR% 2> %OUT_LOG_DIR%\careerTokei_Console.log

ECHO �A�Z�X�����g���v�������I�����܂����E�E�E
