# U-boot configuration

## First boot

You need to configure your u-boot at the first boot.

This is something you can do only in interactive mode on the console tty of the linux.

On your PC connect the tty console of the board.

```bash
picocom -b 115200 /dev/ttyUSB0
```

Now powerup your board, and interrupt the Linux boot process by pressing a keyboard key.  

```bash
U-Boot SPL 2021.01-g71d3014ea5 (Sep 07 2022 - 12:30:25 +0000)
SYSFW ABI: 3.1 (firmware rev 0x0008 '8.4.7--v08.04.07 (Jolly Jellyfi')
Trying to boot from MMC2
Loading Environment from MMC... OK
Starting ATF on ARM64 core...

NOTICE:  BL31: v2.7(release):v2.7.0-359-g1309c6c805-dirty
NOTICE:  BL31: Built : 11:40:36, Sep  8 2022

U-Boot SPL 2021.01-g71d3014ea5 (Sep 07 2022 - 12:30:25 +0000)
SYSFW ABI: 3.1 (firmware rev 0x0008 '8.4.7--v08.04.07 (Jolly Jellyfi')
Trying to boot from MMC2


U-Boot 2021.01-g71d3014ea5 (Sep 07 2022 - 12:30:25 +0000)

SoC:   AM62X SR1.0
Model: PHYTEC phyCORE-AM62x
DRAM:  2 GiB
MMC:   mmc@fa10000: 0, mmc@fa00000: 1, mmc@fa20000: 2
Loading Environment from MMC... OK
In:    serial@2800000
Out:   serial@2800000
Err:   serial@2800000
Net:   eth0: ethernet@8000000port@1
Hit any key to stop autoboot:  0 
=> 
```

Now you can do:

```bash
setenv overlays k3-am62-phyboard-lyra-rpmsg.dtbo  k3-am62-phyboard-lyra-redbeet.dtbo
setenv mtdparts security=smack
env save
run bootcmd
```

And the job is done.
