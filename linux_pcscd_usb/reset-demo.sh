#!/bin/bash

UNITS="afm-appli-auth-manager--main@1001.service\
 afm-appli-charging-manager--main@1001.service\
 afm-appli-dbus-binding--main@1001.service\
 afm-appli-display-manager--main@1001.service\
 afm-appli-energy-manager--main@1001.service\
 josev-rslac\
 josev-piso\
 josev-pocpp"

for unit in ${UNITS}; do
    echo "Kill $unit"
    systemctl stop $unit
done

#----------------------------------------
pkill -9 -U 1001

#----------------------------------------
chsmack -a "App:auth-manager:Conf" /usr/redpesk/evse-auth-manager-binder/etc/*
chsmack -a "App:charging-manager:Conf" /usr/redpesk/evse-charging-manager-binder/etc/*
chsmack -a "App:display-manager:Conf" /usr/redpesk/evse-display-manager-binder/etc/*
chsmack -a "App:energy-manager:Conf" /usr/redpesk/evse-energy-manager-binder/etc/*

chsmack -a "App:tux-evse-webapp:Conf" /usr/redpesk/tux-evse-webapp/etc/*

#----------------------------------------
systemctl restart afm-user-session@1001.service

for unit in ${UNITS}; do
    echo "Restart $unit"
    systemctl start $unit
done
