#!/bin/bash

#Display script usage details if no arguments are provided.
if [ $# -lt "1" ]; then
	echo -e "Please enter required arguments. \n Usage: ./install-webserver.sh -instanceid i-xxxx -keyname webserver -u ec2-user"
	exit 1;
fi

#Parse input arguments
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
	-instanceid)
	INSTANCE_ID="$2"
	shift
	;;
	-keyname)
	KEY_NAME="$2"
	shift
	;;
	-u)
	USER="$2"
	shift
	;;
	*)
	echo "Option $key is invalid."
	exit 1
	;;
esac
shift
done

#Retrive public dns host name
HOST=$(aws ec2 describe-instances --instance-id $INSTANCE_ID | grep ASSOCIATION | awk -F " " 'NR==1{print $3}')

if [[ -n $HOST ]]; then
	echo "Unable to retrieve host name. Check console log for details."
	exit 1
fi

KEY_PATH=~/ec2keyfiles

#Update EC2 instance
ssh -i $KEY_PATH/$KEY_NAME.pem -o StrictHostKeyChecking=no $USER@$HOST "sudo yum update -y"

#Install apache webserver
ssh -i $KEY_PATH/$KEY_NAME.pem -o StrictHostKeyChecking=no $USER@$HOST "sudo yum install -y httpd24"

#Start apache webserver
ssh -i $KEY_PATH/$KEY_NAME.pem -o StrictHostKeyChecking=no $USER@$HOST "sudo service httpd start"

exit $?
