#!/bin/sh
SCRIPTS_DIR=`dirname $0`
#if [ -z $CATALINA_HOME ]; then
        echo "CATALINA_HOME is not set"
        echo "Executing {SCRIPTS_DIR}/setenv.sh"
        . ${HOME}/intuit/scripts/tomcat/setenv.sh
        echo "The following environment variables are set:"
        echo "JAVA_HOME=$JAVA_HOME CATALINA_HOME=$CATALINA_HOME PATH=$PATH"
#fi

ps -ef | grep -v grep | grep -q apache-tomcat
OUT=$?
#echo $OUT
if [ $OUT -ne 0 ];then
        echo "Tomcat is not running currently!"
else
        #temp=`echo -n $CATALINA_HOME`
        #echo $temp
        $CATALINA_HOME/bin/shutdown.sh
fi