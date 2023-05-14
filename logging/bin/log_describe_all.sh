#!/bin/bash

source time_function.sh

#CURRENT_TIME=`date +"%Y%m%d_%H%M%S"`
fn=${CDT}-describe_all.log
echo fn: $fn

idx=0
while [ 0 -le 1 ] # infinite loop
do
    start_time=$(date +%s.%3N)
    utc_time
    cdt_time
    echo "idx,${idx},LOG_TIME,${UTC},${CDT}" >> $fn
    kubectl describe all --all-namespaces >> $fn
    end_time=$(date +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
    let idx++
    sleep_time=$(echo "scale=3; 1.000 - $elapsed" | bc)
    if [ "$sleep_time" -lt 0 ]
        echo "sleep_time is less than 0. (${sleep_time})"
    then
    else
        sleep $sleep_time
    fi
    echo "$idx second passed. (press ctrl-c if you want to stop) sleep_time: $sleep_time"
done
