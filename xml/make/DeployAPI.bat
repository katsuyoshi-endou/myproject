@echo off
:: --------------------------------
::      Deploy API for OC4J
:: --------------------------------
:: 外部から呼び出して使用します。
:: arg1: ear file path
:: arg2: deploy name (context-root)
::
cd %JAVA_BIN_DIR%
set EAR_PATH=%1
set DEPLOY_NAME=%2
java -jar %OC4J_HOME%\admin.jar ormi:// oc4jadmin oc4jadmin -deploy -file %EAR_PATH% -deploymentName %DEPLOY_NAME% -bindWebApp default-web-site
