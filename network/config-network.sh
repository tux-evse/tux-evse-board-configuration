#!/bin/bash

# Delete old tux-evse connections
nmcli con delete tuxevse_dhcp
nmcli con delete tuxevse_static
nmcli con delete tuxevse_linklocal

# DHCP : eth0 as a IP configuration
nmcli con add type ethernet con-name tuxevse_dhcp ifname eth1
nmcli con mod tuxevse_dhcp ipv4.method auto
nmcli con mod tuxevse_dhcp connection.autoconnect-priority 1
nmcli con mod tuxevse_dhcp connection.autoconnect-retries 1
# STATIC connection : eth0 as a second IP configuration too
nmcli con add type ethernet con-name tuxevse_static ifname eth0
nmcli con mod tuxevse_static ipv4.method manual ipv4.addresses 192.168.10.3/24
nmcli con mod tuxevse_static connection.autoconnect-priority 0
# LINK LOCAL : eth1 as a link local interface (if there is no DHCP on eth1)
nmcli con add type ethernet con-name tuxevse_linklocal ifname eth1
nmcli con mod tuxevse_linklocal ipv4.method link-local

# Unmanaged ETH2 because of Codico so IPv6 link local address
ip -6 addr flush dev eth2 scope link
sysctl -w net.ipv6.conf.eth2.addr_gen_mode=0
sysctl -w net.ipv6.conf.eth2.addr_gen_mode=1
ip link set eth2 up

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
        if [ "$(nmcli c show "$connection_name" | grep "STATE: activated")" ]; then
            echo "Hotspot $connection_name is already up!"
        else
            # nmcli connection up "$connection_name"
            # modification temporaire pour la demo (ne pas avoir le hotspot wifi)
            nmcli connection down "$connection_name"
        fi
    else
        # hotspot wifi creation
        nmcli device wifi hotspot ifname "$interface" con-name "$connection_name" ssid "$ssid" password "$password"
        nmcli connection up "$connection_name"
    fi
else
    # system error
    echo "WARNING:The $interface interface doesn't exist or is not configured." >&2
fi

# Execute a local configuration script, if any
if [ -x /usr/bin/config-network-local ]; then
	/usr/bin/config-network-local
fi
