#!/bin/bash

export OBMC_PLATFORM="yyl"
export SCRIPT_DIR=`dirname $(realpath "$0")`
export TOP_DIR=`realpath $SCRIPT_DIR/../`
export WORKSPACE_DIR="$TOP_DIR/workspace"

source $TOP_DIR/libscripts/libbuild.sh
USER_IP="userid@192.168.70.254"

copy_initramfs () {
  TFTP_DIR="/srv/tftp"
  echo "Copying initramfs to $TFTP_DIR"
  if [ ! -d "$TFTP_DIR" ]; then
    echo "$TFTP_DIR not exist..."
    exit 1
  fi
  cp -v misc/initramfs.cpio.xz $TFTP_DIR
}

build_and_copy_images() {
  bitbake obmc-phosphor-image
  start_ssh_agent "$HOME/ssh_dir/id_rsa"
  src_image=("obmc-phosphor-image-raspberrypi.squashfs"	 "uImage"	 "bcm2708-rpi-b-plus.dtb")
  dst_image=("rootfs.squashfs"				 "uImage"	 "device-tree.dtb")
  for index in {0..2}
  do
    scp $OBMC_BUILD_DIR/tmp/deploy/images/raspberrypi/${src_image[$index]} $USER_IP:/srv/tftp/${dst_image[$index]}
  done
  stop_ssh_agent
}

devtool_modify() {
  #devtool modify linux-raspberrypi
  #devtool modify phosphor-power
  devtool modify entity-manager
}

cd $SCRIPT_DIR
#copy_initramfs

init_build_env

set_local_conf_number_therads
#set_local_conf_sstate_dir
set_local_conf_dl_dir

bitbake obmc-phosphor-image
#build_and_copy_images
#devtool_modify
