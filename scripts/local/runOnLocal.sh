#!/usr/bin/env bash
aws_ip="52.39.157.130"
#aws_ip="${1}"
archive="archive"
archive_src="${HOME}/archive"
archive_tar="/tmp/${archive}.tar"
ubuntu_home="/home/ubuntu"
rm -rf ${archive_tar}
cd ${HOME}
tar -cvf ${archive_tar} ${archive}
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/keys ubuntu@${aws_ip}:${ubuntu_home}
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${archive_tar} ubuntu@${aws_ip}:${ubuntu_home}
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/intuit/conf/ssh/config ubuntu@${aws_ip}:${ubuntu_home}/.ssh/
ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "cd /home/ubuntu;git clone git@github.com:prvndhir/intuit.git;bash intuit/scripts/remote/runOnPlainUbuntu.sh"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "tar -xvf ${archive_dest}/${archive}.tar"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@52.39.157.130
#cd ${HOME};git clone git@github.com:prvndhir/intuit.git;cd intuit


