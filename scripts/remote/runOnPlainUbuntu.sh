#!/usr/bin/env bash
archive="$HOME/archive.tar"
tomcat_dir="$HOME/tomcat/apache-tomcat-7.0.82"
app_scripts="$HOME/app_start_up_scripts"
HUDSON_HOME="${HOME}/hudson"
mkdir -p "${app_start_up_scripts}"
mkdir -p "${HUDSON_HOME}"

function printlog {
  printf "$(TZ=":America/Los_Angeles" date) : ${1}\n"
}

function check_file {
    local file="${1}"
    if [[ ! -f ${file} ]] ; then
      printlog "#### Aborted ####\n File ${file} is not there."
      exit 1
    else
      printlog "File ${file} is there."
    fi
}

function copy_file {
    fromFile="${1}"
    toFile="${2}"
    printlog "Copying ${fromFile} to ${toFile}...."
    check_file ${fromFile}
    echo "cp ${fromFile} ${toFile}"
    sudo cp ${fromFile} ${toFile}
    check_file ${toFile}
    printlog "Successfully copied ${fromFile} to ${toFile}."
}

function backup_file {
    local file="${1}"
    if [[ ! -f "${file}.orig" ]] ; then
      copy_file "${file}" "${file}.orig"
    else
      printlog "File ${file} is already there, I am not overwriting."
    fi
}

function install_docker {
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    apt-cache policy docker-ce
    sudo apt-get install -y docker-ce
    sudo systemctl status docker
    sudo usermod -aG docker ${USER}
    su - ${USER}
}

#function install_nginx {
#
#}
#
# Install tomcat from gz file
# Assumes gz file to be present in archive on the local machine

function configure_tomcat {
    CATALINA_HOME="${tomcat_dir}"
    HUDSON_HOME="${HOME}/hudson"
    backup_file "${HOME}/intuit/conf/tomcat/server.xml"
    copy_file "${tomcat_dir}/conf/server.xml" "${HOME}/intuit/conf/tomcat/server.xml"
}
#
## Install java from gz file
## Assumes gz file to be present in archive on the local machine
##
#function install_java {
#
#}
## Configures tomcat and dd to enable monitoring
#function configure_tomcat_for_dd_monitoring {
#
#}
## Configures nginx and dd to enable monitoring
#function configure_nginx_for_dd_monitoring {
#
#}
#
## Configures tomcat for log forwarding to elk
#function configure_tomcat_for_log_forwarding {
#
#}
#
## Configures nginx for log forwarding to elk
#function configure_nginx_for_log_forwarding {
#
#}
function expand_archive {
    check_file "${archive}"
    cd ${HOME};tar -xvf ${archive}
    check_file "$HOME/archive/apache-tomcat-7.0.82.tar.gz"
    mkdir -p $HOME/tomcat;cd $HOME/tomcat
    tar -xvf $HOME/archive/apache-tomcat-7.0.82.tar.gz
    check_file "$HOME/archive/jenkins.war"
    cp $HOME/archive/jenkins.war ${tomcat_dir}/webapps
    check_file "$HOME/archive/jdk-7u79-linux-i586.tar.gz"
    mkdir -p ${HOME}/java;cd ${HOME}/java
    tar -xvf $HOME/archive/jdk-7u79-linux-i586.tar.gz
}

expand_archive
configure_tomcat

