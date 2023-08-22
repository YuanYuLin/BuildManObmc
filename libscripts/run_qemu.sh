#!/bin/bash

OBMC_IMAGE='/home/vanish/deve/obmc-build/tmp/dep/static.mtd,format=raw,if=mtd'
OBMC_IMAGE='/home/yyl/BuildManObmc/openbmc/build/p10bmc/tmp/deploy/images/p10bmc/obmc-phosphor-image-p10bmc-20230821140138.rootfs.ext4,if=sd,format=raw'
MACHINE='romulus-bmc'
MACHINE='rainier-bmc'
APPEND1=" -kernel /home/yyl/BuildManObmc/openbmc/build/p10bmc/tmp/deploy/images/p10bmc/zImage--6.1.15+git0+580639a973-r0-p10bmc-20230821140138.bin "
APPEND2=" -append 'root=PARTLABEL=rofs-a rw  mem=1024M ip=192.168.7.2::192.168.7.1:255.255.255.0::eth0:off:8.8.8.8  ' "
APPEND2=" -append 'root=PARTLABEL=rofs-a'"
APPEND3=" -dtb /home/yyl/BuildManObmc/openbmc/build/p10bmc/tmp/deploy/images/p10bmc/aspeed-bmc-ibm-rainier.dtb"
APPEND="$APPEND1 $APPEND2 $APPEND3"

qemu-system-arm -m 1024 -nographic -drive file=$OBMC_IMAGE -net nic -net user,hostfwd=:127.0.0.1:2222-:22,hostfwd=:127.0.0.1:2443-:443,hostname=qemu -M $MACHINE $APPEND1 $APPEND3
