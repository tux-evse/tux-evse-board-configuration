# How works the WiFi Hotspot

Configured with NetworkManager, the WiFi Hotspot uses:
- _dnsmasq_ for DHCP leases
- the full configuration described in the `/etc/NetworkManager/dnsmasq-shared.d/tux-evse.conf`
- a captive portal to redirect the user's traffic to the graphic interface

## Captive portal configuration (default Network Manager IP redirection)

Here is our configuration file:
```shell
[root@phytec-iot binder-portal]# cat /etc/NetworkManager/dnsmasq-shared.d/tux-evse.conf
addn-hosts=/etc/hosts
# new model impose SSL/443 with valid certificate
# dhcp-option-force=114,https://captivity.bytes/
# redirect any DNS request to target wifi interface
address=/#/10.42.0.1
dhcp-leasefile=/var/lib/NetworkManager/dnsmasq-wlan0.leases
```

Then you must have a running web-server on the target (e.g. Apache or afb-binder).
```shell
[root@phytec-iot binder-portal]# tree
.
|-- binding-portal.json
|-- html
|   |-- assets
|   |   `-- tux-evsex250.png
|   |-- generate_204
|   |-- index.html
|   `-- style.css
`-- launch_test_captive.sh
```

Some [symbolic links](https://en.wikipedia.org/wiki/Captive_portal#Detection) have been made to configure the captive portal for different platforms.

## Launch the HTTP server (afb-binder)

Here is the script used to expose the HTTP server used by the captive-portal:

```shell
systemctl restart config-hotspot
```

_Nota Bene: HTTPS is a must-have for a final captive portal version, [here](https://github.com/tux-evse/lvgl-binding-rs/commit/c77d5e72656904f03349b7f9c33b5b60dab32dbf) the 443 port configuration_
