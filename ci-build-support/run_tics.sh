#!/bin/bash

if mount | grep "/Users/admin/Documents/share" > /dev/null; then
    echo "TICS Share is mounted"
else
    echo "TICS Share is not mounted"
    echo "Mount TICS Share"
    /mnt/connect_tics_share.sh
fi
export TICS=/mnt/tics/FileServer/cfg
export PATH=/mnt/tics/BuildServer:${PATH}

echo "Running TICS..."
TICSMaintenance -project OPA-iOS -branchname develop -branchdir .
TICSQServer -project OPA-iOS -nosanity
