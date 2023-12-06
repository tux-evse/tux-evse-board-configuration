# FirewallD configuration

Used to set redpesk firewall rules, firewallD offers a lot of possibilities. In this case, we will use it to configure the ports needed for the micro-services and the network routing between your local PC and the board (like a router) to give Internet access.

## Add/remove a port to a zone

Tip: remove the `--permanent` flag to try the config without saving.

```shell
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload
```

## Policies for Network access (e.g. WiFi -> Ethernet)

The goal is to give Internet access to your PC. For that, we'll use the 4G from the Phytec board. The board will operate like a "router" which forwards all the network traffic.

1. First step, please set a fix IP on your local port (Ethernet) and the board port. The goal is to have the same network to establish the communication between both interfaces (NB: better is to use the _link-local_ but it's more complicate to use what we want with this feature)
   
2. Then you can choose the FirewallD areas you want to use (it's easy to list them with the ``firewall-cmd --list-all-zones`` command). For our demonstration purpose, we'll use the `work` and `external` areas. The `eth0` interface is the PC interface and the `wlan0` my WiFi interface.
   
```shell
firewall-cmd --permanent --zone=work --add-interface=eth0
firewall-cmd --permanent --zone=external --add-interface=wlan0
```

3. Don't forget to check that the routing option is enabled on the Phytec board!
   
```shell
[root@phytec-power ~]# cat /proc/sys/net/ipv4/ip_forward  
1
```

4. Last step is the policies setup to rule how the traffic is configured.
   
```shell
firewall-cmd --permanent --new-policy policyA
firewall-cmd --permanent --policy policyA --add-ingress-zone external
firewall-cmd --permanent --new-policy policyB
firewall-cmd --permanent --policy policyB --add-ingress-zone work
firewall-cmd --permanent --policy policyB --add-egress-zone external
firewall-cmd --reload
```

Then allow the ICMP protocol to be forwarded through the firewall:
```shell
firewall-cmd --permanent --policy policyB --add-protocol icmp
firewall-cmd --reload
```

Source : https://firewalld.org/2020/09/policy-objects-introduction