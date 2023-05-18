#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

cdt_time
fn=command-S3_w_HPA${CDT}.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

cdt_time
utc_time
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
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

cdt_time
utc_time
echo -n "kubectl apply -f deploy.yaml,apply php-apache deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy.yaml
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

cdt_time
utc_time
echo -n "kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=6,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=6
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 30

cdt_time
utc_time
echo -n "kubectl run -i load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c \"while sleep 0.001; do wget -q -O- http://php-apache; done\",start to generate load,${CDT},${UTC}," >> ${fn}
/home/gangmuk2/project/k8s-failure-reproduction/failure_cases/S3/w_HPA/load_generator.sh &
echo "load generation start"
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
sleep 30


cdt_time
utc_time
echo -n "pkill -f \"python3 logging_start.py\",stop logging_start.py,${CDT},${UTC}," >> ${fn}
pkill -f "logging_start.py"
echo "pkill -f \"logging_start.py\""
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

cdt_time
utc_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py,end logging,${CDT},${UTC}," >> ${fn}
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

cdt_time
utc_time
echo -n "kubectl delete pod/load-generator,delete load-generator pod,${CDT},${UTC}," >> ${fn}
kubectl delete pod/load-generator
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

cdt_time
utc_time
echo -n "kubectl delete deploy/php-apache,delete php-apache deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/php-apache
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

cdt_time
utc_time
echo -n "kubectl delete hpa/php-apache,delete hpa,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/php-apache
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

cdt_time
utc_time
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
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
