#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

cdt_time
fn=command-H1-${CDT}.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

cdt_time
utc_time
echo -n "kubectl apply -f deploy_h1-app.yaml,apply custom h1 app deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_h1-app.yaml
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

cdt_time
utc_time
echo -n "kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=10,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=10
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

cdt_time
utc_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py &
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 90


cdt_time
utc_time
echo -n "pkill -f \"python3 logging_start.py\",stop logging_start.py,${CDT},${UTC}," >> ${fn}
pkill -f "logging_start.py"
echo "pkill -f \"logging_start.py\""
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

cdt_time
utc_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py,end logging,${CDT},${UTC}," >> ${fn}
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

cdt_time
utc_time
echo -n "kubectl delete deploy/h1-app,delete h1-app deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/h1-app
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

cdt_time
utc_time
echo -n "kubectl delete hpa/h1-app,delete hpa,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/h1-app
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1
