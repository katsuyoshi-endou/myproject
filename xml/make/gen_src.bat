@ECHO OFF
cd /d %~dp0
CALL config.bat

"%ANT_HOME%\bin\ant" -f build.xml ejbdoclet ejbdoclet2 ejbdoclet3 ejbdoclet4

@ECHO ON
PAUSE
