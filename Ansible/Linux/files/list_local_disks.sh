#!/bin/bash

for X in $(ls /sys/block/*/device/model); do

    disk_model_ws=$(cat $X | sed 's/[[:blank:]]//g')
    disk_models_ws=$(echo ^\($(sed 's/[[:blank:]]//g' /tmp/disk_models | paste -sd '|')\)$)

    if [[ $disk_model_ws =~ $disk_models_ws ]]; then

        prefix="/sys/block/"
        suffix="/device/model"
        disk=${X#$prefix}
        disk=${disk%$suffix}
        disk_model=$(cat $X)
        prefix="Disk /dev/"$disk": "
        disk_size=$(fdisk -l /dev/$disk 2>/dev/null | grep "$prefix" | cut -d',' -f1)
        disk_size=${disk_size#$prefix}
        echo "$disk | $disk_model | $disk_size"

    fi

done

