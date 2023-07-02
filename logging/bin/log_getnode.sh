#!/bin/bash

#source /home/gangmuk2/projects/k8s-failure-reproduction/logging/bin/time_function.sh
source time_function.sh

#CURRENT_TIME=`date +"%Y%m%d_%H%M%S"`
#fn=${CDT}-getnode.log.csv
fn=${CDT}-getnode.log.json
echo fn: $fn

idx=0
while [ 0 -le 1 ] # infinite loop
do
    start_time=$(date +%s.%3N)
    utc_time
    cdt_time
    echo "idx,${idx},LOG_TIME,${UTC},${CDT},-,-,-,-,-" >> $fn
    #kubectl get node -o wide | tr -s '[:blank:]' ',' >> $fn
    kubectl get node --all-namespaces -o json >> $fn
    end_time=$(date +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
    let idx++
    sleep_time=$(echo "scale=3; 1.000 - $elapsed" | bc)
    echo "$idx second passed. (press ctrl-c if you want to stop) sleep_time: $sleep_time"
    sleep $sleep_time
done
