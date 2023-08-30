#!/bin/bash


function kusage_short() {
    # Function returning resources usage on current kubernetes cluster
	local node_count=0
	local total_percent_cpu=0
	local total_percent_mem=0

    echo "NODE, CPU_allocatable, Memory_allocatable, CPU_requests%, Memory_requests%, CPU_limits%, Memory_limits%,"
	for n in $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name); do
		local requests=$(kubectl describe node $n | grep -A2 -E "Resource" | tail -n1 | tr -d '(%)')
        local abs_cpu=$(echo $requests | awk '{print $2}')
		local percent_cpu=$(echo $requests | awk '{print $3}')
        local node_cpu=$(echo $abs_cpu $percent_cpu | tr -d 'mKi' | awk '{print int($1/$2*100)}')
        local allocatable_cpu=$(echo $node_cpu $abs_cpu | tr -d 'mKi' | awk '{print int($1 - $2)}')
        local percent_cpu_lim=$(echo $requests | awk '{print $5}')
        local requests=$(kubectl describe node $n | grep -A3 -E "Resource" | tail -n1 | tr -d '(%)')
        local abs_mem=$(echo $requests | awk '{print $2}')
		local percent_mem=$(echo $requests | awk '{print $3}')
        local node_mem=$(echo $abs_mem $percent_mem | tr -d 'mKi' | awk '{print int($1/$2*100)}')
        local allocatable_mem=$(echo $node_mem $abs_mem | tr -d 'mKi' | awk '{print int($1 - $2)}')
        local percent_mem_lim=$(echo $requests | awk '{print $5}')
		echo "$n, ${allocatable_cpu}m, ${allocatable_mem}Ki, ${percent_cpu}%, ${percent_mem}%, ${percent_cpu_lim}%, ${percent_mem_lim}%"

		node_count=$((node_count + 1))
		total_percent_cpu=$((total_percent_cpu + percent_cpu))
		total_percent_mem=$((total_percent_mem + percent_mem))
	done

	local avg_percent_cpu=$((total_percent_cpu / node_count))
	local avg_percent_mem=$((total_percent_mem / node_count))

	echo "Average usage (requests) : ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory."
}

function kusage_comma() {
    # Function returning resources usage on current kubernetes cluster
	local node_count=0
	local total_percent_cpu=0
	local total_percent_mem=0

    echo "NODE,, CPU_allocatable, Memory_allocatable, CPU_requests%, Memory_requests%, CPU_limits%, Memory_limits%,"
	for n in $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name); do
		local requests=$(kubectl describe node $n | grep -A2 -E "Resource" | tail -n1 | tr -d '(%)')
        local abs_cpu=$(echo $requests | awk '{print $2}')
		local percent_cpu=$(echo $requests | awk '{print $3}')
        local node_cpu=$(echo $abs_cpu $percent_cpu | tr -d 'mKi' | awk '{print int($1/$2*100)}')
        local allocatable_cpu=$(echo $node_cpu $abs_cpu | tr -d 'mKi' | awk '{print int($1 - $2)}')
        local percent_cpu_lim=$(echo $requests | awk '{print $5}')
        local requests=$(kubectl describe node $n | grep -A3 -E "Resource" | tail -n1 | tr -d '(%)')
        local abs_mem=$(echo $requests | awk '{print $2}')
		local percent_mem=$(echo $requests | awk '{print $3}')
        local node_mem=$(echo $abs_mem $percent_mem | tr -d 'mKi' | awk '{print int($1/$2*100)}')
        local allocatable_mem=$(echo $node_mem $abs_mem | tr -d 'mKi' | awk '{print int($1 - $2)}')
        local percent_mem_lim=$(echo $requests | awk '{print $5}')
		echo "$n, ${allocatable_cpu}m,,, ${allocatable_mem}Ki,, ${percent_cpu}%,, ${percent_mem}%,,, ${percent_cpu_lim}%,, ${percent_mem_lim}%,"

		node_count=$((node_count + 1))
		total_percent_cpu=$((total_percent_cpu + percent_cpu))
		total_percent_mem=$((total_percent_mem + percent_mem))
	done

	local avg_percent_cpu=$((total_percent_cpu / node_count))
	local avg_percent_mem=$((total_percent_mem / node_count))

	echo "Average usage (requests) : ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory."
}


function kusage_tab() {
    # Function returning resources usage on current kubernetes cluster
	local node_count=0
	local total_percent_cpu=0
	local total_percent_mem=0

    echo "NODE\t\t CPU_allocatable\t Memory_allocatable\t CPU_requests%\t Memory_requests%\t CPU_limits%\t Memory_limits%\t"
	for n in $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name); do
		local requests=$(kubectl describe node $n | grep -A2 -E "Resource" | tail -n1 | tr -d '(%)')
        local abs_cpu=$(echo $requests | awk '{print $2}')
		local percent_cpu=$(echo $requests | awk '{print $3}')
        local node_cpu=$(echo $abs_cpu $percent_cpu | tr -d 'mKi' | awk '{print int($1/$2*100)}')
        local allocatable_cpu=$(echo $node_cpu $abs_cpu | tr -d 'mKi' | awk '{print int($1 - $2)}')
        local percent_cpu_lim=$(echo $requests | awk '{print $5}')
        local requests=$(kubectl describe node $n | grep -A3 -E "Resource" | tail -n1 | tr -d '(%)')
        local abs_mem=$(echo $requests | awk '{print $2}')
		local percent_mem=$(echo $requests | awk '{print $3}')
        local node_mem=$(echo $abs_mem $percent_mem | tr -d 'mKi' | awk '{print int($1/$2*100)}')
        local allocatable_mem=$(echo $node_mem $abs_mem | tr -d 'mKi' | awk '{print int($1 - $2)}')
        local percent_mem_lim=$(echo $requests | awk '{print $5}')
		echo "$n\t ${allocatable_cpu}m\t\t\t ${allocatable_mem}Ki\t\t ${percent_cpu}%\t\t ${percent_mem}%\t\t\t ${percent_cpu_lim}%\t\t ${percent_mem_lim}%\t"

		node_count=$((node_count + 1))
		total_percent_cpu=$((total_percent_cpu + percent_cpu))
		total_percent_mem=$((total_percent_mem + percent_mem))
	done

	local avg_percent_cpu=$((total_percent_cpu / node_count))
	local avg_percent_mem=$((total_percent_mem / node_count))

	echo "Average usage (requests) : ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory."
}


#kusage_comma
kusage_short
