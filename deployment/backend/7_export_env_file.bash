#!/bin/sh
#
# David Valdivieso <dvaldivieso@koghi.com>
# JULIO 2020
#

set -e
ENV_FILE=".env"
rm -f $ENV_FILE
touch $ENV_FILE

echo DEBUG=TRUE >> $ENV_FILE

echo MONGODB_NAME=KTE >> $ENV_FILE
echo MONGODB_HOST=10.100.45.97 >> $ENV_FILE
echo MONGODB_PORT=27017 >> $ENV_FILE
echo MONGODB_USER=kte_user >> $ENV_FILE
echo MONGODB_PASSWORD=kte123 >> $ENV_FILE
echo MONGODB_POOL_SIZE=1 >> $ENV_FILE
echo MONGODB_REPLICA_SET_NAME=replica_set_01 >> $ENV_FILE

echo MS_CORE_GATEWAY_HOST=ms_core_gateway >> $ENV_FILE
echo MS_CORE_AUTHENTICATION_HOST=ms_core_authentication >> $ENV_FILE
echo MS_CORE_AUTHORIZATION_HOST=ms_core_authorization >> $ENV_FILE
echo MS_CORE_ROUTER_HOST=ms_core_router >> $ENV_FILE
echo MS_CORE_EMAIL_HOST=ms_core_email >> $ENV_FILE
echo MS_CORE_SMS_HOST=ms_core_sms >> $ENV_FILE

echo MS_CORE_GATEWAY_PORT=11000 >> $ENV_FILE
echo MS_CORE_AUTHENTICATION_PORT=22001 >> $ENV_FILE
echo MS_CORE_AUTHORIZATION_PORT=22002 >> $ENV_FILE
echo MS_CORE_ROUTER_PORT=22003 >> $ENV_FILE
echo MS_CORE_EMAIL_PORT=22005 >> $ENV_FILE
echo MS_CORE_SMS_PORT=22006 >> $ENV_FILE
echo MS_CORE_CRON_PORT=22007 >> $ENV_FILE

echo MLM_ADMIN_EMAIL=infraestructura+kte-admin-cert@koghi.com >> $ENV_FILE

echo GMAIL_SMTP_RELAY_HOST=smtp-relay.gmail.com >> $ENV_FILE
echo GMAIL_SMTP_RELAY_PORT=25 >> $ENV_FILE
echo GMAIL_SMTP_RELAY_SENDER_DOMAIN=interrapidisimo.com >> $ENV_FILE
echo "GMAIL_SMTP_RELAY_SENDER_NAME=\"Notificaciones Inter Rapidísimo DEV\"" >> $ENV_FILE
echo GMAIL_SMTP_RELAY_SENDER_ADDRESS=notificaciones@interrapidisimo.com >> $ENV_FILE


cat $ENV_FILE
