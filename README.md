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