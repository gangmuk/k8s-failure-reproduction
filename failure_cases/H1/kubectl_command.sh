#!/bin/bash

start_time=$(date +%s)


source /home/gangmuk2/projects/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=${CDT}-command-H1.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

update_time
echo -n "python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/projects/k8s-failure-reproduction/logging/logging_start.py &

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 10

update_time
echo -n "kubectl apply -f deploy_h1-app.yaml,apply deployment h1-app,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_h1-app.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
#echo -n "kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=10,deploy autoscaler,${CDT},${UTC}," >> ${fn}
#kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=10
#kubectl autoscale deployment h1-app --cpu-percent=50 --min=1 --max=10 --horizontal-pod-autoscaler-downscale-stabilization=60
echo -n "kubectl apply -f autoscaler.yaml,deploy autoscaler,${CDT},${UTC}," >> ${fn}
kubectl apply -f autoscaler.yaml

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 500

update_time
echo -n "pkill -f \"python3 logging_start.py\",stop logging_start.py,${CDT},${UTC}," >> ${fn}
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
echo -n "kubectl delete deploy/h1-app,delete h1-app deployment,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/h1-app

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

update_time
echo -n "kubectl delete hpa/h1-app,delete hpa,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/h1-app

update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

end_time=$(date +%s)
duration=$((end_time - start_time))

echo -n "total_runtime,${duration}" >> ${fn}
echo -n "total_runtime,${duration}"
