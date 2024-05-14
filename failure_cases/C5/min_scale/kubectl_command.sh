#!/bin/bash

source /home/gangmuk2/projects/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=${CDT}-command-S1.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

update_time
echo -n "python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py &

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

update_time
echo -n "kustomize build 'github.com/kubernetes-sigs/descheduler/kubernetes/deployment?ref=v0.26.0' | kubectl apply -f -,install descheduler deployment,${CDT},${UTC}," >> ${fn}
kustomize build 'github.com/kubernetes-sigs/descheduler/kubernetes/deployment?ref=v0.26.0' | kubectl apply -f -

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl apply -f descheduler-configmap.yaml,update descheduler configmap,${CDT},${UTC}," >> ${fn}
kubectl apply -f descheduler-configmap.yaml
sleep 5

update_time
echo -n "kubectl apply -f descheduler-deployment.yaml,update descheduler deployment config,${CDT},${UTC}," >> ${fn}
kubectl apply -f descheduler-deployment.yaml
sleep 5

update_time
echo -n "kubectl apply -f deploy_background_1.yaml,apply background_1 deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_background_1.yaml
sleep 5

#update_time
#echo -n "kubectl apply -f deploy_background_2.yaml,apply background_2 deployment,${CDT},${UTC}," >> ${fn}
#kubectl apply -f deploy_background_2.yaml
#sleep 5

update_time
echo -n "kubectl apply -f deploy_foreground.yaml,apply foreground deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_foreground.yaml
sleep 5

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 60

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
sleep 5

update_time
echo -n "kubectl delete deploy/background-1,delete background-1 deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/background-1

#update_time
#echo -n "kubectl delete deploy/background-2,delete background-2 deployment,${CDT},${UTC}," >> ${fn}
#kubectl delete deploy/background-2

update_time
echo -n "kubectl delete deploy/nginx-deployment,delete nginx deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/nginx-deployment

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 20

update_time
echo -n "kubectl delete deploy/descheduler -n kube-system,delete descheduler deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/descheduler -n kube-system

echo -n "DONE"
update_time
echo "${CDT},${UTC}" >> ${fn}
