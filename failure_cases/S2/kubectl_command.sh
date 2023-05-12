#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

cdt_time
fn=kubectl_command-S2-${CDT}.log.txt

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

cdt_time
utc_time
echo -n "kubectl label nodes kind-worker*,label node,${CDT},${UTC}," >> ${fn}
./label_node.sh
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 5

cdt_time
utc_time
echo -n "kustomize build 'github.com/kubernetes-sigs/descheduler/kubernetes/deployment?ref=v0.26.0' | kubectl apply -f -,install descheduler deployment,${CDT},${UTC}," >> ${fn}
kustomize build 'github.com/kubernetes-sigs/descheduler/kubernetes/deployment?ref=v0.26.0' | kubectl apply -f -
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 10

cdt_time
utc_time
echo -n "kubectl apply -f descheduler-configmap.yaml,update descheduler configmap,${CDT},${UTC}," >> ${fn}
kubectl apply -f descheduler-configmap.yaml
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 10

cdt_time
utc_time
echo -n "kubectl apply -f descheduler-deployment.yaml,update descheduler deployment config,${CDT},${UTC}," >> ${fn}
kubectl apply -f descheduler-deployment.yaml
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

echo "START LOGGING!!!"
sleep 20


cdt_time
utc_time
echo -n "kubectl apply -f deploy.yaml,apply nginx deployment,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy.yaml
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 120

cdt_time
utc_time
echo -n "kubectl delete deploy/nginx-deployment,delete nginx deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/nginx-deployment
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 20

cdt_time
utc_time
echo -n "kubectl delete deploy/descheduler -n kube-system,delete descheduler deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/descheduler -n kube-system
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}

sleep 10

cdt_time
utc_time
echo -n "kubectl label --overwrite nodes kind-worker*,remove node label,${CDT},${UTC}," >> ${fn}
./remove_label.sh
cdt_time
utc_time
echo "${CDT},${UTC}" >> ${fn}
