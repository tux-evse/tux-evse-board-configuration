#!/bin/bash

# Add ports to a zone
add_ports() {
    echo "Adding ports to $1 zone: $2"
    local port=$(eval echo --add-port={$2})
    firewall-cmd --permanent --zone="$1" $port >/dev/null || exit 1
}

# Add services to a zone
add_services() {
    echo "Adding services to $1 zone: $2"
    local service=$(eval echo --add-service={$2})
    firewall-cmd --permanent --zone="$1" $service >/dev/null || exit 1
}

# Add interfaces to firewall zones
add_interfaces() {
    zone="$1"
    shift
    for interface in "$@"; do
        if [[ $(firewall-cmd --zone="$zone" --query-interface="$interface") == "no" ]]; then
            echo "Adding $interface interface to $zone zone..."
            firewall-cmd --permanent --zone="$zone" --add-interface="$interface" >/dev/null || exit 1
        else
            echo "$interface interface already in $zone zone!"
        fi
    done
}

echo "-- firewallD interfaces configuration --"
add_interfaces "work" "eth0" "eth1"
add_interfaces "external" "wlan0"
add_interfaces "public" "usb0"
add_interfaces "trusted" "eth2"

# Wireguard VPN interface
wg_interface=$(nmcli -g name con | grep wg)
if [ -n "$wg_interface" ] && ! firewall-cmd --zone=work --query-interface="$wg_interface"; then
    add_interfaces "work" "$wg_interface"
fi

echo "-- firewallD 4G modem configuration --"
add_ports "public" "80/tcp,8080-8082/tcp,1200-1299/tcp"

echo "-- firewallD eth0 configuration --"
add_ports "work" "22/tcp,80/tcp,443/tcp,8080-8082/tcp,1200-1299/tcp"
add_services "work" "cockpit,dhcp"

echo "-- firewallD wlan0 configuration --"
add_ports "external" "80/tcp,443/tcp,8080-8082/tcp,1200-1299/tcp"
add_services "external" "http,https,dhcp"

echo "-- firewallD reload to apply changes --"
if ! firewall-cmd --reload; then
    echo "Failed to reload firewall. Changes may not have been applied."
    exit 1
fi
