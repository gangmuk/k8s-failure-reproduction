#!/bin/bash

source time_function.sh

#CURRENT_TIME=`date +"%Y%m%d_%H%M%S"`
fn=${CDT}-topnode.log.csv
echo fn: $fn

idx=0
while [ 0 -le 1 ] # infinite loop
do
    start_time=$(date +%s.%3N)
    echo "idx,${idx},LOG_TIME,${UTC},${CDT}" >> $fn
    kubectl top node | tr -s '[:blank:]' ',' >> $fn
    end_time=$(date +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
    let idx++
    sleep_time=$(echo "scale=3; 1.000 - $elapsed" | bc)
    echo "$idx second passed. (press ctrl-c if you want to stop) sleep_time: $sleep_time"
    sleep $sleep_time
done
