@REM webknossos launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM WEBKNOSSOS_config.txt found in the WEBKNOSSOS_HOME.
@setlocal enabledelayedexpansion
@setlocal enableextensions

@echo off


if "%WEBKNOSSOS_HOME%"=="" (
  set "APP_HOME=%~dp0\\.."

  rem Also set the old env name for backwards compatibility
  set "WEBKNOSSOS_HOME=%~dp0\\.."
) else (
  set "APP_HOME=%WEBKNOSSOS_HOME%"
)

set "APP_LIB_DIR=%APP_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%APP_HOME%\WEBKNOSSOS_config.txt"
set CFG_OPTS=
call :parse_config "%CFG_FILE%" CFG_OPTS

rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=

set "APP_CLASSPATH=%APP_LIB_DIR%\..\conf\;%APP_LIB_DIR%\webknossos.webknossos-wk-sans-externalized.jar;%APP_LIB_DIR%\util.util-wk.jar;%APP_LIB_DIR%\webknossos-tracingstore.webknossos-tracingstore-wk.jar;%APP_LIB_DIR%\webknossos-datastore.webknossos-datastore-wk.jar;%APP_LIB_DIR%\webknossosjni.webknossosjni-wk.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.13.11.jar;%APP_LIB_DIR%\org.playframework.twirl.twirl-api_2.13-2.0.3.jar;%APP_LIB_DIR%\org.playframework.play-server_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-pekko-http-server_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-logback_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-filters-helpers_2.13-3.0.1.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.16.0.jar;%APP_LIB_DIR%\org.playframework.silhouette.play-silhouette_2.13-10.0.0.jar;%APP_LIB_DIR%\org.playframework.silhouette.play-silhouette-crypto-jca_2.13-10.0.0.jar;%APP_LIB_DIR%\org.glassfish.jaxb.txw2-4.0.2.jar;%APP_LIB_DIR%\com.github.jwt-scala.jwt-play-json_2.13-9.2.0.jar;%APP_LIB_DIR%\com.typesafe.slick.slick_2.13-3.4.1.jar;%APP_LIB_DIR%\com.typesafe.slick.slick-hikaricp_2.13-3.4.1.jar;%APP_LIB_DIR%\com.typesafe.slick.slick-codegen_2.13-3.4.1.jar;%APP_LIB_DIR%\org.postgresql.postgresql-42.5.4.jar;%APP_LIB_DIR%\org.playframework.play_2.13-3.0.1.jar;%APP_LIB_DIR%\com.typesafe.play.play-json_2.13-2.10.1.jar;%APP_LIB_DIR%\org.apache.commons.commons-email-1.5.jar;%APP_LIB_DIR%\commons-io.commons-io-2.15.1.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.14.0.jar;%APP_LIB_DIR%\net.liftweb.lift-common_2.13-3.5.0.jar;%APP_LIB_DIR%\org.reactivemongo.reactivemongo-bson-api_2.13-1.0.10.jar;%APP_LIB_DIR%\com.thesamet.scalapb.scalapb-runtime_2.13-0.11.13.jar;%APP_LIB_DIR%\com.typesafe.scala-logging.scala-logging_2.13-3.9.5.jar;%APP_LIB_DIR%\org.playframework.play-caffeine-cache_2.13-3.0.1.jar;%APP_LIB_DIR%\at.favre.lib.bcrypt-0.10.2.jar;%APP_LIB_DIR%\org.jgrapht.jgrapht-core-1.5.1.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-xml_2.13-2.2.0.jar;%APP_LIB_DIR%\org.playframework.play-streams_2.13-3.0.1.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-http-core_2.13-1.0.0.jar;%APP_LIB_DIR%\ch.qos.logback.logback-classic-1.4.14.jar;%APP_LIB_DIR%\org.playframework.play-cache_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-ws_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-openid_2.13-3.0.0.jar;%APP_LIB_DIR%\com.auth0.java-jwt-3.19.4.jar;%APP_LIB_DIR%\org.codehaus.woodstox.woodstox-core-asl-4.0.6.jar;%APP_LIB_DIR%\com.github.jwt-scala.jwt-json-common_2.13-9.2.0.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-2.0.9.jar;%APP_LIB_DIR%\com.typesafe.config-1.4.3.jar;%APP_LIB_DIR%\org.reactivestreams.reactive-streams-1.0.4.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-collection-compat_2.13-2.9.0.jar;%APP_LIB_DIR%\com.zaxxer.HikariCP-4.0.3.jar;%APP_LIB_DIR%\org.checkerframework.checker-qual-3.37.0.jar;%APP_LIB_DIR%\org.playframework.play-build-link-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-configuration_2.13-3.0.1.jar;%APP_LIB_DIR%\org.slf4j.jul-to-slf4j-2.0.9.jar;%APP_LIB_DIR%\org.slf4j.jcl-over-slf4j-2.0.9.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-actor_2.13-1.0.2.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-actor-typed_2.13-1.0.2.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-slf4j_2.13-1.0.2.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-serialization-jackson_2.13-1.0.2.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-core-2.14.3.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-annotations-2.14.3.jar;%APP_LIB_DIR%\com.fasterxml.jackson.datatype.jackson-datatype-jdk8-2.14.3.jar;%APP_LIB_DIR%\com.fasterxml.jackson.datatype.jackson-datatype-jsr310-2.14.3.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-databind-2.14.3.jar;%APP_LIB_DIR%\com.fasterxml.jackson.dataformat.jackson-dataformat-cbor-2.14.3.jar;%APP_LIB_DIR%\com.fasterxml.jackson.module.jackson-module-parameter-names-2.14.3.jar;%APP_LIB_DIR%\com.fasterxml.jackson.module.jackson-module-scala_2.13-2.14.3.jar;%APP_LIB_DIR%\io.jsonwebtoken.jjwt-api-0.11.5.jar;%APP_LIB_DIR%\io.jsonwebtoken.jjwt-impl-0.11.5.jar;%APP_LIB_DIR%\io.jsonwebtoken.jjwt-jackson-0.11.5.jar;%APP_LIB_DIR%\org.playframework.play-json_2.13-3.0.1.jar;%APP_LIB_DIR%\com.google.guava.guava-32.1.3-jre.jar;%APP_LIB_DIR%\javax.inject.javax.inject-1.jar;%APP_LIB_DIR%\com.typesafe.ssl-config-core_2.13-0.6.1.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-parser-combinators_2.13-1.1.2.jar;%APP_LIB_DIR%\com.typesafe.play.play-functional_2.13-2.10.1.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.13.11.jar;%APP_LIB_DIR%\com.sun.mail.javax.mail-1.5.6.jar;%APP_LIB_DIR%\com.thesamet.scalapb.lenses_2.13-0.11.13.jar;%APP_LIB_DIR%\com.google.protobuf.protobuf-java-3.21.7.jar;%APP_LIB_DIR%\com.github.ben-manes.caffeine.caffeine-3.1.8.jar;%APP_LIB_DIR%\com.github.ben-manes.caffeine.jcache-3.1.8.jar;%APP_LIB_DIR%\javax.cache.cache-api-1.1.1.jar;%APP_LIB_DIR%\at.favre.lib.bytes-1.5.0.jar;%APP_LIB_DIR%\com.thesamet.scalapb.scalapb-runtime-grpc_2.13-0.11.13.jar;%APP_LIB_DIR%\io.grpc.grpc-netty-shaded-1.47.1.jar;%APP_LIB_DIR%\io.grpc.grpc-services-1.47.1.jar;%APP_LIB_DIR%\com.google.code.gson.gson-2.10.1.jar;%APP_LIB_DIR%\org.playframework.play-ahc-ws_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-guice_2.13-3.0.1.jar;%APP_LIB_DIR%\org.typelevel.spire_2.13-0.17.0.jar;%APP_LIB_DIR%\net.debasishg.redisclient_2.13-3.42.jar;%APP_LIB_DIR%\cisd.jhdf5-19.04.1.jar;%APP_LIB_DIR%\edu.ucar.cdm-core-5.4.2.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-s3-1.12.470.jar;%APP_LIB_DIR%\com.google.cloud.google-cloud-storage-2.13.1.jar;%APP_LIB_DIR%\org.lasersonlab.jblosc-1.0.1.jar;%APP_LIB_DIR%\org.apache.commons.commons-compress-1.21.jar;%APP_LIB_DIR%\com.github.luben.zstd-jni-1.5.5-5.jar;%APP_LIB_DIR%\com.aayushatharva.brotli4j.brotli4j-1.11.0.jar;%APP_LIB_DIR%\com.aayushatharva.brotli4j.native-linux-x86_64-1.11.0.jar;%APP_LIB_DIR%\com.aayushatharva.brotli4j.native-osx-x86_64-1.11.0.jar;%APP_LIB_DIR%\com.aayushatharva.brotli4j.native-osx-aarch64-1.11.0.jar;%APP_LIB_DIR%\org.lz4.lz4-java-1.8.0.jar;%APP_LIB_DIR%\org.jheaps.jheaps-0.13.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-stream_2.13-1.0.2.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-parsing_2.13-1.0.0.jar;%APP_LIB_DIR%\org.parboiled.parboiled_2.13-2.5.0.jar;%APP_LIB_DIR%\ch.qos.logback.logback-core-1.4.14.jar;%APP_LIB_DIR%\org.playframework.play-ws-standalone_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-ws-standalone-xml_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.play-ws-standalone-json_2.13-3.0.1.jar;%APP_LIB_DIR%\stax.stax-api-1.0.1.jar;%APP_LIB_DIR%\org.codehaus.woodstox.stax2-api-3.0.1.jar;%APP_LIB_DIR%\com.github.jwt-scala.jwt-core_2.13-9.2.0.jar;%APP_LIB_DIR%\org.playframework.play-exceptions-3.0.1.jar;%APP_LIB_DIR%\com.thoughtworks.paranamer.paranamer-2.8.jar;%APP_LIB_DIR%\org.playframework.play-functional_2.13-3.0.1.jar;%APP_LIB_DIR%\com.google.guava.failureaccess-1.0.1.jar;%APP_LIB_DIR%\com.google.guava.listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar;%APP_LIB_DIR%\com.google.code.findbugs.jsr305-3.0.2.jar;%APP_LIB_DIR%\com.google.errorprone.error_prone_annotations-2.21.1.jar;%APP_LIB_DIR%\com.google.j2objc.j2objc-annotations-2.8.jar;%APP_LIB_DIR%\javax.activation.activation-1.1.jar;%APP_LIB_DIR%\org.osgi.org.osgi.service.component.annotations-1.5.1.jar;%APP_LIB_DIR%\jakarta.inject.jakarta.inject-api-2.0.1.jar;%APP_LIB_DIR%\io.grpc.grpc-stub-1.47.1.jar;%APP_LIB_DIR%\io.grpc.grpc-protobuf-1.47.1.jar;%APP_LIB_DIR%\io.perfmark.perfmark-api-0.25.0.jar;%APP_LIB_DIR%\io.grpc.grpc-core-1.47.1.jar;%APP_LIB_DIR%\com.google.protobuf.protobuf-java-util-3.21.7.jar;%APP_LIB_DIR%\org.playframework.play-ahc-ws-standalone_2.13-3.0.1.jar;%APP_LIB_DIR%\org.playframework.shaded-asynchttpclient-3.0.1.jar;%APP_LIB_DIR%\org.playframework.shaded-oauth-3.0.1.jar;%APP_LIB_DIR%\com.google.inject.guice-6.0.0.jar;%APP_LIB_DIR%\com.google.inject.extensions.guice-assistedinject-6.0.0.jar;%APP_LIB_DIR%\org.typelevel.spire-macros_2.13-0.17.0.jar;%APP_LIB_DIR%\org.typelevel.spire-platform_2.13-0.17.0.jar;%APP_LIB_DIR%\org.typelevel.spire-util_2.13-0.17.0.jar;%APP_LIB_DIR%\org.typelevel.algebra_2.13-2.0.1.jar;%APP_LIB_DIR%\org.apache.commons.commons-pool2-2.8.0.jar;%APP_LIB_DIR%\cisd.base-18.09.0.jar;%APP_LIB_DIR%\edu.ucar.udunits-5.4.2.jar;%APP_LIB_DIR%\edu.ucar.httpservices-5.4.2.jar;%APP_LIB_DIR%\com.beust.jcommander-1.78.jar;%APP_LIB_DIR%\com.google.re2j.re2j-1.3.jar;%APP_LIB_DIR%\joda-time.joda-time-2.10.3.jar;%APP_LIB_DIR%\org.jdom.jdom2-2.0.6.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-kms-1.12.470.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-core-1.12.470.jar;%APP_LIB_DIR%\com.amazonaws.jmespath-java-1.12.470.jar;%APP_LIB_DIR%\com.google.http-client.google-http-client-1.42.2.jar;%APP_LIB_DIR%\io.opencensus.opencensus-contrib-http-util-0.31.1.jar;%APP_LIB_DIR%\com.google.http-client.google-http-client-jackson2-1.42.2.jar;%APP_LIB_DIR%\com.google.api-client.google-api-client-2.0.0.jar;%APP_LIB_DIR%\com.google.oauth-client.google-oauth-client-1.34.1.jar;%APP_LIB_DIR%\com.google.http-client.google-http-client-gson-1.42.2.jar;%APP_LIB_DIR%\com.google.http-client.google-http-client-apache-v2-1.42.2.jar;%APP_LIB_DIR%\com.google.apis.google-api-services-storage-v1-rev20220705-2.0.0.jar;%APP_LIB_DIR%\com.google.cloud.google-cloud-core-2.8.20.jar;%APP_LIB_DIR%\com.google.auto.value.auto-value-annotations-1.10.jar;%APP_LIB_DIR%\com.google.api.grpc.proto-google-common-protos-2.9.6.jar;%APP_LIB_DIR%\com.google.cloud.google-cloud-core-http-2.8.20.jar;%APP_LIB_DIR%\com.google.http-client.google-http-client-appengine-1.42.2.jar;%APP_LIB_DIR%\com.google.api.gax-httpjson-0.104.2.jar;%APP_LIB_DIR%\com.google.api.gax-2.19.2.jar;%APP_LIB_DIR%\com.google.auth.google-auth-library-credentials-1.11.0.jar;%APP_LIB_DIR%\com.google.auth.google-auth-library-oauth2-http-1.11.0.jar;%APP_LIB_DIR%\com.google.api.api-common-2.2.1.jar;%APP_LIB_DIR%\javax.annotation.javax.annotation-api-1.3.2.jar;%APP_LIB_DIR%\io.opencensus.opencensus-api-0.31.1.jar;%APP_LIB_DIR%\io.grpc.grpc-context-1.49.2.jar;%APP_LIB_DIR%\com.google.api.grpc.proto-google-iam-v1-1.6.2.jar;%APP_LIB_DIR%\org.threeten.threetenbp-1.6.2.jar;%APP_LIB_DIR%\junit.junit-4.12.jar;%APP_LIB_DIR%\net.java.dev.jna.jna-4.2.2.jar;%APP_LIB_DIR%\com.aayushatharva.brotli4j.service-1.11.0.jar;%APP_LIB_DIR%\org.apache.pekko.pekko-protobuf-v3_2.13-1.0.2.jar;%APP_LIB_DIR%\org.osgi.osgi.annotation-8.1.0.jar;%APP_LIB_DIR%\org.osgi.org.osgi.namespace.extender-1.0.1.jar;%APP_LIB_DIR%\org.osgi.org.osgi.util.function-1.0.0.jar;%APP_LIB_DIR%\org.osgi.org.osgi.util.promise-1.0.0.jar;%APP_LIB_DIR%\io.grpc.grpc-api-1.47.1.jar;%APP_LIB_DIR%\io.grpc.grpc-protobuf-lite-1.47.1.jar;%APP_LIB_DIR%\com.google.android.annotations-4.1.1.4.jar;%APP_LIB_DIR%\org.codehaus.mojo.animal-sniffer-annotations-1.19.jar;%APP_LIB_DIR%\org.playframework.cachecontrol_2.13-3.0.0.jar;%APP_LIB_DIR%\aopalliance.aopalliance-1.0.jar;%APP_LIB_DIR%\org.typelevel.cats-kernel_2.13-2.1.1.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpclient-4.5.13.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpcore-4.4.13.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpmime-4.5.13.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.2.jar;%APP_LIB_DIR%\software.amazon.ion.ion-java-1.0.2.jar;%APP_LIB_DIR%\org.hamcrest.hamcrest-core-1.3.jar;%APP_LIB_DIR%\webknossos.webknossos-wk-assets.jar"
set "APP_MAIN_CLASS=play.core.server.ProdServerStart"
set "SCRIPT_CONF_FILE=%APP_HOME%\conf\application.ini"

