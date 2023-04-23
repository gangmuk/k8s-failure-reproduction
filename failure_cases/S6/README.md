# Failure case: S6
### Config
- num of nodes: 3
- num of pods: 3
- descheduler: false
- hpa: false (you can turn on hpa to deteriorate the situation.)

### Failure trigger steps
1. `kubectl apply -f deploy_php.yaml`
2. Since there is no constraints or taint in pod scheduling, each pod is scheduled in each node.
    - node 1 - pod 1
    - node 2 - pod 2
    - node 3 - pod 3
3. Drain one node. It will evict the scheduled pod and make the node unschedulable.
    - `kubectl drain kind-worker3 --ignore-daemonsets`
    - node 1 - pod 1
    - node 2 - pod 2, pod 3
    - node 3 - UnSchedulalbe
4. Uncordon node 3.
    - `kubectl uncordon kind-worker3`
    - The idea pod spreading schedule is one pod per node. However, because there is no descheduler, pod 3 will not be evicted from node 2.
    - node 1 - pod 1
    - node 2 - pod 2, pod 3
    - node 3 - UnSchedulalbe
5. (optional) Drain another node, for example node 2.
    - `kubectl drain kind-worker2 --ignore-daemonsets`
    - node 1 - pod 1, pod3
    - node 2 - UnSchedulable
    - node 3 - pod 2
