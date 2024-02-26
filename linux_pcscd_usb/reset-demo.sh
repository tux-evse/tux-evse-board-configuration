#!/bin/sh

echo "Kill energy-manager"
su - rp-owner afm-util kill energy-manager
echo "Kill auth-manager"
su - rp-owner afm-util kill auth-manager
echo "Kill charging-manager"
su - rp-owner afm-util kill charging-manager
echo "Kill display-manager"
su - rp-owner afm-util kill display-manager
echo "Kill tux-evse-webapp"
su - rp-owner afm-util kill tux-evse-webapp

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

echo "Restart energy-manager"
su - rp-owner afm-util run energy-manager

echo "Restart auth-manager"
su - rp-owner afm-util run auth-manager

echo "Restart charging-manager"
su - rp-owner afm-util run charging-manager

echo "Restart display-manager"
su - rp-owner afm-util run display-manager

echo "Restart tux-evse-webapp"
su - rp-owner afm-util run tux-evse-webapp