rem Bundled JRE has priority over standard environment variables
if defined BUNDLED_JVM (
  set "_JAVACMD=%BUNDLED_JVM%\bin\java.exe"
) else (
  if "%JAVACMD%" neq "" (
    set "_JAVACMD=%JAVACMD%"
  ) else (
    if "%JAVA_HOME%" neq "" (
      if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
    )
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running webknossos.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)

rem if configuration files exist, prepend their contents to the script arguments so it can be processed by this runner
call :parse_config "%SCRIPT_CONF_FILE%" SCRIPT_CONF_ARGS

call :process_args %SCRIPT_CONF_ARGS% %%*

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!

if defined CUSTOM_MAIN_CLASS (
    set MAIN_CLASS=!CUSTOM_MAIN_CLASS!
) else (
    set MAIN_CLASS=!APP_MAIN_CLASS!
)

rem Call the application and pass all arguments unchanged.
"%_JAVACMD%" !_JAVA_OPTS! !WEBKNOSSOS_OPTS! -cp "%APP_CLASSPATH%" %MAIN_CLASS% !_APP_ARGS!

@endlocal

exit /B %ERRORLEVEL%


rem Loads a configuration file full of default command line options for this script.
rem First argument is the path to the config file.
rem Second argument is the name of the environment variable to write to.
:parse_config
  set _PARSE_FILE=%~1
  set _PARSE_OUT=
  if exist "%_PARSE_FILE%" (
    FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%_PARSE_FILE%") DO (
      set _PARSE_OUT=!_PARSE_OUT! %%i
    )
  )
  set %2=!_PARSE_OUT!
