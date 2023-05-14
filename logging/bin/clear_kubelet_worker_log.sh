#!/bin/bash

node_name=$1

if [ -z "${node_name}" ]
then
    echo node_name is required.
    exit
fi


docker exec ${node_name} journalctl -u kubelet --vacuum-time=1m
