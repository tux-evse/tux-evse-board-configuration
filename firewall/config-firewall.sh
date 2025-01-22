#!/bin/bash

# add a port to a zone
add_port() {
    echo "Adding $2 port to $1 zone..."
    firewall-cmd --permanent --zone="$1" --add-port="$2"
}

# add a service to a zone if not already added
add_service() {
    echo "Adding $2 service to $1 zone..."
    firewall-cmd --permanent --zone="$1" --add-service="$2"
}

# add interfaces to firewall zones even if they don't exist
add_interfaces() {
    if [[ $(firewall-cmd --zone="$1" --query-interface="$2") == "no" ]]; then
        echo "Adding $2 interface to $1 zone..."
        firewall-cmd --permanent --zone="$1" --add-interface="$2"
    else
        echo "$2 interface already in $1 zone!"
    fi
}

echo "-- firewallD interfaces configuration --"
add_interfaces "work" "eth0"
add_interfaces "work" "eth1"
add_interfaces "external" "wlan0"
add_interfaces "public" "usb0"
add_interfaces "trusted" "eth2"

# wireguard VPN interface
wg_interface=$(nmcli -g name con | grep wg)
if [ -n "$wg_interface" ] && ! firewall-cmd --zone=work --query-interface="$wg_interface"; then
    add_interfaces "work" "$wg_interface"
fi

echo "-- firewallD 4G modem configuration --"
# add ports for the 4G modem
add_port "public" "80/tcp"
add_port "public" "8080-8082/tcp"
add_port "public" "1200-1299/tcp"

echo "-- firewallD eth0 configuration --"
# add ports/services for eth0
add_port "work" "22/tcp"
add_port "work" "80/tcp"
add_port "work" "443/tcp"
add_port "work" "8080-8082/tcp"
add_port "work" "1200-1299/tcp"
add_service "work" "cockpit"

echo "-- firewallD wlan0 configuration --"
# add ports/services for wlan0
add_port "external" "80/tcp"
add_port "external" "443/tcp"
add_port "external" "8080-8082/tcp"
add_port "external" "1200-1299/tcp"
add_service "external" "http"
add_service "external" "https"
add_service "external" "dhcp"

echo "-- firewallD reload to apply changes --"
# reload to apply the rules
firewall-cmd --reload