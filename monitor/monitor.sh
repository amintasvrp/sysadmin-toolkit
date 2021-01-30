#!/bin/bash
# Amintas Victor - @amintasvrp
# André Matos - @andrerosamatos

hostname=$1
delay=$2


while true; do
    df=$(df --total | tail -n 1)
    IFS=" " read -r -a array <<< "${df}"
    disk=${array[2]}

    top=$(top -b -n 1 | head -n 5 | tail -n 3)
    top_list=""
    for element in $top; do
        top_list="$top_list $element"
    done
    IFS=" " read -r -a list <<< "${top_list}"
    mem=${list[24]}
    swap=${list[34]}

    cpu_usr=$(echo ${list[1]}| tr ',' '.')
    cpu_sys=$(echo ${list[3]}| tr ',' '.')
    cpu=$(echo "$cpu_usr + $cpu_sys" | bc)


    curl --silent --output /dev/null -i -XPOST 'http://localhost:8086/write?db=sysAdmin' --data-binary "cpu_usage,hostname=$hostname usage=$cpu"
    curl --silent --output /dev/null -i -XPOST 'http://localhost:8086/write?db=sysAdmin' --data-binary "mem_usage,hostname=$hostname usage=$mem"
    curl --silent --output /dev/null -i -XPOST 'http://localhost:8086/write?db=sysAdmin' --data-binary "swap_usage,hostname=$hostname usage=$swap"
    curl --silent --output /dev/null -i -XPOST 'http://localhost:8086/write?db=sysAdmin' --data-binary "disk_usage,hostname=$hostname usage=$disk"
    
    echo "CPU USAGE : $cpu"   
    echo "MEMORY USAGE : $mem" 
    echo "SWAP USAGE : $swap" 
    echo "DISK USAGE : $disk"
    echo 

    sleep $delay
done