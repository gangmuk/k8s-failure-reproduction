#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

cdt_time
fn=command-S3_w_HPA-${CDT}.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

utc_time
cdt_time
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
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

#utc_time
#cdt_time
#echo -n "kubectl apply -f deploy.yaml,apply php-apache deployment,${CDT},${UTC}," >> ${fn}
#kubectl apply -f deploy.yaml
#utc_time
#cdt_time
#echo "${CDT},${UTC}" >> ${fn}
#sleep 10

utc_time
cdt_time
echo -n "kubectl apply -f deploy_h1-app.yaml,apply h1-app deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_h1-app.yaml
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

utc_time
cdt_time
#echo -n "kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=6,deploy autoscaler,${CDT},${UTC}," >> ${fn}
#kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=6
echo -n "kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=6,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=6
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

#utc_time
#cdt_time
#echo -n "kubectl run -i load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c \"while sleep 0.001; do wget -q -O- http://php-apache; done\",start to generate load,${CDT},${UTC}," >> ${fn}
#/home/gangmuk2/project/k8s-failure-reproduction/failure_cases/S3/w_HPA/load_generator.sh &
#echo "load generation start"
#utc_time
#cdt_time
#echo "${CDT},${UTC}" >> ${fn}
#sleep 1

utc_time
cdt_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py &
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 150

utc_time
cdt_time
echo -n "pkill -f \"python3 logging_start.py\",stop logging_start.py,${CDT},${UTC}," >> ${fn}
pkill -f "logging_start.py"
echo "pkill -f \"logging_start.py\""
echo "pkill -f \"logging_start.py\""
echo "pkill -f \"logging_start.py\""
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

utc_time
cdt_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py,end logging,${CDT},${UTC}," >> ${fn}
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

utc_time
cdt_time
echo -n "kubectl delete pod/load-generator,delete load-generator pod,${CDT},${UTC}," >> ${fn}
kubectl delete pod/load-generator
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

utc_time
cdt_time
#echo -n "kubectl delete deploy/php-apache,delete php-apache deployment,${CDT},${UTC}," >> ${fn}
#kubectl delete deploy/php-apache
echo -n "kubectl delete deploy/h1-app,delete h1-app deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/h1-app
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

utc_time
cdt_time
#echo -n "kubectl delete hpa/php-apache,delete hpa,${CDT},${UTC}," >> ${fn}
#kubectl delete hpa/php-apache
echo -n "kubectl delete hpa/h1-app,delete hpa,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/h1-app
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

utc_time
cdt_time
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
utc_time
cdt_time
echo "${CDT},${UTC}" >> ${fn}
