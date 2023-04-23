#!/bin/bash

function utc_time() { # k8s time format
#    echo -n UTC: 
#    TZ=":UTC" date +%Y%m%d-%H:%M:%S
    sudo timedatectl set-timezone UTC
    UTC=`date +"%Y-%m-%dT%H:%M:%S"`
    sudo timedatectl set-timezone America/Chicago
}

function cdt_time() { # k8s time format
    CDT=`date +"%Y-%m-%dT%H:%M:%S"`
}

utc_time
cdt_time
