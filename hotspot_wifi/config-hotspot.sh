#!/bin/bash

# move to projet base to get relative path to logo image
export DIR=`find / -name conf-captive-portal.json`
cd -P `dirname $DIR`

sudo PWD=$PWD afb-binder -vvv --tracereq=all --config=conf-captive-portal.json