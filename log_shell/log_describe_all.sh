#!/bin/bash
CURRENT_TIME=`date +"%Y%m%d_%H%M%S"`
fn=${CURRENT_TIME}_describe_all.log
echo fn: $fn

idx=0
while [ 0 -le 1 ] # infinite loop
do
    start_time=$(date +%s.%3N)
    echo "========== DELIMETER: $idx ==========" >> $fn
    #kubectl describe all --all-namespaces | tr -s '[:blank:]' ',' >> ${CURRENT_TIME}_describe_all.log.csv
    kubectl describe all --all-namespaces >> $fn
    end_time=$(date +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
    # echo write operation latency: $elapsed
    #let "idx = $idx + 1"
    let idx++
    sleep_time=$(echo "scale=3; 1.000 - $elapsed" | bc)
    echo "$idx second passed. (press ctrl-c if you want to stop) sleep_time: $sleep_time"
    sleep $sleep_time
done
