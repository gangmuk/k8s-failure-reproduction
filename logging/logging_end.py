import os
import time
import signal
import subprocess

if __name__ == "__main__":
    log_dir="/home/gangmuk2/projects/k8s-failure-reproduction/logging"
    node_list = ["kind-control-plane", "kind-worker", "kind-worker2", "kind-worker3"]
    log_kubelet = log_dir + "/bin/log_kubelet_worker.sh"
    log_kubelet_process = list()
    for node in node_list:
        cmd = log_kubelet + " " + node
        p = subprocess.Popen("exec " + cmd, stdout=subprocess.PIPE, shell=True)
        log_kubelet_process.append(p) 

    log_getevent = log_dir + "/bin/log_get_event.sh"
    log_scheduler = log_dir + "/bin/log_scheduler.sh"
    record_end_time = log_dir + "/bin/record_end_time.sh"
    p2 = subprocess.Popen("exec " + log_getevent, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    p3 = subprocess.Popen("exec " + log_scheduler, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    p4 = subprocess.Popen("exec " + record_end_time, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)

    print("Wait for it!")
    time.sleep(10)
