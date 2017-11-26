#!/bin/sh
set -x
if [ -z $CATALINA_HOME ]; then
        echo "Setting ENVIRONMENT for TOMCAT"
        . ${HOME}/intuit/scripts/tomcat/setenv.sh
        echo "JAVA_HOME=$JAVA_HOME"
        echo "CATALINA_HOME=$CATALINA_HOME"
        exho "PATH=$PATH"
        echo "CATALINA_OPTS=$CATALINA_OPTS"
fi
if [ "${1}" = "start" ]; then
    $CATALINA_HOME/bin/startup.sh -Dproduction=false
elif [ "${1}" = "stop" ] ; then
    ps -ef | grep -v grep | grep -q apache-tomcat
    OUT=$?
    if [ $OUT -ne 0 ];then
        echo "Tomcat is not running currently!"
    else
        $CATALINA_HOME/bin/shutdown.sh
    fi
else
    echo "Invalid option."
fi
