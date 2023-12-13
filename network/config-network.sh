#!/bin/bash

# Ethernet : auto configured as eth0
# LTE : auto configured as usb0
# Bluetooth : not configured yet

# wifi configuration
interface="wlan0"
connection_name="tuxevse_hotspot"
ssid="tuxevse_hotspot"
password="valeocharger" # visible password for the demo

# check if the interface is present
if [ -e "/sys/class/net/$interface" ]; then
    # check if the hotspot is already created
    if [ "$(nmcli c show | grep "$connection_name")" ]; then
        # check if the connection is up
        if [ "$(nmcli c show "$connection_name" | grep "STATE: up")" ]; then
            echo "Hotspot $connection_name is already up!"
        else
            echo "Hotspot $connection_name is down."
            exit 1
        fi
    else
        # hotspot wifi creation
        nmcli device wifi hotspot ifname "$interface" con-name "$connection_name" ssid "$ssid" password "$password"
        nmcli connection up "$connection_name"
    fi
else
    # system error
    echo "The $interface interface doesn't exist or is not configured." >&2
    exit 1
fi