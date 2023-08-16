#!/bin/bash

SCRIPT_DIR=`dirname $(realpath "$0")`
cd $SCRIPT_DIR

init_build_env () {
  echo "Building openbmc platform [$OBMC_PLATFORM] $SCRIPT_DIR"
  TOP_DIR=`realpath $SCRIPT_DIR/../`
  OBMC_BUILD_DIR="$TOP_DIR/build_$OBMC_PLATFORM"

  mkdir -p $OBMC_BUILD_DIR
  export OBMC_LOCAL_CONF="conf/local.conf"
  OBMC_TEMPLATE="$SCRIPT_DIR/meta-$OBMC_PLATFORM/conf/templates/default"
  export TEMPLATECONF="$OBMC_TEMPLATE"
  source oe-init-build-env "$OBMC_BUILD_DIR"
}

set_local_conf_number_therads () {
  cpu_count=`lscpu | grep '^CPU(s):' | awk '{print $2}'`
  MIN_BB_THREADS="4"
  MAX_BB_THREADS="12"
  OBMC_VAR=$MIN_BB_THREADS
  if [ $((cpu_count)) > $((MIN_BB_THREAD)) ] ; then
    OBMC_VAR=$MAX_BB_THREADS
  fi
  line=`grep "^BB_NUMBER_THREADS" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#BB_NUMBER_THREADS?=\"$OBMC_VAR\"#g" $OBMC_LOCAL_CONF
  else
    echo "BB_NUMBER_THREADS?=\"$OBMC_VAR\"" >> $OBMC_LOCAL_CONF
  fi
}

set_local_conf_sstate_dir () {
  OBMC_VAR="$TOP_DIR/obmc_sstate"
  mkdir -p $OBMC_VAR_
  line=`grep "^SSTATE_DIR" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#SSTATE_DIR?=\"$OBMC_VAR\"#g" $OBMC_LOCAL_CONF
  else
    echo "SSTATE_DIR?=\"$OBMC_VAR\"" >> $OBMC_LOCAL_CONF
  fi
}

set_local_conf_dl_dir () {
  OBMC_VAR="$TOP_DIR/obmc_dl"
  mkdir -p $OBMC_VAR
  line=`grep "^DL_DIR" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#DL_DIR?=\"$OBMC_VAR\"#g" $OBMC_LOCAL_CONF
  else
    echo "DL_DIR?=\"$OBMC_VAR\"" >> $OBMC_LOCAL_CONF
  fi
}

run_pre_hook () {
  HOOK_SCRIPT="$SCRIPT_DIR/build_prehook.sh"
  if [ ! -f "$HOOK_SCRIPT" ]; then
    echo "$HOOK_SCRIPT not exist"
    exit 1
  fi
  . $HOOK_SCRIPT
}

run_post_hook () {
  HOOK_SCRIPT="$SCRIPT_DIR/build_posthook.sh"
  if [ ! -f "$HOOK_SCRIPT" ]; then
    echo "$HOOK_SCRIPT not exist"
    exit 1
  fi

  . $HOOK_SCRIPT $OBMC_BUILD_DIR
}

run_pre_hook

init_build_env

set_local_conf_number_therads
#set_local_conf_sstate_dir
set_local_conf_dl_dir

run_post_hook
