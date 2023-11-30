#!/bin/bash

# script launched at every boot to config the firewall

firewall-cmd --zone=work --add-interface=eth0 --permanent
firewall-cmd --zone=external --add-interface=wlan0 --permanent
firewall-cmd --zone=public --add-interface=usb0 --permanent

# the policies have been configured during the RPM installation
# reload to apply the rules
firewall-cmd --reload