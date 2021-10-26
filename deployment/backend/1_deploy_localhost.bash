#!/bin/sh
#
# David Valdivieso <dvaldivieso@koghi.com>
# JULIO 2020
#

FOLDER="TMP"


int_trap() {
	echo ""
	echo "Killing all instances, please wait..."
	killall node -qv
	sleep 2
	echo "Local Deployment Ended"
	echo ""
	exit 0
}
trap int_trap INT




MICROSERVICES=`ls $FOLDER`
for ms_name in $MICROSERVICES; do
	if [[ ("$ms_name" == "ms_sap_api") ]];
	then
		echo $ms_name
		cd "$FOLDER/$ms_name/"
		npm run starttls1 &
		cd ../..
	else
		echo $ms_name
		cd "$FOLDER/$ms_name/"
		npm run dev &
		cd ../..
	fi
done






# At the end...
# Keep main PID running to allow trap
while [ 1 ]
do
	sleep 10
done
