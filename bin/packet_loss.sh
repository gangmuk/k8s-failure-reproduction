#!/bin/bash

dst_ip=$1

if [ -z "$dst_ip" ]
then
    echo "\$dst_ip is empty"
    echo "exit..."
    exit
else
    echo "dst_ip: ${dst_ip}"
fi

tc qdisc add dev eth0 root handle 1: prio;
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst ${dst_ip} flowid 2:1;
tc qdisc add dev eth0 parent 1:1 handle 2: netem loss 100%
