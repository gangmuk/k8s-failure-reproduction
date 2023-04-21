# Descheduler
Delete descheduler deployment or turn off all plugins in descheduler.

# node label 
kubectl label nodes kind-worker node=1
kubectl label nodes kind-worker2 node=2
kubectl label nodes kind-worker3 node=3

## get node output
```shell
$ kubectl get nodes --show-labels

NAME                 STATUS   ROLES           AGE   VERSION   LABELS
kind-control-plane   Ready    control-plane   32m   v1.24.7   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-control-plane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
kind-worker          Ready    <none>          32m   v1.24.7   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-worker,kubernetes.io/os=linux,node=1
kind-worker2         Ready    <none>          32m   v1.24.7   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-worker2,kubernetes.io/os=linux,node=2
kind-worker3         Ready    <none>          32m   v1.24.7   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-worker3,kubernetes.io/os=linux,node=3
```
