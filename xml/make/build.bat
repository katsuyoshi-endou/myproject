@ECHO OFF
cd /d %~dp0
CALL config.bat

IF "%1" EQU "" (
	rem �f�t�H���g
	"%ANT_HOME%\bin\ant" -f build.xml make-career-ear make-all
) ELSE (
	"%ANT_HOME%\bin\ant" -f build.xml %*
)

@ECHO ON
PAUSE
