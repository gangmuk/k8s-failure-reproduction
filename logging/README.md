## Logging pipeline.

### What we need
1. CPU usage with timestamp (pod, node)
    - `kubectl top pod`: pod level resource util
    - `kubectl top node`: node level resource util

2. Controller logs with timestamp (listed in priority)
    - Scheduler
        - kubectl logs -n kube-system pod/kube-scheduler-kind-control-plane
    - kubelet
        - docker exec -it [kind node name] journalctl -u kubelet
    - HPA
        - `kubectl get events | grep HorizontalPodAutoscaler`
    - Deployment controller
        - kubectl logs deploy/php-apache -v=10 (nothing useful though)
    - Node controller (it does not exist. Node create and delete events are logged in `kubectl get events`.

3. kubectl events
    - kubectl get events --sort-by='.metadata.creationTimestamp' -A --output json

4. kubectl describe all
    - `kubectl describe all --all-namespaces`
