#!/bin/bash

OBMC_PLATFORM="rpi"
OBMC_PLATFORM_DIR="meta-$OBMC_PLATFORM"

SCRIPT_DIR=`dirname $(realpath "$0")`
TOP_DIR=`realpath $SCRIPT_DIR/../`
OBMC_LOCAL_CONF="conf/local.conf"

init_build_env () {
  echo "Building openbmc platform [$OBMC_PLATFORM] $SCRIPT_DIR"
  cd $SCRIPT_DIR
  OBMC_BUILD_DIR="$TOP_DIR/build_$OBMC_PLATFORM"
  OBMC_TEMPLATE="$SCRIPT_DIR/$OBMC_PLATFORM_DIR/conf/templates/default"
  mkdir -p $OBMC_BUILD_DIR
  export TEMPLATECONF="$OBMC_TEMPLATE" 
  source oe-init-build-env "$OBMC_BUILD_DIR"
}

prepare_initramfs_file () {
  echo "Copying initramfs to /srv/tftp"
  if [ ! -d "/srv/tftp" ]; then
    echo "/srv/tftp not exist..."
    exit 1
  fi
  cp -v $SCRIPT_DIR/misc/initramfs.cpio.xz /srv/tftp/
}

set_local_conf_sstate_dir () {
  OBMC_SSTATE_DIR="$TOP_DIR/obmc_sstate"
  mkdir -p $OBMC_SSTATE_DIR
  line=`grep "^SSTATE_DIR" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#SSTATE_DIR?=\"$OBMC_SSTATE_DIR\"#g" $OBMC_LOCAL_CONF
  else
    echo "SSTATE_DIR?=\"$OBMC_SSTATE_DIR\"" >> $OBMC_LOCAL_CONF
  fi
}

set_local_conf_dl_dir () {
  OBMC_DL_DIR="$TOP_DIR/obmc_dl"
  mkdir -p $OBMC_DL_DIR
  line=`grep "^DL_DIR" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#DL_DIR?=\"$OBMC_DL_DIR\"#g" $OBMC_LOCAL_CONF
  else
    echo "DL_DIR?=\"$OBMC_DL_DIR\"" >> $OBMC_LOCAL_CONF
  fi
}

init_build_env

prepare_initramfs_file

#set_local_conf_sstate_dir
set_local_conf_dl_dir

bitbake obmc-phosphor-image

