#!/bin/sh
SCRIPTS_DIR=`dirname $0`
set -x
if [ -z $CATALINA_HOME ]; then
        echo "CATALINA_HOME is not set"
        echo "Setting ENVIRONMENT for TOMCAT"
        . ${SCRIPTS_DIR}/setenv.sh
        echo "The following environment variables are set:"
        echo "JAVA_HOME=$JAVA_HOME CATALINA_HOME=$CATALINA_HOME ANT_HOME=$ANT_HOME PATH=$PATH"
fi
$CATALINA_HOME/bin/startup.sh -Dproduction=false