# S7 failure case

1. Label node.
2. Go inside worker-node-1. (docker exec ...)
3. Stop kubelet. `systemctl stop kubelet`
4. Apply deployment.

After the reproduction, to return it back to the previous state.
- Remove node label.
- start kubectl. `systemctl restart kubelet`
