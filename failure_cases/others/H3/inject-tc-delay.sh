#!/bin/bash

controlplane_pod_ip=$(kubectl get pods -n kube-system $(kubectl get pods -n kube-system -l=component=kube-controller-manager,tier=control-plane -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.status.podIP}')
controlplane_pod_name=$(kubectl get pods -n kube-system $(kubectl get pods -n kube-system -l=component=kube-controller-manager,tier=control-plane -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.metadata.name}')

api_server_pod_ip=$(kubectl get pods -n kube-system $(kubectl get pods -n kube-system -l=component=kube-apiserver,tier=control-plane -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.status.podIP}')
api_server_pod_name=$(kubectl get pods -n kube-system $(kubectl get pods -n kube-system -l=component=kube-apiserver,tier=control-plane -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.metadata.name}')

metrics_server_pod_ip=$(kubectl get pods -n kube-system $(kubectl get pods -n kube-system -l=k8s-app=metrics-server -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.status.podIP}')
metrics_server_pod_name=$(kubectl get pods -n kube-system $(kubectl get pods -n kube-system -l=k8s-app=metrics-server -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.metadata.name}')

php_pod_ip=$(kubectl get pod $(kubectl get pods -l=run=php-apache -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.status.podIP}')
php_pod_name=$(kubectl get pod $(kubectl get pods -l=run=php-apache -o jsonpath='{.items[0].metadata.name}') -o jsonpath='{.metadata.name}')

echo "* controlplane_pod_name: $controlplane_pod_name"
echo "* controlplane_pod_ip: $controlplane_pod_ip"
echo "* api_server_pod_name: $api_server_pod_name"
echo "* api_server_pod_ip: $api_server_pod_ip"
echo "* metrics_server_pod_name: $metrics_server_pod_name"
echo "* metrics_server_pod_ip: $metrics_server_pod_ip"
echo "* php_pod_ip: $php_pod_ip"
echo "* php_pod_name: $php_pod_name"

# delete existing qdisc rules
kubectl exec --stdin --tty pod/${php_pod_name} -- tc qdisc del dev eth0 root;

# add 50ms network delay outgoing from the specific php_pod to metrics_server_pod_ip
kubectl exec --stdin --tty pod/${php_pod_name} -- tc qdisc add dev eth0 root handle 1: prio;
kubectl exec --stdin --tty pod/${php_pod_name} -- tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst ${metrics_server_pod_ip} flowid 2:1;
kubectl exec --stdin --tty pod/${php_pod_name} -- tc qdisc add dev eth0 parent 1:1 handle 2: netem delay 50ms;

# 100% packet loss outgoing from the specific php_pod.
# kubectl exec --stdin --tty pod/${php_pod_name} -- tc qdisc add dev eth0 parent 1:1 handle 2: netem loss 100%;
