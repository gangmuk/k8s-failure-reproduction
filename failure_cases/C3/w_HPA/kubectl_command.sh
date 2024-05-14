#!/bin/bash

start_time=$(date +%s)

source /home/gangmuk2/projects/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=${CDT}-command-S3_w_HPA.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

update_time
echo "kubectl label nodes kind-worker zone=A,label node,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label nodes kind-worker2 zone=A,label node,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label nodes kind-worker3 zone=B,label node,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label nodes kind-worker node=1,label node,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label nodes kind-worker2 node=2,label node,${CDT},${UTC},-,-" >> ${fn}
echo -n "kubectl label nodes kind-worker3 node=3,label node,${CDT},${UTC}," >> ${fn}
kubectl label nodes kind-worker zone=A
kubectl label nodes kind-worker2 zone=A
kubectl label nodes kind-worker3 zone=B
kubectl label nodes kind-worker node=1
kubectl label nodes kind-worker2 node=2
kubectl label nodes kind-worker3 node=3

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl apply -f deploy_h1-app.yaml,apply h1-app deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_h1-app.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5


update_time
echo -n "kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=6,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=6

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py &

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 200

update_time
echo -n "pkill -f python3 logging_start.py,stop logging_start.py,${CDT},${UTC}," >> ${fn}
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
sleep 10

update_time
echo -n "kubectl delete deploy/h1-app,delete h1-app deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/h1-app

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1


update_time
echo -n "kubectl delete hpa/h1-app,delete hpa,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/h1-app
sleep 1

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1


update_time
echo "kubectl label --overwrite nodes kind-worker zone-,remove node label,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label --overwrite nodes kind-worker2 zone-,remove node label,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label --overwrite nodes kind-worker3 zone-,remove node label,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label --overwrite nodes kind-worker node-,remove node label,${CDT},${UTC},-,-" >> ${fn}
echo "kubectl label --overwrite nodes kind-worker2 node-,remove node label,${CDT},${UTC},-,-" >> ${fn}
echo -n "kubectl label --overwrite nodes kind-worker3 node-,remove node label,${CDT},${UTC}," >> ${fn}
kubectl label --overwrite nodes kind-worker zone-
kubectl label --overwrite nodes kind-worker2 zone-
kubectl label --overwrite nodes kind-worker3 zone-
kubectl label --overwrite nodes kind-worker node-
kubectl label --overwrite nodes kind-worker2 node-
kubectl label --overwrite nodes kind-worker3 node-

update_time
echo "${CDT},${UTC}" >> ${fn}


end_time=$(date +%s)
duration=$((end_time -start_time))

echo -n "total_runtime,${duration}" >> ${fn}
echo -n "total_runtime,${duration}"
