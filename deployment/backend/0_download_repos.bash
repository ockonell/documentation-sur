#!/bin/sh
#
# Eyleen Rodriguez <erodriguez@koghi.com>
# JUNIO 2021
# Basado en https://repo.koghi.com/interrapidisimo/kte/documentation/
#

MICROSERVICES_FOLDER="TMP"



rm -rf $MICROSERVICES_FOLDER
mkdir $MICROSERVICES_FOLDER
cd $MICROSERVICES_FOLDER

MS_FOLDER_TEMP=$(pwd)

fetch_kte_backend_project(){
	echo '-------------------------------------------------------------------------'
	MS_NAME=$1
	echo "MICROSERVICE: $MS_NAME"
	git clone git@repo.koghi.com:surcompany/esb/backend/$MS_NAME.git
	cd $MS_NAME
	cd $MS_FOLDER_TEMP
}


fetch_kte_backend_project "ms_core_cron"
fetch_kte_backend_project "ms_core_hook"
fetch_kte_backend_project "ms_esb_inventories"
fetch_kte_backend_project "ms_esb_order"
fetch_kte_backend_project "ms_esb_prices"
fetch_kte_backend_project "ms_esb_product"
fetch_kte_backend_project "ms_esb_queue"
fetch_kte_backend_project "ms_vtex_api"
fetch_kte_backend_project "ms_sap_api"