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

echo "Restart display-manager"
su - rp-owner afm-util run display-manager

echo "Restart tux-evse-webapp"
su - rp-owner afm-util run tux-evse-webapp