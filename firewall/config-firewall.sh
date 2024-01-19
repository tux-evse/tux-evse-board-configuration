#!/bin/bash

# script launched at every boot to config the firewall
firewall-cmd --zone=work --add-interface=eth0 --add-interface=eth1 --permanent
firewall-cmd --zone=external --add-interface=wlan0 --permanent
firewall-cmd --zone=public --add-interface=usb0 --permanent

# authorized ports for the 4G modem
firewall-cmd --permanent --zone=public --add-port=80/tcp # os settings
firewall-cmd --permanent --zone=public --add-port=8080-8082/tcp --add-port=1200-1299/tcp 
firewall-cmd --permanent --zone=public --add-protocol=icmp

# authorized ports for the eth0
firewall-cmd --permanent --zone=work --add-port=22/tcp --add-port=80/tcp --add-port=443/tcp # os settings
firewall-cmd --permanent --add-port=8080-8082/tcp --add-port=1200-1299/tcp # for bindings
firewall-cmd --permanent --zone=work --add-service=cockpit

# authorized ports for the wlan0
firewall-cmd --permanent --zone=external --add-port=80/tcp --add-port=443/tcp # os settings
firewall-cmd --permanent --zone=external --add-port=8080-8082/tcp --add-port=1200-1299/tcp # for bindings
firewall-cmd --permanent --zone=external  --add-service=http --add-service=https --add-service=dhcp

# reload to apply the rules
firewall-cmd --reload