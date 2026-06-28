@echo off
cd /d "%~dp0\..\.."
set LIB=tomcat\apache-tomcat-9.0.117\webapps\voyastra\WEB-INF\lib
set OUTDIR=tomcat\apache-tomcat-9.0.117\webapps\voyastra\WEB-INF\classes
set CP=%LIB%\*;%OUTDIR%
java -cp "%CP%" com.voyastra.util.MigrateUpgrade
