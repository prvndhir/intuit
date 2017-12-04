#!/usr/bin/env bash
terraform_dir="${HOME}/intuit/terraform"
cd ${terraform_dir}
terraform init -input=false
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan
aws_ip="$(grep "value" ${terraform_dir}/terraform.tfstate| sed 's/"value": "//g'|sed 's/"//g'| sed 's/ //g')"
echo "aws_ip=${aws_ip}"
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
echo "Please try accessing sample app at http://${aws_ip}"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "tar -xvf ${archive_dest}/${archive}.tar"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@34.212.53.1
#cd ${HOME};git clone git@github.com:prvndhir/intuit.git;cd intuit


