#!/bin/bash

# ethernet : auto configured
# lte : auto configured
# BLE : no configured yet
# wifi : configured bellow
nmcli device wifi hotspot ifname wlan0 con-name Valeo_Demo_Charger ssid Valeo_Charger_Demo password "valeocharger"
nmcli connection up Valeo_Demo_Charger