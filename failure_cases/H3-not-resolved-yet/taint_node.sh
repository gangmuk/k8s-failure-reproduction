## Taint kind-worker node
# php-apache pods should NOT be scheduled in this node.
# load-generator pod should be scheduled only in this node.
# load-generator deployment has toleration against this taint.
# load-generator deployment specifies this node for scheduling.

node_name=kind-worker
kubectl taint nodes ${node_name} key1=value1:NoSchedule

## Use this command when you want to remove the taint.
#kubectl taint nodes ${node_name} key1=value1:NoSchedule-
