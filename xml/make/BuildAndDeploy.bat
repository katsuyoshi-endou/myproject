@echo off
cd /d %~dp0
CALL config.bat
title BuildAndDeploy - %PRJ_NAME%
echo -
echo -
echo -   ���u�f�v���C�Ɍ����Đ�s����OC4J���N�����܂��B�ʑ����J���܂��B�v
echo -
echo -
start %OC4J_BIN%\oc4j.cmd -start
CALL build.bat
echo -
echo -
echo -   ���[�N�X�y�[�X: %PRJ_DIR%
echo -
echo -
echo -
echo -
echo -   ���u�f�v���C���ł��B������AOC4J���I�����Ă��������B���̃E�B���h�E�͎����I�ɕ��܂��B�v
echo -
echo -
DeployAPI.bat %PRJ_DIR%\lib\career.ear %DEPLOY_NM%
