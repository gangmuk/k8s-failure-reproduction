import time
import subprocess

if __name__ == "__main__":
    log_dir="/home/gangmuk2/project/k8s-failure-reproduction/logging"
    record_start_time = log_dir + "/bin/record_start_time.sh"
    getpod = log_dir + "/bin/log_getpod.sh"
    getnode = log_dir + "/bin/log_getnode.sh"
    describeall = log_dir + "/bin/log_describe_all.sh"
    gethpa = log_dir + "/bin/log_gethpa.sh"
    toppod = log_dir + "/bin/log_top_pod.sh"
    topnode = log_dir + "/bin/log_top_node.sh"

    command_list = [record_start_time, getpod, getnode, describeall, gethpa, toppod, topnode]
    print("command list: ", command_list)

    process_list = list()
    for cmd in command_list:
        p = subprocess.Popen("exec " + cmd, stdout=subprocess.PIPE, shell=True)
        process_list.append(p)

    for p in process_list:
        print("pid: ", p.pid)

    time.sleep(1200) # max experiment duration: 20min
