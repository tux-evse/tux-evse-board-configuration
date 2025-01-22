#!/bin/bash

# check if a port is already added to a zone
check_port() {
    firewall-cmd --zone="$1" --query-port="$2"
}

# add a port to a zone if not already added
add_port() {
    if ! check_port "$1" "$2"; then
        firewall-cmd --permanent --zone="$1" --add-port="$2"
    fi
}

# check if a service is already added to a zone
check_service() {
    firewall-cmd --zone="$1" --query-service="$2"
}

# add a service to a zone if not already added
add_service() {
    if ! check_service "$1" "$2"; then
        firewall-cmd --permanent --zone="$1" --add-service="$2"
    fi
}

# check and add interfaces to firewall zones
if ! firewall-cmd --zone=work --query-interface=eth0 && ! firewall-cmd --zone=work --query-interface=eth1; then
    firewall-cmd --zone=work --add-interface=eth0 --add-interface=eth1 --permanent
fi

if ! firewall-cmd --zone=external --query-interface=wlan0; then
    firewall-cmd --zone=external --add-interface=wlan0 --permanent
fi

if ! firewall-cmd --zone=public --query-interface=usb0; then
    firewall-cmd --zone=public --add-interface=usb0 --permanent
fi

if ! firewall-cmd --zone=trusted --query-interface=eth2; then
    firewall-cmd --zone=trusted --add-interface=eth2 --permanent
fi

wg_interface=$(nmcli -g name con | grep wg)
if [ -n "$wg_interface" ] && ! firewall-cmd --zone=work --query-interface="$wg_interface"; then
    firewall-cmd --zone=work --add-interface="$wg_interface" --permanent
fi

# check and add ports for the 4G modem
add_port "public" "80/tcp"
add_port "public" "8080-8082/tcp"
add_port "public" "1200-1299/tcp"

# check and add ports for eth0
add_port "work" "22/tcp"
add_port "work" "80/tcp"
add_port "work" "443/tcp"
add_port "work" "8080-8082/tcp"
add_port "work" "1200-1299/tcp"
add_service "work" "cockpit"

# check and add ports for wlan0
add_port "external" "80/tcp"
add_port "external" "443/tcp"
add_port "external" "8080-8082/tcp"
add_port "external" "1200-1299/tcp"
add_service "external" "http"
add_service "external" "https"
add_service "external" "dhcp"

# reload to apply the rules
firewall-cmd --reload