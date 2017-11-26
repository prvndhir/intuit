#!/usr/bin/env bash
aws_ip="34.212.123.141"
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
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/.ssh/config ubuntu@${aws_ip}:${ubuntu_home}.ssh/
ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "cd ${ubuntu_home};git clone git@github.com:prvndhir/intuit.git;bash intuit/scripts/remote/runOnPlainUbuntu.sh"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "tar -xvf ${archive_dest}/${archive}.tar"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@34.212.123.141
#cd ${HOME};git clone git@github.com:prvndhir/intuit.git;cd intuit
