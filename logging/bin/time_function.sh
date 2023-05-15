#!/bin/bash

function utc_time() {
    UTC=`TZ=UTC date +"%Y-%m-%dT%H:%M:%S"`
    # echo $UTC
}

function utc_journalctl_format() {
    UTC_J_20min_ago=`TZ=UTC date +"%Y-%m-%d %H:%M:%S" --date="20 minutes ago"`
    # echo $UTC_J_20min_ago
}

function cdt_time() {
    CDT=`TZ=America/Chicago date +"%Y-%m-%dT%H:%M:%S"`
    # echo $CDT
}

function update_time() {
    UTC=`TZ=UTC date +"%Y-%m-%dT%H:%M:%S"`
    CDT=`TZ=America/Chicago date +"%Y-%m-%dT%H:%M:%S"`
}

# utc_time
# cdt_time
utc_journalctl_format
update_time
