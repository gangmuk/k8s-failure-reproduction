## Logging pipeline.

### What we need
1. CPU usage with timestamp (pod, node)
    - `kubectl top pod`: pod level resource util
    - `kubectl top node`: node level resource util
2. Controller logs with timestamp (listed in priority)
    - Scheduler: kubectl logs -n kube-system pod/kube-scheduler-kind-control-plane
    - Deployment controller
        - kubectl logs deploy/php-apache -v=10 (nothing useful though)
    - kubelet
        - `docker exec -it [kind node name] journalctl -u kubelet`
    - Node controller
3. kubectl events
    - `kubectl get events --sort-by='.metadata.creationTimestamp' -A`: It outputs the ScaleReplica log.
3. kubectl describe all with timestamp
    - HPA
        - `kubectl describe all --all-namespaces`
        - `kubectl get events | grep HorizontalPodAutoscaler`
