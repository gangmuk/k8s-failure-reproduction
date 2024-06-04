#!/bin/bash

function count_loc_without_comment_and_blankline() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <file-path>"
        exit 1
    fi

    file_path="$1"
    if [ ! -f "$file_path" ]; then
        echo "File does not exist: $file_path"
        exit 1
    fi

    # Filter out lines that start with // and blank lines, then count the remaining lines
    # line_count=$(wc -l < "$file_path")
    # line_count=$(grep -v '^\s*//' "$file_path" | wc -l)
    line_count=$(grep -v '^\s*//' "$file_path" | grep -v '^\s*$' | wc -l)
    echo "${file_path},${line_count}"
}


# deployment controller
deployment_files=(
    "./kubernetes/pkg/controller/deployment/deployment_controller.go"
    "./kubernetes/pkg/controller/deployment/recreate.go"
    "./kubernetes/pkg/controller/deployment/rolling.go"
)

#replicaset controller
replicaset_files=(
    "./kubernetes/pkg/controller/replication/replication_controller.go"
)

# scheduler
scheduler_files=(
    "./kubernetes/pkg/scheduler/schedule_one.go"
    "./kubernetes/pkg/scheduler/scheduler.go"
    "./kubernetes/pkg/scheduler/framework/plugins/tainttoleration/taint_toleration.go"
    "./kubernetes/pkg/scheduler/framework/plugins/podtopologyspread/plugin.go"
    "./kubernetes/pkg/scheduler/framework/plugins/podtopologyspread/filtering.go"
    "./kubernetes/pkg/scheduler/framework/plugins/nodeaffinity/node_affinity.go"
    "./kubernetes/pkg/scheduler/framework/plugins/noderesources/fit.go"
    "./kubernetes/pkg/scheduler/framework/plugins/noderesources/resource_allocation.go"
    "./kubernetes/pkg/scheduler/framework/plugins/noderesources/balanced_allocation.go"
    "./kubernetes/pkg/scheduler/framework/plugins/noderesources/least_allocated.go"
    "./kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go"
    "./kubernetes/pkg/scheduler/framework/interface.go"
    # "./kubernetes/pkg/scheduler/framework/plugins/noderesources/most_allocated.go "
    "./kubernetes/pkg/scheduler/framework/plugins/noderesources/requested_to_capacity_ratio.go"
)

# hpa
hpa_files=(
 "./kubernetes/pkg/controller/podautoscaler/horizontal.go"
)

# kubelet
kubelet_files=(
    "./kubernetes/pkg/kubelet/kubelet.go"
    "./kubernetes/pkg/kubelet/runonce.go"
)

# node controller (taint manager)
nodecontroller_files=(
    "./kubernetes/pkg/controller/nodelifecycle/node_lifecycle_controller.go"
    "./kubernetes/pkg/controller/nodelifecycle/scheduler/taint_manager.go"
)

# descheduler
descheduler_files=(
    "./descheduler/pkg/descheduler/descheduler.go"
    "./descheduler/pkg/framework/plugins/removepodsviolatingtopologyspreadconstraint/topologyspreadconstraint.go"
    "./descheduler/pkg/framework/plugins/removeduplicates/removeduplicates.go"
    "./descheduler/pkg/descheduler/evictions/evictions.go"
    "./descheduler/pkg/framework/profile/profile.go"
)

# Loop through each file path and call the count_loc function
all_files=(
    "${deployment_files[@]}"
    "${replicaset_files[@]}"
    "${scheduler_files[@]}"
    "${hpa_files[@]}"
    "${kubelet_files[@]}"
    "${nodecontroller_files[@]}"
    "${descheduler_files[@]}"
)

# Loop through each file path and call the count_loc function
for file_path in "${all_files[@]}"; do
    count_loc_without_comment_and_blankline $file_path
done