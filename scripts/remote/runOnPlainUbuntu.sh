#!/usr/bin/env bash
archive="$HOME/archive.tar"
tomcat_dir="$HOME/tomcat/apache-tomcat-7.0.82"
app_scripts="$HOME/app_start_up_scripts"
HUDSON_HOME="${HOME}/hudson"
mkdir -p "${app_start_up_scripts}"
mkdir -p "${HUDSON_HOME}"
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

function configure_and_run_tomcat {
    CATALINA_HOME="${tomcat_dir}"
    HUDSON_HOME="${HOME}/hudson"
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
    mkdir -p $HOME/tomcat
    cd ${HOME};tar -xvf ${archive}
    mkdir -p $HOME/tomcat;cd $HOME/tomcat
    tar -xvf $HOME/archive/apache-tomcat-7.0.82.tar.gz
    cp $HOME/archive/jenkins.war ${tomcat_dir}/webapps
    mkdir -p ${HOME}/java;cd ${HOME}/java
    tar -xvf $HOME/archive/jdk-7u79-linux-i586.tar.gz
}
generate_set_env(){
    local filepath="$1"
    local script=$(cat <<-EOF
#!/usr/bin/env bash
JAVA_HOME=/home/ubuntu/java/jdk1.7.0_79
CATALINA_HOME=${tomcat_dir}
HUDSON_HOME=${HUDSON_HOME}
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8111 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
export JAVA_HOME CATALINA_HOME PATH HUDSON_HOME CLASSPATH CATALINA_OPTS
export JPDA_ADDRESS=8000
export JPDA_TRANSPORT=dt_socket
EOF
)
    echo "$script" > ${app_scripts}/setenv.sh

}
expand_archive

