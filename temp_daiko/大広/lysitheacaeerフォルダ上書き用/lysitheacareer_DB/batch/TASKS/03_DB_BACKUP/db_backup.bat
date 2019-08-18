ECHO ON
cd /d %~pd0
REM ##################################################
REM ̧�ٖ�	�Fdb_backup.bat
REM �@�\	�F�f�[�^�x�[�XEXPORT
REM               �A�v���P�[�V�����X�L�[�}�̃_���v�t�@�C�����擾����B
REM               �擾�����_���v�t�@�C����1���㕪�ABK�t�H���_�ɕۑ�����B
REM �߂�l	�F0�F����I�� 8�F�ُ�I��
REM �O��̧�فF�Ȃ�
REM �o��̧�فF����(CAREER.DMP)
REM ##################################################
REM HOME�ݒ�
SET BATCH_HOME=%~dp0
CD /D %BATCH_HOME%
Set dt=%date:~-10,4%%date:~-5,2%%date:~-2,2%
Set tm=%time: =0%
Set ts=%tm:~0,2%%tm:~3,2%%tm:~6,2%

rem �o�b�`ID
Set BATCH_ID=db_backup

REM ���O�t�@�C����
Set BATCH_LOG_PATH=C:\lysitheacareer\batch\TASKS\03_DB_BACKUP\log
Set BATCH_LOG_FILE=%BATCH_ID%_%dt%_%ts%.log

REM �ڑ��C���X�^���X
Set SID=CAREER

REM ##################################################
REM �p�����[�^��`��
REM ##################################################

REM �y�V�X�e�����[�UID�z
SET DB_USER_ID=system

REM �y�V�X�e�����[�U�p�X���[�h�z
SET DB_USER_PW=system

REM �y�ΏۃX�L�[�}�̃��[�U���z
REM �yCAREER�X�L�[�}�z
SET BACKUP_TARGET=CAREER

REM �o�b�N�A�b�v�t�@�C���쐬��
SET DMP_FILE=C:\lysitheacareer\dmp
SET DMP_FILE_BK=C:\lysitheacareer\dmp\bk

REM �o�b�N�A�b�v�t�@�C���R�s�[��
SET DMP_FILE_COPY=D:\datapump

REM �f�[�^�p���v�R�}���h�͓����̃_���v�t�@�C�������ɑ��݂��Ă���ƃG���[�ƂȂ邽�߈ړ�����B
if not exist %DMP_FILE_BK%\nul mkdir %DMP_FILE_BK%
move %DMP_FILE%\*.* %DMP_FILE_BK%

REM ##################################################
REM �������s��
REM ##################################################
Echo ***** DB�o�b�N�A�b�v�A�ޔ��o�b�` START ***** > %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Date/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
Time/T >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%

EXPDP %DB_USER_ID%/%DB_USER_PW%@%SID% DIRECTORY=LY_DMP_DIR DUMPFILE=CAREER.DMP SCHEMAS=%BACKUP_TARGET% LOGFILE=%BACKUP_TARGET%.LOG

FIND /I "ORA-" %DMP_FILE%\%BACKUP_TARGET%.LOG
IF %ERRORLEVEL% == 0 (EXIT /B 8)

REM D�h���C�u�ɃR�s�[���鏈��
if exist %DMP_FILE%\CAREER.DMP (
	copy %DMP_FILE%\CAREER.DMP %DMP_FILE_COPY%\CAREER.DMP
)

Echo ***** DB�o�b�N�A�b�v�A�ޔ��o�b�` END ***** >> %BATCH_LOG_PATH%\%BATCH_LOG_FILE%
EXIT /B 0
