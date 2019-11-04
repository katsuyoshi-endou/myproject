@echo off

set PRJ_NAME=panasonic-career-glassfish

set DEPLOY_NM=career
set WORKSPACE=C:\prj\try
set PRJ_DIR=%WORKSPACE%\%PRJ_NAME%
set SRC_HOME=%PRJ_DIR%\src
set JAVA_HOME=C:\java\jdk1.8.0_171
set JAVA_BIN_DIR=%JAVA_HOME%\bin
set ANT_HOME=C:\java\apache-ant-1.9.9
set ANT_OPTS=-mx256m
exit /b
