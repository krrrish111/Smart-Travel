@echo off
cd /d "%~dp0\..\.."
setlocal

set LIB=tomcat\apache-tomcat-9.0.117\webapps\voyastra\WEB-INF\lib
set SERVLET=tomcat\apache-tomcat-9.0.117\lib\servlet-api.jar
set SRCROOT=src\main\java
set OUTDIR=tomcat\apache-tomcat-9.0.117\webapps\voyastra\WEB-INF\classes
set WEBAPP_DIR=tomcat\apache-tomcat-9.0.117\webapps\voyastra

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

set CP=%LIB%\*;%SERVLET%;%SRCROOT%

echo Finding all Java files...
dir /s /b "%SRCROOT%\*.java" > sources.txt

echo Compiling all classes...
javac -encoding UTF-8 -cp "%CP%" -d "%OUTDIR%" @sources.txt

if %ERRORLEVEL% == 0 (
    echo SUCCESS: Compilation complete.
    echo Copying resource files...
    if exist "src\main\resources" xcopy /S /Y src\main\resources\* "%OUTDIR%\"
    echo Cleaning up old deployed files...
    if exist "%WEBAPP_DIR%\css" rmdir /s /q "%WEBAPP_DIR%\css"
    if exist "%WEBAPP_DIR%\js" rmdir /s /q "%WEBAPP_DIR%\js"
    if exist "%WEBAPP_DIR%\images" rmdir /s /q "%WEBAPP_DIR%\images"
    echo Deploying new files...
    xcopy /S /Y src\main\webapp\* "%WEBAPP_DIR%\"
    echo Done! Visit http://localhost:8080/voyastra/ to see the live site.
) else (
    echo FAILURE: Compilation failed. See errors above.
)
del sources.txt
endlocal
