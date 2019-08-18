echo off

cd /d %~dp0

sqlplus CAREER/CAREER@CAREER @show_param.sql > kekka.txt

exit
