#!/bin/bash

source time_function.sh

fn=start_end_time.txt

echo -n "end_time,UTC,${UTC}," >> ${fn}
echo "CDT,${CDT}" >> ${fn}
