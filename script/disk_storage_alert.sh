#!/bin/bash

#############################
#AUTHOR:PAVAN################
#DATE:2/11/2024##############
#VERSION:V1##################
#############################


#set -x
set -e #exit if script fails
set -o pipefail #exit script if fail in pipe commands

df_h=$(df -h) #getting the disk data
header=$( echo "$df_h" | awk 'NR == 1')
host=$(hostname)
ip=$(hostname -i)

exceed=$( echo "$df_h" | awk 'NR > 2 && /[7-9][0-9]%|100%/')

if [ -n "$exceed" ]; then
	echo "===================================="
	echo "Disk storage exceeds 70% in these disks"
	echo "HOSTNAME:$host"
	echo "IPADDRESS:$ip"
	echo "$header"
	echo "$exceed"
	echo "===================================="
	mail -s "DISK STORAGE ALERT" pk@gmail.com <<EOF
        Disk storage exceeds 70% in these disks
        $header
        $exceed
EOF
else
	echo "Disk storage is good"
	mail -s "DISK STORAGE ALERT" pk@gmail.com <<EOF
        Disk storage is good
        $header
        $exceed
EOF
fi
