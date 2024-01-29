#!/bin/bash

# script used to simulate a unplug/plug on the USB hub
# its starts thanks a udev rule which loads this script

DEBUG=false

device_name='ACR122U'

bus_device=$(lsusb | grep "$device_name" | grep "Bus" | head -n 1) && [ -z "$bus_device" ] && \
{ [ "$DEBUG" = true ] && \
echo "The $device_name device is not connected to the board."; exit 1; }

bus_number=$(echo $bus_device | awk '{print $2}')
device_number=$(echo $bus_device | awk '{print $4}' | cut -d ':' -f 1)

hub_usb="/dev/bus/usb/$(echo $bus_number | cut -c 4-6)$(echo $bus_number | cut -c 1-3)/$device_number"

[ "$DEBUG" = true ] && echo "The $device_name device is on the $hub_usb bus."

# restart the pcscd association
/usr/redpesk/pcscs-client/bin/pcscd-client --reset=$hub_usb