#!/bin/bash

env | grep -w  LE_DOM > /dev/null
if [ $? -eq 0 ]
then
   ENV_DOM=$(echo "$LE_DOM" | tr "," " ")
   for dom in $ENV_DOM; do
      DOMAINS=$DOMAINS" -d $dom"
   done
   echo "create/check/update cerfiticates for domains: $DOM"
else
   echo "Die Umgebungsvariable DOM (example1.com;example2.com..) is not set"
   exit 10
fi

# default is using stage environment

SERV="https://acme-staging-v02.api.letsencrypt.org/directory"

env | grep -w  LE_TIER > /dev/null
if [ $? -eq 0 ]
then
  if [ $LE_TIER == "prod" ]
  then
     SERV="https://acme-v02.api.letsencrypt.org/directory"
     echo "using lets encrypt prod: $SERV"
  else
     echo "using lets encrypt stage: $SERV"  
  fi  
fi



env | grep -w  LE_EMAIL > /dev/null
if [ $? -eq 0 ]
then
  echo using email: $LE_EMAIL
else
  echo "LE_EMAIL missing, exit"
  exit 11
fi

env | grep -w  LE_SCHED > /dev/null
if [ $? -eq 0 ]
then
  echo using scheduling $LE_SCHED
else
  $LE_SCHED="0 3 * * *"
  echo using default scheduling $LE_SCHED
fi

echo "execute certbot"
/usr/local/bin/certbot certonly \
  --authenticator dns-ionos \
  --dns-ionos-credentials /etc/ionos_secrets \
  --dns-ionos-propagation-seconds 600 \
  --non-interactive \
  --expand \
  --server $SERV \
  --agree-tos \
  --email $LE_EMAIL \
  --rsa-key-size 4096 $DOMAINS

chgrp -R 1000 /etc/letsencrypt
chmod g+rx /etc/letsencrypt


