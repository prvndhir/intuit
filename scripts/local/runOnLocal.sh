#!/usr/bin/env bash
aws_ip="34.212.123.141"
#aws_ip="${1}"
archive="archive"
archive_src="${HOME}/archive"
archive_tar="/tmp/${archive}.tar"
archive_dest="/home/ubuntu/"
rm -rf ${archive_tar}
cd ${HOME}
tar -cvf ${archive_tar} ${archive}
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/keys ubuntu@${aws_ip}:/home/ubuntu/
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${archive_tar} ubuntu@${aws_ip}:${archive_dest}
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/.ssh/config ubuntu@${aws_ip}:/home/ubuntu/.ssh/
#aws_ip="34.212.123.141";scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/keys ubuntu@${aws_ip}:/home/ubuntu/
#aws_ip="34.212.123.141";scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/.ssh/config ubuntu@${aws_ip}:/home/ubuntu/.ssh/
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "tar -xvf ${archive_dest}/${archive}.tar"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@34.212.123.141
#cd ${HOME};git clone git@github.com:prvndhir/intuit.git;cd intuit
