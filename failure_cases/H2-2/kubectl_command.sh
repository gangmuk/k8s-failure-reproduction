#!/bin/bash

source /home/gangmuk2/project/k8s-failure-reproduction/logging/bin/time_function.sh

update_time
fn=${CDT}-command-H2-2.log.csv

echo "command,keyword,start_cdt,start_utc,end_cdt,end_utc" > ${fn}

update_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py,start logging,${CDT},${UTC}," >> ${fn}
echo "logging start"
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_start.py &
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl apply -f deploy_php.yaml,apply deployment php-apache,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_php.yaml
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl autoscale deployment php-apache --cpu-percent=50 --min=3 --max=6,deploy autoscaler php-apache,${CDT},${UTC}," >> ${fn}
kubectl autoscale deployment php-apache --cpu-percent=50 --min=3 --max=6
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 45

update_time
echo -n "kubectl run -i load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c \"while sleep 0.0005; do wget -q -O- http://php-apache; done\",apply pod load-generator load,${CDT},${UTC}," >> ${fn}
/home/gangmuk2/project/k8s-failure-reproduction/failure_cases/H2-2/load_generator.sh &
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 90

update_time
echo -n "kubectl apply -f deploy_php-2.yaml,apply deployment php-apache,${CDT},${UTC}," >> ${fn}
kubectl apply -f deploy_php-2.yaml
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 50

update_time
echo -n "pkill -f \"python3 logging_start.py\",stop logging_start.py,${CDT},${UTC}," >> ${fn}
pkill -f "logging_start.py"
echo "pkill -f \"logging_start.py\""
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py,end logging,${CDT},${UTC}," >> ${fn}
python3 /home/gangmuk2/project/k8s-failure-reproduction/logging/logging_end.py
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 5

update_time
echo -n "kubectl delete pod/load-generator --grace-period=1,delete pod load-generator,${CDT},${UTC}," >> ${fn}
kubectl delete pod/load-generator --grace-period=1
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

update_time
echo -n "kubectl delete deploy/php-apache,delete deployment php-apache,${CDT},${UTC}," >> ${fn}
kubectl delete deploy/php-apache
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1

update_time
echo -n "kubectl delete hpa/php-apache,delete hpa php-apache,${CDT},${UTC}," >> ${fn}
kubectl delete hpa/php-apache
update_time
echo "${CDT},${UTC}" >> ${fn}
sleep 1
