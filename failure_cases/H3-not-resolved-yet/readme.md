## Unreachable pod + HPA(metrics-server) CPU utilization calculation

1. Deploy two replicas.
2. Deploy HPA for the deployment.
3. Generate load to the deployment.
4. Make one replica unreachable.
    - 

### How to make a node unreachable.
#### Bringing interfaces up/down
Two methods can be used to bring interfaces up or down.
2.1. Using "ip"
- Usage:
```shell
# ip link set dev <interface> up
# ip link set dev <interface> down
```
- Example:
```shell
# ip link set dev eth0 up
# ip link set dev eth0 down
```

2.2. Using "ifconfig"
- Usage:
```shell
# /sbin/ifconfig <interface> up
# /sbin/ifconfig <interface> down
```
- Example:
```shell
# /sbin/ifconfig eth0 up
# /sbin/ifconfig eth0 down
```
