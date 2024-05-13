# k8s-failure-reproduction


<!-- ## TODO for ATC artifact evaluation
1. How to get a Kind cluster work on a Machine
2. To get the logs for model accuracy — Table 5
    - Write down the log paths for each case
3. we reproduced the failure cases that matched the issue description
    - Instruct on how to start the clusters, etc. 
    - Instruct on how to know it is a failure 
      - Which kubectl to use and what they will see
    - Instruct on where is the configs for each case 
4. Table 2, we got a smaller violation scales
    - Instruct about how to start a different number of nodes/pods – so they can use it to verify if the failure happens at Table 2
      - Drain or start a new cluster
--- -->

## Directory tree
TBD

## Summary of failure cases

| Case ID | Keyword | Description | Expected runtime for reproduction|
|------|----------|-------------|------------------|
| C1   | CPU change               |Pods consumed high CPU during bootstrapping leading HPA to scale up rapidly to max replicas              | 540s    |
| C2   | Replica field            | Not enough replicas because users applied an updated YAML file without defining number of replicas (1 by default).           | 160s    |
| C3   | PodSpreadConstraint      | Configurations of two SPTS constraints caused the 6th pod to fail to be scheduled      | 246s    |
| C5   | Scheduler + Descheduler  | Conflict configurations of scheduler and RemoveDuplicate policy in descheduler.  | 150s    |
| C6   | Node maintenance         | Pods unbalanced after maintenance. Node failures then caused the pod count to drop too low.         | 115s    |
| C7   | Infinite taint loop      | Conflicting configurations of node taint and pod NodeName caused scheduling and eviction loop               | 64s     |
| C8   | Scheduler + Descheduler  | Conflicting descheduler and scheduler configurations caused scheduling and eviction loop.  | 210s    |


## How to reproduce
1. Create right size of K8S cluster. Easist way will be using kind cluster.
2. Each failure case directory has ```kubectl_command.sh``` shell script. All you have to do is to run it.
3. Lots of K8S log will be stored in the failure case subdirectory. To evaluate fidelity of **Kivi**, we will use ```<CURRENT_TIME>-describe_all.log.txt```. It will be used as an input file to Kivi parser later.

## General flow of ```kubectl_command.sh```
The script includes a detailed logging mechanism that records each command's execution time and outcome.

1. Environment Setup
    - Loads a custom time function script for logging timestamps.
2. Logging Initialization
    - Creates a CSV log file to record the sequence of commands and their execution details.
    - Starts a Python script (logging_start.py) that presumably initiates logging.
3. Application Deployment
    - Deploys a Kubernetes application using a YAML file (deploy_h1-app.yaml).
4. Additional controller deployment (e.g., deploying autoscaler)
    - Applies an autoscaler configuration using another YAML file (autoscaler.yaml).
5. Monitoring Period
    - Includes a long enough sleep duration (e.g., 500 seconds) to observe the events in K8S.
6. Stop Initial Logging
    - Terminates the logging Python process started earlier.
7. Finishing logging and Cleanup K8S setup
    - Runs another Python script (logging_end.py) to presumably conclude the logging session.
    - Cleans up by deleting the Kubernetes deployment and the Horizontal Pod Autoscaler (HPA) configuration.

Each step is recorded in the CSV log file with timestamps for both start and end times, and the commands are executed asynchronously or with deliberate pauses (sleep). They are exhaustive logging output. You don't need to take a look at all of them.

## What ```logging_start.py``` does
1. Import Necessary Libraries
   - The script uses time for handling delays and subprocess for executing shell commands.
2. Function Definition
   - print_exec_log: A helper function that prints a formatted log message whenever a command starts. It logs the name of the command and its start time.
3. Log and Command Paths Setup
   - Defines paths to various scripts responsible for clearing logs and capturing system states. These scripts are organized under a main directory specified by log_dir.
4. Clear Logs
   - Executes scripts to clear previous logs from Kubernetes nodes (clear_kubelet_worker_log.sh) and the control plane (clear_scheduler_log.sh). These ensure that only relevant, fresh logs are collected for the session.
5. Record Start Time
   - A script is prepared (record_start_time.sh) but not executed immediately, intended to timestamp the start of the logging process.
6. Log Collection Commands Setup
   - Scripts are set up to collect various types of data:
     - Pod, node, deployment, replicaset, and HPA (Horizontal Pod Autoscaler) details.
     - Descriptions of the cluster’s overall state, individual nodes, pods, deployments, and HPAs.
     - Resource usage statistics for pods and nodes.
   - These scripts are stored in the log_dir and include operations like getpod, getnode, gethpa, etc.
7. Execution of Clearing Logs
   - The script begins by clearing logs on specified nodes (kind-control-plane, kind-worker, etc.) using the clear_kubelet_worker_log.sh script for each node.
8. Parallel Command Execution
   - Executes the log clearing for the scheduler and then runs all the collection commands in parallel using Python’s subprocess.Popen. Each command execution is logged using print_exec_log.
9. Process Monitoring
   - After starting each subprocess, the script prints the process ID for monitoring purposes. This can be useful for debugging if any subprocess does not perform as expected.
10. Wait Period
    - Ends with a sleep of 1200 seconds (20 minutes), representing the maximum experiment duration. This period allows enough time for all subprocesses to gather data before the script completes.

All the asynchronous logging running on the background will be terminated by ```logging/logging_end.py```



## How to create KinD cluster
Using kind cluster, you can create k8s cluster on one host machine. Each node will be running in a form of docker container.

To test **Kivi**'s minimum scale in Table 2, you can create a cluster with correponding number of nodes, or you can drain a node from the cluster when it is not required. For example

When you want to create a new cluster with 1/2/3 nodes in it. You can use following yaml configs in ```cluster``` directory:
```one_node_cluster.yaml```, ```three_node_cluster.yaml```,  ```two_node_cluster.yaml```

More information please refer to the official tutorial: https://kind.sigs.k8s.io/docs/user/quick-start/



<!-- ### H1(C1)

### H2(C2)

### S3(C3)
<img alt="Screenshot 2023-04-23 at 4 09 43 PM" src="https://user-images.githubusercontent.com/20127356/233866458-2104f554-f980-4b85-a677-5bb3d096e59d.png" width="500">

### S1(C5)

### S6(C6)

### D1(C7)

### S2(C8)

## Additional interesting cases

### H3
I explored this case and somewhat reproduced but didn't fully complete.
<img src="https://user-images.githubusercontent.com/20127356/231905732-4559f655-529b-4d45-9b2a-9f3431d162c5.png" width="500">

unanswered question: "Reachability vs Healthiness" -->
