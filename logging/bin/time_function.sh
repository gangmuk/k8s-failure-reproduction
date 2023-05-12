#!/bin/bash

function utc_time() { # k8s time format
#    echo -n UTC: 
#    TZ=":UTC" date +%Y%m%d-%H:%M:%S
    sudo timedatectl set-timezone UTC
    UTC=`date +"%Y-%m-%dT%H:%M:%S"`
    sudo timedatectl set-timezone America/Chicago
    #echo $UTC
}


function utc_journalctl_format() {
    sudo timedatectl set-timezone UTC
    # 2015-01-10 17:15:00
    #UTC_J=`date +"%Y-%m-%d %H:%M:%S"`
    UTC_J_10min_ago=`date +"%Y-%m-%d %H:%M:%S" --date="10 minutes ago"`
    #echo $UTC_J
    #echo $UTC_J_10min_ago
    sudo timedatectl set-timezone America/Chicago
}

function cdt_time() { # k8s time format
    CDT=`date +"%Y-%m-%dT%H:%M:%S"`
}

utc_time
utc_journalctl_format
cdt_time
