#!/bin/bash

source time_function.sh

node_name=$1

if [ -z "${node_name}" ]
then
    echo node_name is required.
    exit
fi


fn=${CDT}-kubelet-${node_name}.log.txt
docker exec -it ${node_name} journalctl -u kubelet --since "${UTC_J_20min_ago}" > ${fn}
