#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=${CDT}-command-H2-2.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

update_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py &

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl apply -f deploy_h1-app-wo_replica.yaml,apply deployment h1-app,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_h1-app-wo_replica.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl autoscale deployment h1-app --cpu-percent=50 --min=3 --max=6,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment h1-app --cpu-percent=50 --min=3 --max=6

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 120

update_time
echo -n "kubectl apply -f deploy_h1-app-with_replica.yaml,apply deployment h1-app,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_h1-app-with_replica.yaml
echo "kubectl apply -f deploy_h1-app-with_replica.yaml"
echo "kubectl apply -f deploy_h1-app-with_replica.yaml"
echo "kubectl apply -f deploy_h1-app-with_replica.yaml"
echo "kubectl apply -f deploy_h1-app-with_replica.yaml"
echo "kubectl apply -f deploy_h1-app-with_replica.yaml"

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 60

update_time
echo -n "pkill -f \"python3 logging_start.py\",stop logging_start.py,${CDT},${UTC}," >> ${fn}
pkill -f "logging_start.py"
echo "pkill -f \"logging_start.py\""

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py,end logging,${CDT},${UTC}," >> ${fn}
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl delete deploy/h1-app,delete deployment h1-app,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/h1-app

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

update_time
echo -n "kubectl delete hpa/h1-app,delete hpa h1-app,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/h1-app

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1
