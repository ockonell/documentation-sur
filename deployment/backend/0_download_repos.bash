#!/bin/sh
#
# Eyleen Rodriguez <erodriguez@koghi.com>
# JUNIO 2021
# Basdo en https://repo.koghi.com/interrapidisimo/kte/documentation/
#

MICROSERVICES_FOLDER="TMP"



rm -rf $MICROSERVICES_FOLDER
mkdir $MICROSERVICES_FOLDER
cd $MICROSERVICES_FOLDER



fetch_kte_backend_project(){
	echo '-------------------------------------------------------------------------'
	MS_NAME=$1
	echo "MICROSERVICE: $MS_NAME"
	git clone git@repo.koghi.com/surcompany/esb/backend/$MS_NAME.git
	cd $MS_NAME
	git fetch --all --tags
	LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
	echo "LATEST TAG: $LATEST_TAG"
	git config --global advice.detachedHead false
	git checkout $LATEST_TAG
	cd ..
}


fetch_kte_backend_project "ms_core_gateway"
#fetch_kte_backend_project "ms_core_authentication"
#fetch_kte_backend_project "ms_core_authorization"
#fetch_kte_backend_project "ms_core_router"
#fetch_kte_backend_project "ms_core_email"