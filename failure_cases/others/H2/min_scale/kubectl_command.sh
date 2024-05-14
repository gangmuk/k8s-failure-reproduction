#!/bin/bash

source /home/gangmuk2/projects/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=${CDT}-command-H2.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

update_time
echo -n "python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py &

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10


#####################################################

update_time
echo -n "kubectl apply -f nginx_1.yaml,apply deployment nginx-1,${CDT},${UTC}," >> ${fn}
kubectl apply -f nginx_1.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

update_time
echo -n "kubectl autoscale deployment nginx-deployment --cpu-percent=50 --min=3 --max=5,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment nginx-deployment --cpu-percent=50 --min=2 --max=5

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 20

update_time
echo -n "kubectl apply -f nginx_2.yaml,apply deployment nginx-2,${CDT},${UTC}," >> ${fn}
kubectl apply -f nginx_2.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 60

#####################################################

update_time
echo -n "pkill -f python3 logging_start.py,stop logging_start.py,${CDT},${UTC}," >> ${fn}
pkill -f "logging_start.py"
echo "pkill -f \"logging_start.py\""

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_end.py,end logging,${CDT},${UTC}," >> ${fn}
python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_end.py

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl delete hpa/nginx-deployment, delete hpa,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/nginx-deployment

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl delete deploy/nginx-deployment,delete nginx deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/nginx-deployment

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5


echo -n "DONE"
update_time
echo "${CDT},${UTC}" >> ${fn}
