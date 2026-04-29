@echo off
setlocal

set LIB=tomcat\apache-tomcat-9.0.117\webapps\voyastra\WEB-INF\lib
set SERVLET=tomcat\apache-tomcat-9.0.117\lib\servlet-api.jar
set SRCROOT=src\main\java
set OUTDIR=tomcat\apache-tomcat-9.0.117\webapps\voyastra\WEB-INF\classes
set WEBAPP_DIR=tomcat\apache-tomcat-9.0.117\webapps\voyastra

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

set CP=%LIB%\HikariCP-5.0.1.jar;%LIB%\slf4j-api-1.7.36.jar;%LIB%\gson-2.10.1.jar;%LIB%\mysql-connector-j-8.0.33.jar;%LIB%\jstl-1.2.jar;%LIB%\jbcrypt-0.4.jar;%LIB%\jakarta.mail-2.0.1.jar;%SERVLET%;%SRCROOT%

echo Compiling all classes...
javac -encoding UTF-8 -cp "%CP%" -d "%OUTDIR%" ^
  %SRCROOT%\com\voyastra\util\DBConnection.java ^
  %SRCROOT%\com\voyastra\model\*.java ^
  %SRCROOT%\com\voyastra\dao\*.java ^
  %SRCROOT%\com\voyastra\servlet\*.java ^
  %SRCROOT%\com\voyastra\filter\*.java

if %ERRORLEVEL% == 0 (
    echo SUCCESS: Compilation complete.
    echo Cleaning up old index.jsp and deploying new files...
    if exist "%WEBAPP_DIR%\index.jsp" del "%WEBAPP_DIR%\index.jsp"
    xcopy /S /Y src\main\webapp\*.jsp "%WEBAPP_DIR%\"
    xcopy /S /Y src\main\webapp\components\*.jsp "%WEBAPP_DIR%\components\"
    xcopy /S /Y src\main\webapp\css\*.css "%WEBAPP_DIR%\css\"
    xcopy /S /Y src\main\webapp\js\*.js "%WEBAPP_DIR%\js\"
    xcopy /S /Y src\main\webapp\WEB-INF\* "%WEBAPP_DIR%\WEB-INF\"
    xcopy /S /Y src\main\webapp\admin\*.jsp "%WEBAPP_DIR%\admin\"
    xcopy /S /Y src\main\webapp\admin\css\*.css "%WEBAPP_DIR%\admin\css\"
    xcopy /S /Y src\main\webapp\admin\js\*.js "%WEBAPP_DIR%\admin\js\"
    echo Done! Visit http://localhost:8080/voyastra/ to see the live site.
) else (
    echo FAILURE: Compilation failed. See errors above.
)
endlocal
