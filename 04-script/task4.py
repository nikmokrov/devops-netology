#!/usr/bin/env python3

import socket
from time import sleep

serv_list = ['drive.google.com', 'mail.google.com', 'google.com']
ip_list = [socket.gethostbyname(serv) for serv in serv_list]
serv_dict = dict(zip(serv_list, ip_list))
enough = 0
#while enough < 10:
while True:
    for serv, old_ip in serv_dict.items():
        new_ip = socket.gethostbyname(serv)
        if new_ip != old_ip:
            print(f'ERROR {serv} IP mismatch: {old_ip} {new_ip}')
            serv_dict[serv] = new_ip
        print(f'{serv}-{serv_dict[serv]}')
    sleep(2)
    enough += 1

