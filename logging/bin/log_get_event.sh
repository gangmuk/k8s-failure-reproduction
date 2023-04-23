#!/bin/bash

source time_function.sh

#CURRENT_TIME=`date +"%Y%m%d_%H%M%S"`
fn=${CDT}-events.log.txt
echo fn: $fn

kubectl get events --all-namespaces --sort-by='.metadata.creationTimestamp' -A --output json > $fn
