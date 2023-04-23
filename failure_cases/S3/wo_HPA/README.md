# Descheduler
Delete descheduler deployment or turn off all plugins in descheduler.

# node label 
## zone
kubectl label nodes three-worker-cluster-worker zone=A 
kubectl label nodes three-worker-cluster-worker2 zone=A
kubectl label nodes three-worker-cluster-worker3 zone=B

## node
kubectl label nodes three-worker-cluster-worker node=1
kubectl label nodes three-worker-cluster-worker2 node=2
kubectl label nodes three-worker-cluster-worker3 node=3

## get node output
```shell
kubectl get nodes --show-labels
NAME                                 STATUS   ROLES           AGE   VERSION   LABELS
three-worker-cluster-control-plane   Ready    control-plane   13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=three-worker-cluster-control-plane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
three-worker-cluster-worker          Ready    <none>          13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=three-worker-cluster-worker,kubernetes.io/os=linux,lifecycle=spot,node=1,zone=A
three-worker-cluster-worker2         Ready    <none>          13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=three-worker-cluster-worker2,kubernetes.io/os=linux,lifecycle=spot,node=2,zone=A
three-worker-cluster-worker3         Ready    <none>          13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=three-worker-cluster-worker3,kubernetes.io/os=linux,lifecycle=on-demand,node=3,zone=B
```
