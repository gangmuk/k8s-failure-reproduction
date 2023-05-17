#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=${CDT}-command-H1.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

update_time
echo -n "kubectl apply -f deploy_h1-app.yaml,apply custom h1 app deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_h1-app.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

update_time
echo -n "kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=10,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=10

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

update_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py &

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 150


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
echo -n "kubectl delete deploy/h1-app,delete h1-app deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/h1-app

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

update_time
echo -n "kubectl delete hpa/h1-app,delete hpa,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/h1-app

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1
