#!/bin/bash

#Display script usage details if no arguments are provided.
if [ $# -lt "1" ]; then
	echo -e "Please enter required arguments. \n Usage: ./create-ec2-instance.sh -instances 1 -keyname ec2key -grpname sg-1 -tagkey ec2instace -tagkeyvalue dev"
	exit 1;
fi

#Parse input arguments
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
	-instances)
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
	-tagkey)
	TAG_KEY="$2"
	shift
	;;
	-tagkeyvalue)
	TAG_KEY_VALUE="$2"
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
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-14c5486b --count $NUMBER_OF_INSTANCES --instance-type t1.micro --key-name $KEY_NAME --security-groups $GROUP_NAME | awk -F " " {'print $7'} | grep i-)

if [[ $? -ne 0 ]]; then
	echo "Error running instance. Please check console log."
	exit 1
fi

echo "EC2 Instance id is: " $INSTANCE_ID
touch ${JENKINS_HOME}/instanceid.txt
echo "INSTANCE_ID=$INSTANCE_ID" > ${JENKINS_HOME}/instanceid.txt

aws ec2 create-tags --resources  $INSTANCE_ID --tags Key=$TAG_KEY,Value=$TAG_KEY_VALUE

if [[ $? -ne 0 ]]; then
	echo "Tagging ec2 instance failed. Please check console log."
	exit 1
fi

exit $?
