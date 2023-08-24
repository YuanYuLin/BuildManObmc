#!/bin/bash

export OBMC_LOCAL_CONF="conf/local.conf"
export OBMC_BUILD_DIR="$TOP_DIR/build_$OBMC_PLATFORM"
export WORKSPACE_DIR="$TOP_DIR/workspace"

init_build_env() {
  echo "Building openbmc platform [$OBMC_PLATFORM] $SCRIPT_DIR"

  mkdir -p $OBMC_BUILD_DIR
  OBMC_TEMPLATE="$SCRIPT_DIR/$OBMC_PLATFORM/conf/templates/default"
  export TEMPLATECONF="$OBMC_TEMPLATE"
  source oe-init-build-env "$OBMC_BUILD_DIR"
}

init_workspace() {
  mkdir -p $WORKSPACE_DIR
  devtool create-workspace $WORKSPACE_DIR
}

set_local_conf_number_therads() {
  cpu_count=`lscpu | grep '^CPU(s):' | awk '{print $2}'`
  MIN_BB_THREADS="4"
  MAX_BB_THREADS="12"
  OBMC_VAR=$MIN_BB_THREADS
  echo "CPU count = $cpu_count[MIN:MAX=$MIN_BB_THREADS:$MAX_BB_THREADS]"
  if [ $((cpu_count)) -gt $((MIN_BB_THREADS)) ] ; then
    OBMC_VAR=$MAX_BB_THREADS
  fi
  line=`grep "^BB_NUMBER_THREADS" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#BB_NUMBER_THREADS?=\"$OBMC_VAR\"#g" $OBMC_LOCAL_CONF
  else
    echo "BB_NUMBER_THREADS?=\"$OBMC_VAR\"" >> $OBMC_LOCAL_CONF
  fi
}

set_local_conf_sstate_dir() {
  OBMC_VAR="$TOP_DIR/obmc_sstate"
  mkdir -p $OBMC_VAR_
  line=`grep "^SSTATE_DIR" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#SSTATE_DIR?=\"$OBMC_VAR\"#g" $OBMC_LOCAL_CONF
  else
    echo "SSTATE_DIR?=\"$OBMC_VAR\"" >> $OBMC_LOCAL_CONF
  fi
}

set_local_conf_dl_dir() {
  OBMC_VAR="$TOP_DIR/obmc_dl"
  mkdir -p $OBMC_VAR
  line=`grep "^DL_DIR" $OBMC_LOCAL_CONF`
  if [ -n "$line" ]; then
    sed -i "s#$line#DL_DIR?=\"$OBMC_VAR\"#g" $OBMC_LOCAL_CONF
  else
    echo "DL_DIR?=\"$OBMC_VAR\"" >> $OBMC_LOCAL_CONF
  fi
}

start_ssh_agent() {
  SSH_PRIVATE_KEY=$1
  eval `ssh-agent`
  ssh-add $SSH_PRIVATE_KEY 
}

stop_ssh_agent() {
  kill $SSH_AGENT_PID
}

