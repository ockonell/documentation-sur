#!/bin/sh
#
# Hossein Calao <hcalao@koghi.com>
# NOVIENBRE 2021
#

create_services() {
	MICROSERVICES=`ls $FOLDER`
	for ms_name in $MICROSERVICES; do
		echo '-------------------------------------------------------------------------'
		echo "Microservicio: $ms_name"
		cd "$FOLDER/$ms_name/"
		rm -r src/daemon
		echo "Servicio: $ms_name.exe"
		node $ms_name"_service"
		sleep 3
		cd ../..
	done
}


start_services() {
	MICROSERVICES=`ls $FOLDER`
	for ms_name in $MICROSERVICES; do
		echo '-------------------------------------------------------------------------'
		echo "Microservicio: $ms_name"
		cd "$FOLDER/$ms_name/"
		echo "Servicio: $ms_name.exe"
		sc start $ms_name".exe"
		sleep 3
		cd ../..
	done
}


stop_services() {
	MICROSERVICES=`ls $FOLDER`
	for ms_name in $MICROSERVICES; do
		echo '-------------------------------------------------------------------------'
		echo "Microservicio: $ms_name"
		cd "$FOLDER/$ms_name/"
		echo "Servicio: $ms_name.exe"
		sc stop $ms_name".exe"
		sleep 3
		cd ../..
	done
}


delete_services() {
	MICROSERVICES=`ls $FOLDER`
	for ms_name in $MICROSERVICES; do
		echo '-------------------------------------------------------------------------'
		echo "Microservicio: $ms_name"
		cd "$FOLDER/$ms_name/"
		echo "Servicio: $ms_name.exe"
		sc delete $ms_name".exe"
		sleep 3
		cd ../..
	done
}


FOLDER="MS"

if [ $# -eq 0 ]
then
	echo "Se requiere parametro (create, start, stop, delete) para ejecutar el script."
	echo "ejemplo: ./9_deploy_how_service start"
elif [ "$1" == "create" ];
then
	echo "CREATE SERVICES"
	create_services
elif [ "$1" == "start" ];
then
	echo "START SERVICES"
	start_services
elif [ "$1" == "stop" ];
then
	echo "STOP SERVICES"
	stop_services
elif [ "$1" == "delete" ];
then
	echo "DELETE SERVICES"
	stop_services
	delete_services
fi

exit