#!/bin/bash

#Display script usage details if no arguments are provided.
if [ $# -lt "1" ]; then
	echo -e "Please enter required arguments. \n Usage: ./create-key-pair.sh -instances 1 -keyname ec2key -grpname sg-1"
	exit 1;
fi

#Parse input arguments
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
	-instances
	NUMBER_OF_INSTANCES="$2"
	shift
	;;
	-keyname)
	KEY_NAME="$2"
	shift
	;;
	-grpname)
	GROUP_NAME="$2"
	shift
	;;
	*)
	echo "Option $key is invalid."
	exit 1
	;;
esac
shift
done

#Create EC2 instances
aws ec2 run-instances --image-id ami-14c5486b --count $NUMBER_OF_INSTANCES --instance-type t1.micro --key-name $KEY_NAME --security-groups $GROUPNAME

exit