exit /B 0


:add_java
  set _JAVA_PARAMS=!_JAVA_PARAMS! %*
exit /B 0


:add_app
  set _APP_ARGS=!_APP_ARGS! %*
exit /B 0


rem Processes incoming arguments and places them in appropriate global variables
:process_args
  :param_loop
  call set _PARAM1=%%1
  set "_TEST_PARAM=%~1"

  if ["!_PARAM1!"]==[""] goto param_afterloop


  rem ignore arguments that do not start with '-'
  if "%_TEST_PARAM:~0,1%"=="-" goto param_java_check
  set _APP_ARGS=!_APP_ARGS! !_PARAM1!
  shift
  goto param_loop

  :param_java_check
  if "!_TEST_PARAM:~0,2!"=="-J" (
    rem strip -J prefix
    set _JAVA_PARAMS=!_JAVA_PARAMS! !_TEST_PARAM:~2!
    shift
    goto param_loop
  )

  if "!_TEST_PARAM:~0,2!"=="-D" (
    rem test if this was double-quoted property "-Dprop=42"
    for /F "delims== tokens=1,*" %%G in ("!_TEST_PARAM!") DO (
      if not ["%%H"] == [""] (
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      ) else if [%2] neq [] (
        rem it was a normal property: -Dprop=42 or -Drop="42"
        call set _PARAM1=%%1=%%2
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
        shift
      )
    )
  ) else (
    if "!_TEST_PARAM!"=="-main" (
      call set CUSTOM_MAIN_CLASS=%%2
      shift
    ) else (
      set _APP_ARGS=!_APP_ARGS! !_PARAM1!
    )
  )
  shift
  goto param_loop
  :param_afterloop

exit /B 0
