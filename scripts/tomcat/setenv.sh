#!/bin/sh
##set env for catalina
JAVA_HOME="/opt/jdk/jdk1.7.0_79/"
CATALINA_HOME="${HOME}/tomcat/apache-tomcat-7.0.82"
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8111 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
export JAVA_HOME CATALINA_HOME HUDSON_HOME CATALINA_OPTS
export JPDA_ADDRESS=8000
export JPDA_TRANSPORT=dt_socket
