#!/bin/sh
#
# David Valdivieso <dvaldivieso@koghi.com>
# JULIO 2020
#


MICROSERVICES_FOLDER="TMP"
cd $MICROSERVICES_FOLDER
microservices=$(ls)

for ms in ${microservices}
do
	echo '-----------------------------------------------------------------------------------'
	echo "MICROSERVICE: $ms"
	cd ${ms}
	git checkout master
	git pull
	git fetch --all --tags
	LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
	echo "LATEST TAG: $LATEST_TAG"
	git checkout $LATEST_TAG
	cd ..
done
