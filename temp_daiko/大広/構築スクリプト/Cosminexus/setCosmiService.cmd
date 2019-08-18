cd /d %COSMINEXUS_HOME%\manager\bin

mngsvrctl setup
mngsvrctl start
adminagentctl start

REM 各サービスの自動起動設定
sc config CosminexusHTTPServer start= demand
sc config mngsvr start= auto
sc config CosmiAdminAgent start= auto

pause
