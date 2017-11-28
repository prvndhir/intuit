#!/usr/bin/env bash
HOME_DIR="${HOME}"
archive="${HOME_DIR}/archive.tar"
tomcat_dir="${HOME_DIR}/tomcat/apache-tomcat-7.0.82"
app_scripts="${HOME_DIR}/app_start_up_scripts"
HUDSON_HOME="${HOME_DIR}/hudson"
mkdir -p "${HUDSON_HOME}"
jre="jdk-7u79-linux-i586.tar.gz"

function printlog {
  printf "$(TZ=":America/Los_Angeles" date) : ${1}\n"
}
function check_dir {
    if [[ ! -d ${1} ]] ; then printlog "#### Aborted ####\n ${1} is not there." ; exit 1 ; fi
    printlog "${1} is there."
}

function check_file {
    if [[ ! -f ${1} ]] ; then printlog "#### Aborted ####\n ${1} is not there." ; exit 1 ; fi
    printlog "${1} is there."
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

function install_nginx {
    sudo apt-get -qqy update
    sudo apt-get -qqy install nginx
    sudo ufw allow 'Nginx HTTP'
    sudo ufw status
    systemctl status nginx
    backup_file "/etc/nginx/sites-enabled/default"
    copy_file "${HOME_DIR}/intuit/conf/nginx/default" "/etc/nginx/sites-enabled/default"
}
#
# Install tomcat from gz file
# Assumes gz file to be present in archive on the local machine

function configure_tomcat {
    CATALINA_HOME="${tomcat_dir}"
    backup_file "${tomcat_dir}/conf/server.xml"
    copy_file "${HOME_DIR}/intuit/conf/tomcat/server.xml" "${tomcat_dir}/conf/server.xml"
    printlog "Run >  sh \${HOME_DIR}/intuit/scripts/tomcat/tomcat.sh start"
}
#
## Install java from gz file
## Assumes gz file to be present in archive on the local machine
##
function install_java {
    check_file "${HOME_DIR}/archive/jdk-7u79-linux-i586.tar.gz"
    printlog "Installing java from archive..."
    sudo mkdir /opt/jdk;sudo tar -zxf ${HOME_DIR}/archive/jdk-7u79-linux-i586.tar.gz -C /opt/jdk  >/dev/null
    check_dir "/opt/jdk/jdk1.7.0_79"
    sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.7.0_79/bin/java 100
    sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.7.0_79/bin/javac 100
    local version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [[ "1.7.0_79" != ${version} ]] ; then printlog "Java version=${version} is different from expected 1.7.0_79" ; exit 1 ; fi
    printlog "Done installing java from archive."
}
## Configures tomcat and dd to enable monitoring
#function configure_tomcat_for_dd_monitoring {
#
#}
# Configures nginx and dd to enable monitoring
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
    printlog "Please wait, expanding the archive(may take up to 2 minutes)..."
    cd ${HOME_DIR};tar -xvf ${archive} >/dev/null
    check_file "${HOME_DIR}/archive/apache-tomcat-7.0.82.tar.gz"
    mkdir -p ${HOME_DIR}/tomcat;cd ${HOME_DIR}/tomcat
    printlog "Expanding the tomcat archive..."
    tar -xvf ${HOME_DIR}/archive/apache-tomcat-7.0.82.tar.gz >/dev/null
    check_dir "${tomcat_dir}"
    check_dir "${tomcat_dir}/webapps"
    printlog "Done expanding the tomcat archive."
    check_file "${HOME_DIR}/archive/sample.war"
    printlog "Copying APP war..."
    copy_file "${HOME_DIR}/archive/sample.war" "${tomcat_dir}/webapps"
    printlog "Done copying APP war."
    printlog "Done expanding the archive."
}

expand_archive
install_java
configure_tomcat
install_nginx >/dev/null