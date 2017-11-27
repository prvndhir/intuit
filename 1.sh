#!/usr/bin/env bash

sudo mv jdk1.7.0_79/ /opt/
sudo chown -R root:root /opt/jdk1.7.0_79/
sudo update-alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 200
sudo update-alternatives --install /usr/bin/java java  /home/ubuntu/java/jdk1.7.0_79/bin/java 200
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_79/bin/javac 200
sudo update-alternatives --install /usr/bin/javac javac  /home/ubuntu/java/jdk1.7.0_79/bin/javac 200
update-alternatives --list java


sudo apt-get update
sudo apt-get -qqy update
sudo apt-get -qqy install default-jdk


sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp
curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/

/usr/lib/jvm/java-8-openjdk-amd64/jre/


sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6-i386