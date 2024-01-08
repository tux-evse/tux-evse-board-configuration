#!/bin/bash

# move to projet base to get relative path to logo image
export DIR=`find / -name conf-captive-portal.json`
cd -P `dirname $DIR`



if [ ! -e html/generate_204 ]; then
    ln -s html/index.html html/canonical.html # linux pop-up
    ln -s html/assets/tux-evsex250.png html/favicon.ico # icon
    ln -s html/index.html html/chat # android
    ln -s html/index.html html/success.txt # linux pop-up
    ln -s html/index.html html/generate_204 # android
fi

sudo PWD=$PWD afb-binder -vvv --tracereq=all --config=conf-captive-portal.json