#!/bin/bash

bitbake obmc-phosphor-image

start_ssh_agent() {
  eval `ssh-agent`
  ssh-add ~/ssh_dir/id_rsa
}

stop_ssh_agent() {
  kill $SSH_AGENT_PID
}

start_ssh_agent

USER_IP="userid@192.168.70.254"
OBMC_BUILD_DIR=$1
scp $OBMC_BUILD_DIR/tmp/deploy/images/raspberrypi/obmc-phosphor-image-raspberrypi.squashfs $USER_IP:/srv/tftp/rootfs.squashfs
scp $OBMC_BUILD_DIR/tmp/deploy/images/raspberrypi/uImage $USER_IP:/srv/tftp

stop_ssh_agent
