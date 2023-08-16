#!/bin/bash
export OBMC_PLATFORM="rpi"

TFTP_DIR="/srv/tftp"
echo "Copying initramfs to $TFTP_DIR"
if [ ! -d "$TFTP_DIR" ]; then
  echo "$TFTP_DIR not exist..."
  exit 1
fi
cp -v misc/initramfs.cpio.xz $TFTP_DIR

