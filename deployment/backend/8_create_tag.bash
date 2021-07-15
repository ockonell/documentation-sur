#!/bin/sh
#
# Eyleen Rodriguez <erodriguez@koghi.com>
# JULIO 2021
#

if [ $# -eq 2 ]
then
	TAG_VERSION=$1
	TAG_COMMENT=$2
	echo "TAG_VERSION: $TAG_VERSION,  "
	echo "TAG_COMMENT: $TAG_COMMENT  "
else
	echo "ERROR"
	echo "Stack tag version is required as first argument."
	echo "Stack tag comment is required as second argument.  "
	echo "Example:"
	echo "bash 8_create_tag.bash <version> <comment>"
	echo ""
	exit
fi

if [ ! -f "$TAG_COMMENT" ]; then
	TAG_COMMENT="tag for $TAG_VERSION"
fi
MICROSERVICES_FOLDER="TMP"
cd $MICROSERVICES_FOLDER
microservices=$(ls)


for ms in ${microservices}
do
	echo '-----------------------------------------------------------------------------------'
	echo $ms
	cd ${ms}
	pwd
	git checkout master
	git pull origin master
	git tag -a $TAG_VERSION -m "$TAG_COMMENT"
	git push origin $TAG_VERSION
	echo '-----------------------------------------------------------------------------------'
	cd ..
done
