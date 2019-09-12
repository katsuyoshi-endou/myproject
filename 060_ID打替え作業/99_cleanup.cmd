@echo off

cd /d %~dp0

call 00_config.cmd

SET EXE_PATH=%CD%\\scripts\\

sqlplus -s %DB_USER%/%DB_PASSWORD%@%ORACLE_SID% @%EXE_PATH%99_cleanup.sql

pause
