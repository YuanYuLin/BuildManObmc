#!/bin/bash

OBMC_PLATFORM="rpi"
OBMC_PLATFORM_DIR="meta-$OBMC_PLATFORM"

SCRIPT_DIR=`dirname $(realpath "$0")`
TOP_DIR=`realpath $SCRIPT_DIR/../`
OBMC_TEMPLATE="$SCRIPT_DIR/$OBMC_PLATFORM_DIR/conf/templates/default"
OBMC_BUILD_DIR="$TOP_DIR/build_$OBMC_PLATFORM"
OBMC_SSTATE_DIR="$TOP_DIR/obmc_sstate"
OBMC_DL_DIR="$TOP_DIR/obmc_dl"
OBMC_LOCAL_CONF="conf/local.conf"

echo "Building openbmc platform [$OBMC_PLATFORM] $SCRIPT_DIR"
cd $SCRIPT_DIR

echo "Copying initramfs to /srv/tftp"
cp -v misc/initramfs.cpio.xz /srv/tftp/

mkdir -p $OBMC_BUILD_DIR
export TEMPLATECONF="$OBMC_TEMPLATE" 
source oe-init-build-env "$OBMC_BUILD_DIR"

mkdir -p $OBMC_SSTATE_DIR
line=`grep "^SSTATE_DIR" $OBMC_LOCAL_CONF`
if [ -n "$line" ]; then
  sed -i "s#$line#SSTATE_DIR?=\"$OBMC_SSTATE_DIR\"#g" $OBMC_LOCAL_CONF
else
  echo "SSTATE_DIR?=\"$OBMC_SSTATE_DIR\"" >> $OBMC_LOCAL_CONF
fi

mkdir -p $OBMC_DL_DIR
line=`grep "^DL_DIR" $OBMC_LOCAL_CONF`
if [ -n "$line" ]; then
  sed -i "s#$line#DL_DIR?=\"$OBMC_DL_DIR\"#g" $OBMC_LOCAL_CONF
else
  echo "DL_DIR?=$OBMC_DL_DIR" >> $OBMC_LOCAL_CONF
fi
bitbake obmc-phosphor-image
