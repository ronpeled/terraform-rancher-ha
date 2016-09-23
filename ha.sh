#!/usr/bin/env bash

SCRIPT_PATH=~/Downloads/rancher-ha.sh

for ip in 52.91.243.49 54.89.59.25 52.91.63.123; do
  scp -i ./ssh/rancher ${SCRIPT_PATH} rancher@${ip}:~/rancher-ha.sh
  ssh -i ./ssh/rancher rancher@${ip} sudo bash rancher-ha.sh rancher/server:v1.1.3
done
