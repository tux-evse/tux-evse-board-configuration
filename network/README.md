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
nmcli con modify $MY_CON +ipv4.routes "192.168.56.0/24 $MY_ADDR"
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

# Wi-Fi configuration

If you use the Linux kernel with 6.6 version (or older with backport module + broadcom drivers/firmwares), you will natively have the wireless `wlan0` interface.

You must enable the WiFi option to be able to use it.

```shell
nmcli con radio on
```

It is possible to scan the available access points from the terminal:

```
[root@phytec-power ~]# nmcli device wifi list
IN-USE  BSSID              SSID        MODE   CHAN  RATE        SIGNAL  BARS  SECURITY  
        48:A9:8A:C1:A7:92  IoTBZH      Infra  112   270 Mbit/s  22      ▂___  WPA2 WPA3 
        48:A9:8A:C1:A7:93  IoTBZH-dmz  Infra  4     270 Mbit/s  7       ▂___  WPA2 WPA3 
```

Then you can choose to connect to the WiFi access point you want:

```shell
[root@phytec-power ~]# nmcli device wifi connect IoTBZH --ask
Password: •••••••••••••••••••••••••
Device 'wlan0' successfully activated with 'd9d6a776-fe8f-4bbc-ab23-55c44488d34d'.
```

You will normally have the `wlan0` interface (thanks to DHCP):

```shell
[root@phytec-power ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 28:b5:e8:e2:5a:39 brd ff:ff:ff:ff:ff:ff
    inet 10.18.127.189/16 brd 10.18.255.255 scope global dynamic noprefixroute eth0
       valid_lft 1660sec preferred_lft 1660sec
    inet6 fe80::c9af:126d:ea3:5ce/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 56:11:a4:9a:0b:55 brd ff:ff:ff:ff:ff:ff
5: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN group default qlen 10
    link/can 
6: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether c0:ee:40:da:80:c6 brd ff:ff:ff:ff:ff:ff
    inet 10.18.127.167/16 brd 10.18.255.255 scope global dynamic noprefixroute wlan0
       valid_lft 1796sec preferred_lft 1796sec
    inet6 fe80::8e37:f64:bf55:d913/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

```

Use a simply ping to check that you have Internet access!

```shell
[root@phytec-power ~]# ping -I wlan0 8.8.8.8 -c 1
PING 8.8.8.8 (8.8.8.8) from 10.18.127.167 wlan0: 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=24.5 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 24.482/24.482/24.482/0.000 ms
```

More details could be find on the Red Hat [documentation](https://docs.redhat.com/fr/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/proc_connecting-to-a-wifi-network-by-using-nmcli_assembly_managing-wifi-connections#proc_connecting-to-a-wifi-network-by-using-nmcli_assembly_managing-wifi-connections).
