# Failure case: S9

### Description


### Config
- # node: 3
- # pod: 6
- Descheduler: True
     strategies:
      "RemovePodsViolatingTopologySpreadConstraint":
         enabled: true *
         params:
           includeSoftConstraints: true *
      "RemoveDuplicates":
         enabled: false
      "RemovePodsViolatingInterPodAntiAffinity":
         enabled: true
      "RemovePodsViolatingNodeAffinity":
         enabled: false
      "RemovePodsViolatingNodeTaints":
         enabled: false
      "LowNodeUtilization":
         enabled: false
- node label 
    - kubectl label nodes kind-worker lifecycle=spot
    - kubectl label nodes kind-worker2 lifecycle=spot
    - kubectl label nodes kind-worker3 lifecycle=on-demand


### Reproduction steps
1. Set up descheduler
    - RemovePodsViolatingTopologySpreadConstraint true
1. Label nodes
    - Refer to `Config` above.
2. kubectl apply -f deploy.yaml
    - nodeAffinity 
        - Nodes labeled with spot have weight of 4.
        - Nodes labeled with on-demand have weight of 5.
        - Basically it prefers to be scheduled in on-demand nodes if possible.
    - topologySpreadConstraints
        - MaxSkew=1 for pods, scheduleAnyway.
