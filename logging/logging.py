import os
import time
import signal
import subprocess

def handler(signum, frame):
    node_list = ["kind-control-plane", "kind-worker", "kind-worker2", "kind-worker3"]
    log_kubelet = "./bin/log_kubelet_worker.sh"
    log_kubelet_process = list()
    for node in node_list:
        cmd = log_kubelet + " " + node
        p = subprocess.Popen("exec " + cmd, stdout=subprocess.PIPE, shell=True)
        log_kubelet_process.append(p) 

    log_getevent = "./bin/log_get_event.sh"
    record_end_time = "./bin/record_end_time.sh"
    p2 = subprocess.Popen("exec " + log_getevent, stdout=subprocess.PIPE, shell=True)
    p3 = subprocess.Popen("exec " + record_end_time, stdout=subprocess.PIPE, shell=True)

    print("Wait for it!")
    time.sleep(1)

    for p in log_kubelet_process:
        os.kill(p.pid, signal.SIGTERM)
        print("kill process ", p.pid)
    os.kill(p2.pid, signal.SIGTERM)
    os.kill(p3.pid, signal.SIGTERM)
    print("kill process ", p2.pid)
    print("kill process ", p3.pid)
    
    for p in process_list:
        print("kill process ", p.pid)
        os.kill(p.pid, signal.SIGTERM)
    exit(1)
 
signal.signal(signal.SIGINT, handler)

if __name__ == "__main__":
    record_start_time = "./bin/record_start_time.sh"
    getpod = "./bin/log_getpod.sh"
    getnode = "./bin/log_getnode.sh"
    describeall = "./bin/log_describe_all.sh"
    gethpa = "./bin/log_gethpa.sh"
    toppod = "./bin/log_top_pod.sh"
    topnode = "./bin/log_top_node.sh"

    command_list = [record_start_time, getpod, getnode, describeall, gethpa, toppod, topnode]
    print("command list: ", command_list)

    process_list = list()
    for cmd in command_list:
        p = subprocess.Popen("exec " + cmd, stdout=subprocess.PIPE, shell=True)
        process_list.append(p)

    for p in process_list:
        print("pid: ", p.pid)

    time.sleep(300) # max experiment duration: 5 min

