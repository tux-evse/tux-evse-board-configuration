#!/bin/sh

# for valeo demo purposes, this script is used to generate crt & private key
# needed by the tux-evse-webapp binder to have a HTTPS connection (TLS)

DIR="/usr/redpesk"

if ! [ -d "$DIR/genssl" ] ; then
    mkdir -p $DIR/genssl
fi

cd $DIR/genssl

# clean previous certificates, keys...
# rm -rf *.pem

openssl req -x509 -days 365 \
-newkey rsa:4096 -nodes \
-subj "/C=FR/ST=Brittany/L=Lorient/O=56/CN=www.tux-evse.com" \
-keyout tuxevse-key.pem -out tuxevse-cert.pem
