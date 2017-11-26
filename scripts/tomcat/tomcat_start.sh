#!/bin/sh
set -x
#if [ -z $CATALINA_HOME ]; then
        echo "CATALINA_HOME is not set"
        echo "Setting ENVIRONMENT for TOMCAT"
        . ${HOME}/intuit/scripts/tomcat/setenv.sh
        echo "JAVA_HOME=$JAVA_HOME"
        echo "CATALINA_HOME=$CATALINA_HOME"
        echo "PATH=$PATH"
        echo "CATALINA_OPTS=$CATALINA_OPTS"
#fi
$CATALINA_HOME/bin/startup.sh -Dproduction=false