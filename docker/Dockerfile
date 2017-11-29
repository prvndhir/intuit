FROM    ubuntu:16.04
RUN     apt-get -qqy update \
        && apt-get -qqy install openjdk-8-jdk wget curl
WORKDIR /root
ADD     archive.tar /root
ADD     runOnDocker.sh /root
ADD     docker-entrypoint.sh /root
ADD     default /root
RUN     mkdir -p /root/intuit/conf/tomcat/ && mkdir -p root/intuit/conf/nginx/ \
        &&  mkdir -p /root/intuit/scripts/tomcat/ && chmod 777 /root/docker-entrypoint.sh
ADD     setenv.sh /root/intuit/scripts/tomcat/
ADD     tomcat.sh /root/intuit/scripts/tomcat/
ADD     server.xml /root/intuit/conf/tomcat/
ADD     default /root/intuit/conf/nginx/
RUN     apt-get update && apt-get install -y --no-install-recommends apt-utils nginx
RUN     bash /root/runOnDocker.sh
# Remove src & move jar
#RUN     mkdir -p /deploy/apps && \
#        mv /deploy/microservices/parking-userdata-service/target/scala-2.12/parking-userdata-service-assembly-0.1.0.jar /deploy/apps/ && \
#        rm -rf /deploy/microservices
#WORKDIR /deploy/apps

#CMD     ["java", "-jar", "/deploy/apps/parking-userdata-service-assembly-0.1.0.jar"]
ENTRYPOINT ["/root/docker-entrypoint.sh"]

