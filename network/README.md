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

To have a connection with the Phytec board, you need to the same IP network. For that, you have to check both IP configuration with your PC and the Phytec board. You can use the ```ip a``` command. 

```
    ____________ A configuration example ___________ 
  / --------------- Both interfaces UP ------------- \
 / -------------------------------------------------- \
| PC (192.168.56.1/24) <-----> Board (192.168.56.2/24) |
 \ -------------------------------------------------- /
  \ ______________ Valeo Local Network _____________ /  
```

You must have:
- IP/mask on the same network (e.g 192.168.56.0/24 for the LAN)
- gateways on both devices (to route the packets to the other)
- both interfaces must be **UP** when you want to use them

Another solution is to use the local-link feature but we don't use it at the moment.
