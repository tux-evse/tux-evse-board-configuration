#!/bin/bash

# script used to simulate a unplug/plug on the USB hub
# its starts thanks a udev rule which loads this script

DEBUG=false

vendor_id="0bda"
product_id="5411"

bus_device=$(lsusb -d "$vendor_id:$product_id" | grep "Bus" | head -n 1) # first output line
bus_number=$(echo $bus_device | awk '{print $2}')
device_number=$(echo $bus_device | awk '{print $4}' | cut -d ':' -f 1)

hub_usb="/dev/bus/usb/$(echo $bus_number | cut -c 4-6)$(echo $bus_number | cut -c 1-3)/$device_number"

if [ $DEBUG ] i; then
	echo "USB device $vendor_id:$product_id is on the $hub_usb bus."
fi

/usr/redpesk/pcscs-client/bin/pcscd-client --reset=$hub_usb