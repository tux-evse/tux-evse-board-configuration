## Importing the VPN configuration

IoT's teams gave you access to the Wireguard VPN directory which contains all the wireguard files. Please take your configuration file and do the following commands:

```shell
$ CONF_FILE="wg0-tuxevse.conf"
$ nmcli connection import type wireguard file "$CONF_FILE"
```

You should have the following output:
``` Connection 'wg0-tuxevse' (125d4b76-d230-47b0-9c31-bb7b9ebca861) successfully added.```

And the interface will be enabled by default (you can see with the ```ip a```  command)

## Enable/disable the VPN connection

```shell
$ nmcli connection down wg0-tuxevse
$ nmcli connection up wg0-tuxevse
```

## How to delete the VPN interface

To delete the VPN connection, please do the following command:

```shell
$ nmcli connection delete wg0-tuxevse
Connection 'wg0-tuxevse' (125d4b76-d230-47b0-9c31-bb7b9ebca861) successfully deleted.
```
