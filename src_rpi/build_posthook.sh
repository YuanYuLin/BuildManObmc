#!/bin/bash

OBMC_BUILD_DIR=$1

scp $OBMC_BUILD_DIR/tmp/deploy/images/raspberrypi/obmc-phosphor-image-raspberrypi.squashfs userid@192.168.70.254:/srv/tftp/rootfs.squashfs
scp $OBMC_BUILD_DIR/tmp/deploy/images/raspberrypi/uImage userid@192.168.70.254:/srv/tftp
