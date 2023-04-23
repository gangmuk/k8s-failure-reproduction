# tc should be executed in the source.

dst_ip=$1
if [ -z "$dst_ip" ]
then
    echo "\$dst_ip is empty"
    echo "exit..."
    exit
else
    echo "dst_ip: ${dst_ip}"
fi

tc qdisc del dev eth0 root;
tc qdisc add dev eth0 root handle 1: prio;
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst ${dst_ip} flowid 2:1;

## packet delay
tc qdisc add dev eth0 parent 1:1 handle 2: netem delay 50ms; 
echo "Apply 50ms packet delay from this node/pod to ${dst_ip}"

## packet loss
#tc qdisc add dev eth0 parent 1:1 handle 2: netem loss 100% 
#echo "Apply 100\% packet loss from this node/pod to ${dst_ip}"
