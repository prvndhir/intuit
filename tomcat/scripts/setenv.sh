#!/bin/sh
JAVA_HOME="${HOME}/java/jdk1.7.0_79"
CATALINA_HOME="${HOME}/tomcat/apache-tomcat-7.0.82"
HUDSON_HOME="${HOME}/hudson"
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8111 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
export JAVA_HOME CATALINA_HOME PATH HUDSON_HOME CLASSPATH CATALINA_OPTS
export JPDA_ADDRESS=8000
export JPDA_TRANSPORT=dt_socket
