#!/bin/bash

source time_function.sh

## Control-plane node
control_plane_node=kind-control-plane
fn=${CDT}-kubelet-kind-control-plane.log.txt
docker exec -it ${control_plane_node} journalctl -u kubelet > ${fn}

## Worker nodes
worker_node_basename=kind-worker
fn=${CDT}-kubelet-kind-worker.log.txt
target_node_name=${worker_node_basename}
docker exec -it ${target_node_name} journalctl -u kubelet > ${fn}

target_node_name=${worker_node_basename}2
fn=${CDT}-kubelet-${target_node_name}.log.txt
docker exec -it ${target_node_name} journalctl -u kubelet > ${fn}

target_node_name=${worker_node_basename}3
fn=${CDT}-kubelet-${target_node_name}.log.txt
docker exec -it ${target_node_name} journalctl -u kubelet > ${fn}

#for i in {2..3}
#do
#    target_node_name=${worker_node_basename}${i}
#    fn=${CDT}-kubelet-${target_node_name}.log.txt
#    docker exec -it ${target_node_name} journalctl -u kubelet > ${fn}
#done


# journalctl option example
# journalctl --output=json --after-cursor="s=6ad7dcf190f3409c8bf8086fec22888c;i=286c44;b=6b134acc25e94d69b4713422b7c773be;m=46f7a97d25;t=55f5e93131a32;x=aecce3d8b96df5dc"

# JSON
# docker exec -it ${worker_node_name} journalctl --output-JSON -u kubelet > ${fn}
