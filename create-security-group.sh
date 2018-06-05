#!/bin/bash

#Display script usage details if no arguments are provided.
if [ $# -lt "1" ]; then
	echo "Please enter required arguments. Usage: ./create-security-group.sh -grpname ec2 -grpdesc Security group for webservers."
	exit 1;
fi

#Parse input arguments
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
	-grpname)
	GROUP_NAME="$2"
	shift
	;;
	-grpdesc)
	GROUP_DESCRIPTION="$2"
	shift
	;;
	*)
	echo "Option $key is invalid."
	exit 1
	;;
esac
shift
done

IP_ADDRESS=$(curl http://ifconfig.io)
CIDR_BLOCK=$(ipcalc $IP_ADDRESS | grep Network | awk -F " " '{print $2}')

aws ec2 create-security-group --group-name $GROUP_NAME --description "$GROUP_DESCRIPTION"
checkExitStatus $?

aws ec2 authorize-security-group-ingress --group-name $GROUP_NAME --protocol tcp --port 22 --cidr $CIDR_BLOCK
checkExitStatus $?

aws ec2 authorize-security-group-ingress --group-name $GROUP_NAME --protocol tcp --port 80 --cidr 0.0.0.0/0
checkExitStatus $?

function checkExitStatus() {
	if [[ $1 -ne 0 ]]; then
		exit 1
	fi	
}

exit
