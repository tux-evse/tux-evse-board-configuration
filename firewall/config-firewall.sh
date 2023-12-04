#!/bin/bash

# script launched at every boot to config the firewall

firewall-cmd --zone=work --add-interface=eth0 --permanent
firewall-cmd --zone=external --add-interface=wlan0 --permanent
firewall-cmd --zone=public --add-interface=usb0 --permanent

# the policies have been configured during the RPM installation
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=8081/tcp
firewall-cmd --permanent --zone=public --add-port=1234/tcp

# reload to apply the rules
firewall-cmd --reload