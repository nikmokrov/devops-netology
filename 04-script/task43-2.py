#!/usr/bin/env python3

import socket
import json
import yaml
from time import sleep

serv_list = ['drive.google.com', 'mail.google.com', 'google.com']
ip_list = [socket.gethostbyname(serv) for serv in serv_list]
serv_dict = dict(zip(serv_list, ip_list))
while True:
    with open('serv_log.json', 'w') as json_log, open('serv_log.yaml', 'w') as yaml_log:
        for serv, old_ip in serv_dict.items():
            new_ip = socket.gethostbyname(serv)
            if new_ip != old_ip:
                print(f'ERROR {serv} IP mismatch: {old_ip} {new_ip}')
                serv_dict[serv] = new_ip
            print(f'{serv}-{serv_dict[serv]}')
            json.dump({serv: serv_dict[serv]}, json_log)
            json_log.write('\n')
            yaml.dump([{serv: serv_dict[serv]}], yaml_log)
    sleep(2)
