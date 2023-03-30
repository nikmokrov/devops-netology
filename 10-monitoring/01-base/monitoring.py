#!/usr/bin/python3

import json
from datetime import datetime

# collect metrics
try:
    with open('/proc/uptime', 'r', encoding='utf-8') as file:
        uptime = file.readlines()[0].split()[0]
except:
    uptime = 0

try:
    with open('/proc/loadavg', 'r', encoding='utf-8') as file:
        loads = file.readlines()[0].split()
        load1 = loads[0]
        load5 = loads[1]
        load15 = loads[2]
except:
    load1 = 0
    load5 = 0
    load15 = 0

try:
    with open('/proc/stat', 'r', encoding='utf-8') as file:
        procs = 0
        swap_free = 0
        stats = file.readlines()
        for elem in stats:
            if elem.find('processes') > -1:
                procs = elem.split()[1]
except:
    procs = 0

try:
    with open('/proc/meminfo', 'r', encoding='utf-8') as file:
        mem_free = 0
        swap_free = 0
        mems = file.readlines()
        for elem in mems:
            if elem.find('MemFree:') > -1:
                mem_free = elem.split()[1]
            if elem.find('SwapFree:') > -1:
                swap_free = elem.split()[1]
except:
    mem_free = 0
    swap_free = 0

# format log data
today = datetime.today()
status_log = datetime.strftime(today, "%Y-%m-%d") + '-awesome-monitoring.log'
metrics = [uptime, load1, load5, load15, procs, mem_free, swap_free]
log_data = {int(today.timestamp()): metrics}

# write log
try:
    with open(status_log, 'a', encoding='utf-8') as file:
        json.dump(log_data, file)
        print(file=file)
except:
    pass
