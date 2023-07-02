#!/bin/bash

source time_function.sh

fn=${CDT}-describe_deployment.log.txt
echo fn: $fn

idx=0
log_start=$(date +%s.%3N)
while [ 0 -le 1 ] # infinite loop
do
    start_time=$(date +%s.%3N)
    utc_time
    cdt_time
    echo "idx,${idx},LOG_TIME,${UTC},${CDT}" >> $fn
    kubectl describe deployment --all-namespaces >> $fn
    end_time=$(date +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
    let idx++
    sleep_time=$(echo "scale=3; 1.000 - $elapsed" | bc)
    overtime=$(echo "scale=3; 1.000 + $elapsed" | bc)

    overtime=$(echo "scale=3; $overtime*10^3" | bc ) # scale
    overtime=${overtime%.*} # float to int
    echo overtime: $overtime
    if [ $overtime -lt 1000 ]
    then
        echo "sleep_time is less than 0. (${sleep_time})"
    else
        sleep $sleep_time
        echo sleep_time: $sleep_time
    fi
    cur=$(date +%s.%3N)
    passed=$(echo "scale=3; $cur - $log_start" | bc)
    echo "idx-$idx,cur,$cur,log_start,$log_start,passed,$passed second passed. (press ctrl-c if you want to stop) sleep_time: $sleep_time"
done
