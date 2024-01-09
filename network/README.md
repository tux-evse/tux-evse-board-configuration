# How to configure the VPN

## Importing the VPN configuration

IoT's teams gave you access to the Wireguard VPN directory which contains all the Wireguard files. Please take your configuration file and do the following commands:

```shell
CONF_FILE="wg0-tuxevse.conf"
nmcli connection import type wireguard file "$CONF_FILE"
```

You should have the following output:
``` Connection 'wg0-tuxevse' (125d4b76-d230-47b0-9c31-bb7b9ebca861) successfully added.```

And the interface will be enabled by default (you can see with the ```ip a```  command)

## Enable/disable the VPN connection

You can change the VPN status thanks to the graphical window or these commands:

```shell
nmcli connection down wg0-tuxevse
nmcli connection up wg0-tuxevse
```

## Delete the VPN interface

To delete the VPN connection, please do the following command:

```shell
$ nmcli connection delete wg0-tuxevse
Connection 'wg0-tuxevse' (125d4b76-d230-47b0-9c31-bb7b9ebca861) successfully deleted.
```

# Some basics about the network

To have a Ethernet connection with the Phytec board, you need to have the same IP for the local network. For that, you have to check both IP configuration with your PC and the Phytec board. You can use the ```ip a``` command to find out how your network interfaces are configured.

```
    ____________ A configuration example ______________ 
  / --------------- Both interfaces UP ---------------- \
 / ----------------------------------------------------- \
| PC (192.168.56.1/24) <--------> Board (192.168.56.2/24) |
 \ ----------------------------------------------------- /
  \ ______________ TuxEvse Local Network ______________ /  
```

You must have:
- IP/mask on the same network (e.g 192.168.56.0/24 for the LAN)
- gateways on both devices (to route the packets to the other)
- both interfaces must be **UP** when you want to use them

Another solution is to use the local-link feature but we don't use it at the moment.

## On the Phytec board 

### Showing the connections with 'nmcli'

Be sure that Network Manager shows an active connection with an interface:

```shell
[root@localhost ~]# nmcli connection
NAME                UUID                                  TYPE      DEVICE 
Wired connection 1  885cc19e-2688-390d-b21f-33c4a72a2bc1  ethernet  eth0     
Wired connection 2  54363b13-5a6b-3780-9792-c31d9b5e54df  ethernet  --   
```

Here we have the `Wired connection 1` on the `eth0` interface.

### Checking the IP configuration (adresses, routes...)

Firstly, if Network Manager has successfully created the interface, you should get a result like this:

```shell
[root@phytec-power ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 34:08:e1:84:40:b3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.2/24 brd 192.168.56.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
```

Then the routes table should have a default network gateway for routing.
```shell
[root@phytec-power ~]# ip r
default via 192.168.56.1 dev eth0 proto static metric 100 
192.168.56.0/24 dev eth0 proto kernel scope link src 192.168.56.2 metric 600 
```

If this is not the case, please follow the next step.

## Manually add a new connection on the board

Maybe your Phytec board has an empty network configuration or an unused Ethernet port? You must follow the following steps to easily configure the network.

```shell
MY_CON="tuxevse_network"
MY_ADDR="192.168.56.2"
MY_PORT="eth1"
nmcli con add type ethernet con-name $MY_CON ifname $MY_PORT
nmcli con modify $MY_CON ipv4.method manual ipv4.addresses $MY_ADDR/24
nmcli con modify $MY_CON ipv6.method disable
```

Don't forget to reboot the connection/interface to apply the changes!

```shell
nmcli con down $MY_CON 
nmcli con up $MY_CON
```

## Manually add a new connection on your computer

This is the same on your computer, you must configure a IP for the local network. You can use the graphical window or the following commands:

```shell
MY_CON="tuxevse_network"
MY_ADDR="192.168.56.1"
MY_PORT="eth0" # or your personal ethernet port
nmcli con add type ethernet con-name $MY_CON ifname $MY_PORT
nmcli con modify $MY_CON ipv4.method manual ipv4.addresses $MY_ADDR/24
nmcli con modify $MY_CON ipv6.method disable
```

Don't forget to reboot the connection/interface to apply the changes!

```shell
nmcli con down $MY_CON 
nmcli con up $MY_CON
```

If you want later to use your ethernet port in others networks, you have to change the connection from static to automatic (DHCP).

## Set the DNS to the Phytec Board

```shell
nmcli con mod $MY_CON ipv4.dns "9.9.9.9 1.1.1.1"
```

