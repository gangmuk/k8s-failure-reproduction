#!/bin/bash

CURRENT_TIME=`date +"%Y%m%d_%H%M%S"`
fn=${CURRENT_TIME}_getpods.log.csv
echo fn: $fn

idx=0
while [ 0 -le 1 ] # infinite loop
do
    start_time=$(date +%s.%3N)
    echo "========== DELIMETER: $idx ==========" >> $fn
    kubectl get pods -o wide | tr -s '[:blank:]' ',' >> $fn
    end_time=$(date +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
    #echo write operation latency: $elapsed
    echo "$ts second passed. (press ctrl-c if you want to stop)"
    #let "idx = $idx + 1"
    let idx++
    sleep_time=$(echo "scale=3; 1.000 - $elapsed" | bc)
    echo sleep_time: $sleep_time
    sleep $sleep_time
done
