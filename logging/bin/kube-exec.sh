#!/bin/bash

pod_name=$1
if [ -z "${pod_name}" ]
then
    echo "\$pod_name is empty"
    echo "exit..."
    exit
else
    echo "pod_name: ${pod_name}"
fi

kubectl exec --stdin --tty pod/${pod_name} -- /bin/sh