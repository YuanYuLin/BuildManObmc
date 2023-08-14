#!/bin/bash
export OBMC_PLATFORM="rpi"
export BB_THREADS="4"

echo "Copying initramfs to /srv/tftp"
if [ ! -d "/srv/tftp" ]; then
  echo "/srv/tftp not exist..."
  exit 1
fi
cp -v misc/initramfs.cpio.xz /srv/tftp/

