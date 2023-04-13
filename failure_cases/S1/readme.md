1. Install Descheduler.
2. Check if RemoveDuplicate plugin in the descheduler is turned on.
    - kubectl edit configmap -n kube-system descheduler-policy-configmap
3. Create apply deployment having 4 replicas to a cluster having only three nodes.
4. Inevitably, two pods will be scheduled in the same node. (4 pods, 3 nodes). However, the descheduler will NOT evict one pod in the same node.


This bug is fixed. Deschduler adjusts the number of feasible nodes before it blindly deschedules duplicate pods.
