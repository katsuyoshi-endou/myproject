@echo off
cd /d %~dp0
CALL config.bat
title BuildAndDeploy - %PRJ_NAME%
echo -
echo -
echo -   ＊「デプロイに向けて先行してOC4Jを起動します。別窓が開きます。」
echo -
echo -
start %OC4J_BIN%\oc4j.cmd -start
CALL build.bat
echo -
echo -
echo -   ワークスペース: %PRJ_DIR%
echo -
echo -
echo -
echo -
echo -   ＊「デプロイ中です。完了後、OC4Jを終了してください。このウィンドウは自動的に閉じます。」
echo -
echo -
DeployAPI.bat %PRJ_DIR%\lib\career.ear %DEPLOY_NM%
