#!/bin/bash

if [ $# -eq 1 ]; then 
  ARG1=${@%/}
else
  echo "build.sh <meta-platform>"
  echo "ARGS not correct..."
  exit 1
fi

export OBMC_PLATFORM="$ARG1"
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
  cp -v $TOP_DIR/misc/initramfs.cpio.xz $TFTP_DIR
}

build_and_copy_images() {
  bitbake obmc-phosphor-image
  #bitbake -c clean linux-raspberrypi
  #bitbake -c build linux-raspberrypi
  start_ssh_agent "$HOME/ssh_dir/id_rsa"
  src_image=("obmc-phosphor-image-raspberrypi.squashfs"	 "uImage"	 "bcm2708-rpi-b-plus.dtb"	"fitImage")
  dst_image=("rootfs.squashfs"				 "uImage"	 "device-tree.dtb"		"fitImage")
  for index in {0..3}
  do
    scp $OBMC_BUILD_DIR/tmp/deploy/images/raspberrypi/${src_image[$index]} $USER_IP:/srv/tftp/${dst_image[$index]}
  done
  stop_ssh_agent
}

devtool_modify() {
  #devtool modify linux-raspberrypi
  devtool reset linux-raspberrypi
  #devtool modify phosphor-power
  #devtool modify entity-manager
}

cd $SCRIPT_DIR
#copy_initramfs

init_build_env
#init_workspace

set_local_conf_number_therads
#set_local_conf_sstate_dir
set_local_conf_dl_dir

build_and_copy_images
#devtool_modify
