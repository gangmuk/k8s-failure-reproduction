#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

cdt_time
fn=kubectl_command-S6-${UTC}.log.txt

echo "command,start_cdt,start_utc,end_cdt,end_utc" >> ${fn}

cdt_time
utc_time
echo -n "kubectl apply -f deploy.yaml,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy.yaml
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 10

cdt_time
utc_time
echo -n "kubectl drain kind-worker --ignore-daemonsets --delete-emptydir-data,${CDT},${UTC}," >> ${fn}
kubectl drain kind-worker --ignore-daemonsets --delete-emptydir-data
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 5

cdt_time
utc_time
echo -n "kubectl uncordon kind-worker,${CDT},${UTC}," >> ${fn}
kubectl uncordon kind-worker
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 5

cdt_time
utc_time
echo -n "kubectl drain kind-worker3 --ignore-daemonsets --delete-emptydir-data,${CDT},${UTC}," >> ${fn}
kubectl drain kind-worker3 --ignore-daemonsets --delete-emptydir-data
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 5

cdt_time
utc_time
echo -n "kubectl uncordon kind-worker3,${CDT},${UTC}," >> ${fn}
kubectl uncordon kind-worker3
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 10
kubectl delete deploy/php-apache
