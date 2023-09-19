#!/bin/bash

source /home/gangmuk2/projects/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=kubectl_command-S6-${UTC}.log.txt

echo "command,start_cdt,start_utc,end_cdt,end_utc" >> ${fn}

update_time
echo -n "python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py,start logging
,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py &

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

update_time
echo -n "kubectl apply -f deploy.yaml,apply deployment php-apache,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

update_time
echo -n "kubectl drain kind-worker --ignore-daemonsets --delete-emptydir-data,drain kind-worker node,${CDT},${UTC}," >> ${fn}
kubectl drain kind-worker --ignore-daemonsets --delete-emptydir-data

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 15

update_time
echo -n "kubectl uncordon kind-worker,uncordon kind-worker,${CDT},${UTC}," >> ${fn}
kubectl uncordon kind-worker

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 15

update_time
echo -n "kubectl drain kind-worker3 --ignore-daemonsets --delete-emptydir-data,drain kind-worker3,${CDT},${UTC}," >> ${fn}
kubectl drain kind-worker3 --ignore-daemonsets --delete-emptydir-data

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 15

update_time
echo -n "kubectl uncordon kind-worker3,uncordon kind-worker3,${CDT},${UTC}," >> ${fn}
kubectl uncordon kind-worker3

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 15

update_time
echo -n "pkill -f \"python3 logging_start.py\",stop logging_start.py,${CDT},${UTC}," >> ${fn}
pkill -f "logging_start.py"
echo "pkill -f \"logging_start.py\""

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_end.py,end logging,${CDT},${UTC}," >> ${fn}
python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_end.py

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl delete deploy/php-apache,delete php-apache deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/php-apache

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10
