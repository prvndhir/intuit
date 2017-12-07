#!/usr/bin/env bash
WORK_DIR=${1}
cd ${WORK_DIR}
terraform_dir="${WORK_DIR}/terraform"
cp ${HOME}/keys/credentials ${HOME}/.aws/
cd ${terraform_dir}
/usr/local/bin/terraform init -input=false
/usr/local/bin/terraform plan -out=tfplan -input=false
/usr/local/bin/terraform
 apply -input=false tfplan
aws_ip="$(grep "value" ${terraform_dir}/terraform.tfstate| sed 's/"value": "//g'|sed 's/"//g'| sed 's/ //g')"
echo "aws_ip=${aws_ip}"
#aws_ip="${1}"
ubuntu_home="/home/ubuntu"
cd ${WORK_DIR}
#tar -cvf ${archive_tar} ${archive}
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${HOME}/keys ubuntu@${aws_ip}:${ubuntu_home}
#scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${archive_tar} ubuntu@${aws_ip}:${ubuntu_home}
scp -r -o StrictHostKeyChecking=no -i ${HOME}/keys/temp_key_my_aws.pem ${WORK_DIR}/conf/ssh/config ubuntu@${aws_ip}:${ubuntu_home}/.ssh/
ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "cd /home/ubuntu;git clone git@github.com:prvndhir/intuit.git;bash intuit/scripts/remote/runOnPlainUbuntu.sh ${aws_ip}"
t=`echo ${aws_ip} |sed 's/\./-/g'`
hostdns="ec2-$t.us-west-2.compute.amazonaws.com"
echo "Please try accessing sample app at ->"
echo "http://${aws_ip}"
echo "http://${hostdns}"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@${aws_ip} "tar -xvf ${archive_dest}/${archive}.tar"
#ssh -i ${HOME}/keys/temp_key_my_aws.pem ubuntu@34.212.53.1
#cd ${HOME};git clone git@github.com:prvndhir/intuit.git;cd intuit


