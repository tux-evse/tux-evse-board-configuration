#!/bin/sh

# for valeo demo purposes, this script is used to generate crt & private key
# needed by the tux-evse-webapp binder to have a HTTPS connection (TLS)

DIR="/usr/redpesk"

mkdir -p $DIR/genssl
chgrp users $DIR/genssl
chmod g+srw $DIR/genssl
chsmack -a System $DIR/genssl

cd $DIR/genssl

# clean previous certificates, keys...
# rm -rf *.pem

if ! [ -f "$DIR/genssl/tuxevse-key.pem" ] ; then

    openssl req -x509 -days 365 \
    -newkey rsa:4096 -nodes \
    -subj "/C=FR/ST=Brittany/L=Lorient/O=56/CN=www.tux-evse.com" \
    -keyout tuxevse-key.pem -out tuxevse-cert.pem

    cp tuxevse* /usr/redpesk/tux-evse-webapp/etc

    chgrp users /usr/redpesk/tux-evse-webapp/etc/tuxevse-key.pem
    chmod g+r /usr/redpesk/tux-evse-webapp/etc/tuxevse-key.pem

    # chmod a+rwx -R $DIR/genssl
    chsmack -a App:tux-evse-webapp:Conf /usr/redpesk/tux-evse-webapp/etc/*

fi
