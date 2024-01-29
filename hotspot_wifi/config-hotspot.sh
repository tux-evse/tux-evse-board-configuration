#!/bin/bash

# move to projet base to get relative path to logo image
export DIR=`find / -name conf-captive-portal.json`
cd -P `dirname $DIR`

# symbolics for the different requests
if [ ! -e html/generate_204 -a ! -L html/generate_204 ]; then
    ln -s html/index.html html/canonical.html # linux pop-up
    ln -s html/assets/tux-evsex250.png html/favicon.ico # icon
    ln -s html/index.html html/chat # android
    ln -s html/index.html html/success.txt # linux pop-up
    ln -s html/index.html html/generate_204 # android
fi

# redirection name for the https
if grep -q "tuxevse.iot.bzh" "/etc/hosts"; then
    sed -i '/^127.0.0.1/s/$/ tuxevse.iot.bzh/' /etc/hosts
fi

# launching the hotspot only if the connection exists
if [ "$(nmcli c show "tuxevse_hotspot" | grep "STATE: activated")" ]; then
        sudo PWD=$PWD afb-binder -vvv --tracereq=all --config=conf-captive-portal.json
fi