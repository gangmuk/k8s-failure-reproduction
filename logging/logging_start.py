import time
import subprocess

def print_exec_log(log):
    print("[logging_start.py],start,{}".format(log))

if __name__ == "__main__":
    log_dir="/home/gangmuk2/projects/k8s-failure-reproduction/logging"
    clear_kubelet_log = log_dir + "/bin/clear_kubelet_worker_log.sh" # clear up the past kubelet log in each node before start
    clear_scheduler_log = log_dir + "/bin/clear_scheduler_log.sh" # clear up the past scheduler log in control-plane-node before start

    record_start_time = log_dir + "/bin/record_start_time.sh"

    getpod = log_dir + "/bin/log_getpod.sh"
    getnode = log_dir + "/bin/log_getnode.sh"
    gethpa = log_dir + "/bin/log_gethpa.sh"
    getdeploy = log_dir + "/bin/log_getdeploy.sh"
    getreplicaset = log_dir + "/bin/log_getreplicaset.sh"

    describeall = log_dir + "/bin/log_describe_all.sh"
    describenode = log_dir + "/bin/log_describe_node.sh"
    describepod = log_dir + "/bin/log_describe_pod.sh"
    describedeploy = log_dir + "/bin/log_describe_deploy.sh"
    describehpa = log_dir + "/bin/log_describe_hpa.sh"

    toppod = log_dir + "/bin/log_top_pod.sh"
    topnode = log_dir + "/bin/log_top_node.sh"


    node_list = ["kind-control-plane", "kind-worker", "kind-worker2", "kind-worker3"]
    log_kubelet_process = list()
    for node in node_list:
        cmd = clear_kubelet_log + " " + node
        p = subprocess.Popen("exec " + cmd, stdout=subprocess.PIPE, shell=True)
        print_exec_log(cmd)
        time.sleep(2)
        log_kubelet_process.append(p)

    p = subprocess.Popen("exec " + clear_scheduler_log, stdout=subprocess.PIPE, shell=True)
    print_exec_log(clear_scheduler_log)
    time.sleep(1)

    command_list = [record_start_time, getpod, getnode, getdeploy, getreplicaset,  describeall, describepod, describenode, describedeploy, describehpa, gethpa, toppod, topnode]

    process_list = list()
    for cmd in command_list:
        p = subprocess.Popen("exec " + cmd, stdout=subprocess.PIPE, shell=True)
        print_exec_log(cmd)
        process_list.append(p)

    for p in process_list:
        print("pid: ", p.pid)

    time.sleep(1200) # max experiment duration: 20min
