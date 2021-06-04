#!/bin/sh
#
# David Valdivieso <dvaldivieso@koghi.com>
# JULIO 2020
#

FOLDER="TMP"



MICROSERVICES=`ls $FOLDER`
for ms_name in $MICROSERVICES; do
	echo $ms_name
	cd "$FOLDER/$ms_name/"
	npm install
	cd ../..
done
