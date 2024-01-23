# tux-evse-board-configuration

## At the first boot

At the first boot you need to configure some point on the board.

### U-Boot

[README.md](./uboot/README.md)

### redpesk repositories

[README.md](./repositories_config/README.md)

## System configuration

### Network

- Ethernet: auto configured as eth0
- LTE: configured as usb0 (kernel driver added)
- Bluetooth: not configured (coming soon)
- Wifi Configuration: manually configured as wlan0

### Firewall

Thanks to some Linux settings and firewallD rules, this is possible to allow traffic between differents interfaces as needed for the project.

[README.md](./firewall/README.md)

### How to use the VPN

[README.md](./network/README.md)

### WiFi Hotspot

[README.md](./hotspot_wifi/README.md)

### List of the binding

- [auth-binding-rs](https://github.com/tux-evse/auth-binding-rs)
- [charging-binding-rs](https://github.com/tux-evse/charging-binding-rs)
- [display-binding-rs](https://github.com/tux-evse/display-binding-rs)
- [energy-binding-rs](https://github.com/tux-evse/energy-binding-rs)
- [i2c-binding-rs](https://github.com/tux-evse/i2c-binding-rs)
- [linky-binding-rs](https://github.com/tux-evse/linky-binding-rs)
- [ocpp-binding-rs](https://github.com/tux-evse/ocpp-binding-r)
- [scard-binding-rs](https://github.com/tux-evse/scard-binding-rs)
- [slac-binding-rs](https://github.com/tux-evse/slac-binding-rs)
- [ti-am62x-binding-rs](https://github.com/tux-evse/ti-am62x-binding-rs)

### List of the binder manager

- evse-energy-manager-binder
- evse-display-manager-binder
- evse-charging-manager-binder
- evse-auth-manager-binder

### The port used in the demo

In the Demo, tcp port are used to test binding (thanks to the devtools server of the binder).

The syntax of the devtools server URL is:

<http://$BOARD_IP:$PORT/devtools/>

Only one binder can used a port at a time.

| Binder   | devtools tcp port          | API          | tcp port          |
| :--------------- |:---------------:|:---------------:|:---------------:|
| energy-binding-rs  | 1235        | engy        | 12351        |
| display-binding-rs  | 1236             | -        | -        |
| charging-binding-rs  | 1237          | chmgr        | 12371        |
| auth-binding-rs  | 1238          | auth        | 12381        |

For a generic test of a binding:

| Binding   | tcp port          |
| :--------------- | :---------------: |
| Generic binding | 1234        |

Each binding has a script to test it, as:

```bash
/usr/redpesk/$$$-binding-rs/test/bin/start-$$$.sh
```

Each binder manager has is own tcp port reserve:

| Binder   | tcp port          |
| :--------------- |:---------------:|
| evse-energy-manager-binder  | 1235        |
| evse-display-manager-binder  | 1236             |
| evse-charging-manager-binder  | 1237          |
| evse-auth-manager-binder  | 1238          |

Each binder manager has a script to test it, as:

```bash
/usr/redpesk/evse-$$$-manager-binder/test/bin/start-binder.sh
```
