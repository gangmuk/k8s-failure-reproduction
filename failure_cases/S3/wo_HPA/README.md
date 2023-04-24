# Failure case: S3

### Config
- Descheduler: false
- node label 
    - zone
        - kubectl label nodes kind-worker zone=A 
        - kubectl label nodes kind-worker2 zone=A
        - kubectl label nodes kind-worker3 zone=B

    - node
        - kubectl label nodes kind-worker node=1
        - kubectl label nodes kind-worker2 node=2
        - kubectl label nodes kind-worker3 node=3

### Node label output
```shell
kubectl get nodes --show-labels

NAME                                 STATUS   ROLES           AGE   VERSION   LABELS
kind-control-plane   Ready    control-plane   13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-control-plane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
kind-worker          Ready    <none>          13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-worker,kubernetes.io/os=linux,lifecycle=spot,node=1,zone=A
kind-worker2         Ready    <none>          13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-worker2,kubernetes.io/os=linux,lifecycle=spot,node=2,zone=A
kind-worker3         Ready    <none>          13d   v1.25.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=kind-worker3,kubernetes.io/os=linux,lifecycle=on-demand,node=3,zone=B
```


### Reproduction steps
1. Label nodes
    - Refer to `Config` above.
2. kubectl apply -f deploy.yaml
    - deploy.yaml has to be configured with the right topologySpreadConstraints.
