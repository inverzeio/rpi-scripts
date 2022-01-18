#!/bin/bash
# Syslog logging for Raspberry Pi 4B

cpu_t=$(</sys/class/thermal/thermal_zone0/temp)
cpu_temp=$((cpu_t/1000))
cpu_use=$(top -bn1 | grep "Cpu(s)" |            sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |            awk '{print 100 - $1"%"}')
mem_use=$(awk '/^Mem/ {printf("%u%%", 100*$3/$2);}' <(free -m))
io_use=$(iostat -d | grep "mmcblk0" | awk '{ print $3 "kB_read/s " $4 "kb_wrtn/sec" }')

logger -s -p local0.alert CPU_TEMP=$cpu_temp CPU_USE=$cpu_use MEM_USE=$mem_use IO_USE=$io_use
