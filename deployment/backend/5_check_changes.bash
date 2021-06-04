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
	echo $ms
	cd ${ms}
	pwd
	git status
	cd ..
done
