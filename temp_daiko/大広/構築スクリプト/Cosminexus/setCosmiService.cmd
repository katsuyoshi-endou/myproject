cd /d %COSMINEXUS_HOME%\manager\bin

mngsvrctl setup
mngsvrctl start
adminagentctl start

REM �e�T�[�r�X�̎����N���ݒ�
sc config CosminexusHTTPServer start= demand
sc config mngsvr start= auto
sc config CosmiAdminAgent start= auto

pause
