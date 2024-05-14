## Steps
1. Deploy at least two replicas of php-apache applications.
2. Deploy HPA for the deployment.
3. Deploy load-generator pod. Load-generator pod has to be bound to one node. In this example, it is `kind-worker`.
4. Make one php-pod (e.g., php-pod-1) unreachable from the node having load-generator pod.
    - There could be various way to make the pod or node unreachable. In this particular failure reproduction, we will use pakcet loss in linux tc command. All packets outbounding from the **node** having load generator to the **php-pod-1**. 
5. Generate load.
    - Problem: **BUT here is the problem. Since wget http request is close loop, it will be blocked by the response from php-pod-1.**
    - Solution: Run wget command with `&`. `&` linux command lets you run command in background. `php-pod-1` will not respond because we configure 100% packet loss. CPU utilization of `php-pod-1` will not change (0%). CPU utilization of `php-pod-2` will increase (e.g., 40%) since `php-pod-2` processes incoming requests. Solution is always so simple.
    Then, the average CPU utilization calculated by HPA will be (40% + 0%)/2 = 20%. However, our expectation is 40% because we don't want to count `php-pod-1` as a part of active pod. Potentially controversial but this is our interpretation of this scenario. 

6. See how HPA calculates the average CPU utilization.
    - Does HPA include pod-1 in the average CPU utilization calculation or not?
    - Does the load generator redirect the drop request to other reachable pods?

## How to make a pod/node unreachable.
### Making a pod unreachable from a specific pod
#### Linux tc command.
Run it in the source.
```shell
tc qdisc del dev eth0 root;
tc qdisc add dev eth0 root handle 1: prio;
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst ${dst_ip} flowid 2:1;
tc qdisc add dev eth0 parent 1:1 handle 2: netem loss 100%
```

### Making a node unreachable. 
#### NOT WORKING: Bringing network interfaces up/down.
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
