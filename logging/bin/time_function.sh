#!/bin/bash

function utc_time() { # k8s time format
    sudo timedatectl set-timezone UTC
    UTC=`date +"%Y-%m-%dT%H:%M:%S"`
    sudo timedatectl set-timezone America/Chicago
    #echo $UTC
}


function utc_journalctl_format() {
    sudo timedatectl set-timezone UTC
    UTC_J_20min_ago=`date +"%Y-%m-%d %H:%M:%S" --date="20 minutes ago"`
    #echo $UTC_J_20min_ago
    sudo timedatectl set-timezone America/Chicago
}

function cdt_time() { # k8s time format
    sudo timedatectl set-timezone America/Chicago
    CDT=`date +"%Y-%m-%dT%H:%M:%S"`
}

utc_time
utc_journalctl_format
cdt_time
