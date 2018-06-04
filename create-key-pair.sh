#!/bin/bash

#Display script usage details if no arguments are provided.
if [ $# -lt "1" ]; then
	echo -e "Please enter required arguments. \n Usage: ./create-key-pair.sh -keyname ec2"
	exit 1;
fi

#Parse input arguments
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
	-keyname)
	KEY_NAME="$2"
	shift
	;;
	*)
	echo "Option $key is invalid."
	exit 1
	;;
esac
shift
done

#Check if keyfiles directory exits. If not then create the directory.
if [[ ! -d ~/ec2keyfiles ]]; then
	mkdir -p ~/ec2keyfiles
	echo "Key file storage directory created."
fi

#Run key-pair creation command.
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > ~/ec2keyfiles/$KEY_NAME.pem

chmod 400 ~/ec2keyfiles/$KEY_NAME.pem

#
if [[ $? -ne 0 ]]; then
	echo "Key pair creation failed."
	if [[ -f ~/ec2keyfiles/$KEY_NAME.pem ]]; then
		rm -f ~/ec2keyfiles/$KEY_NAME.pem
		echo "Key file removed."
	fi
fi

exit
