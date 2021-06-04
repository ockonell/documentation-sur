#!/bin/sh
#
# David Valdivieso <dvaldivieso@koghi.com>
# JULIO 2020
#

set -e


if [ $# -eq 1 ]
then
	STACKNAME=$1
	echo "STACKNAME: $STACKNAME"
else
	echo "ERROR"
	echo "Stack name is required as first argument."
	echo "Example:"
	echo "bash 4_stop_docker.bash <stack-name>"
	echo ""
	exit
fi

echo "Removing stack ${STACKNAME}"
docker stack rm $STACKNAME
echo ""
echo "Patience is a virtue..."
sleep 15
docker image prune -f
echo
docker stack ls
