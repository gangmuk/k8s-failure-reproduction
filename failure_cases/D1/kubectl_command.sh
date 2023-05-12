#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

cdt_time
fn=kubectl_command-D1-${CDT}.log.txt

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" >> ${fn}

cdt_time
utc_time
echo -n "kubectl taint nodes kind-worker key1=value1:NoExecute,taint node,${CDT},${UTC}," >> ${fn}
kubectl taint nodes kind-worker key1=value1:NoExecute
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 5

cdt_time
utc_time
echo -n "kubectl apply -f deploy.yaml,apply deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy.yaml
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 10

cdt_time
utc_time
echo -n "kubectl delete deploy/php-apache,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/php-apache
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 3

cdt_time
utc_time
echo -n "kubectl taint nodes kind-worker key1=value1:NoExecute-,remove taint node,${CDT},${UTC}," >> ${fn}
kubectl taint nodes kind-worker key1=value1:NoExecute-
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
