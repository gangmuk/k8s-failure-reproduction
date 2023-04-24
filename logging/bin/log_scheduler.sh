#!/bin/bash

source time_function.sh

fn=${CDT}-scheduler.log.txt
echo fn: $fn

kubectl logs pod/kube-scheduler-kind-control-plane -n kube-system > $fn
