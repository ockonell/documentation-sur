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
	LATEST_VERSION=$(head -n 1 src/version.js | cut -d '=' -f 2)
	echo "LATEST TAG: $LATEST_VERSION"
	cd ..
done
