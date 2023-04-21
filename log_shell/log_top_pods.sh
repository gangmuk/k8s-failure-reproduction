#!/bin/bash

output_file=$1
if [ -z "${output_file}" ]
then
    echo "output_file argument is missing."
    exit
fi

while [ 0 -le 1 ]
do
    kubectl top pods | tr -s '[:blank:]' ','
    echo "$i second passed. (press ctrl-c if you want to stop)"
    sleep 1
done
