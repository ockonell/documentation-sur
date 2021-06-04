#!/bin/sh
#
# David Valdivieso <dvaldivieso@koghi.com>
# JULIO 2020
#
set -e

MICROSERVICES_FOLDER="TMP"


if [ $# -eq 2 ]
then
	STACKNAME=$1
	ENV_FILE=$2
	echo "STACKNAME: $STACKNAME, ENV_FILE: $ENV_FILE"
else
	echo "ERROR"
	echo "Stack name is required as first argument."
	echo ".env path file is required as second argument"
	echo "Example:"
	echo "bash 3_deploy_docker.bash <stack-name> <.env-path>"
	echo ""
	exit
fi



if [ ! -f "$ENV_FILE" ]; then
	echo "$ENV_FILE does not exist. You may want to run 7_export_env_file.bash"
	exit
fi

while read ev; do
	echo "$ev"
	export "$ev"
done < $ENV_FILE
echo


cd $MICROSERVICES_FOLDER
pwd
microservices=$(ls)
for ms in ${microservices}
do
	echo '-----------------------------------------------------------------------------------'
	echo $ms
	cd ${ms}
	pwd
	LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
	echo "LATEST TAG: $LATEST_TAG"
	IMAGE="kte_$ms:$LATEST_TAG"
	echo "Building Image ${IMAGE}"
	export "TAG_$ms=$LATEST_TAG"
	docker build -t $IMAGE .
	cd ..
done
cd ..


docker stack deploy -c compose.yml "$STACKNAME" --resolve-image never --prune

echo
echo "Patience is a virtue..."
sleep 10

docker service ls
