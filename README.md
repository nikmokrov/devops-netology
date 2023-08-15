# Домашнее задание к занятию «Организация сети»

## Задание 1. Yandex Cloud

1. Создать пустую VPC</br>
[vpc.tf](./13-cloud/1-net/vpc.tf)</br>

2. Публичная подсеть, NAT-инстанс, ВМ</br>
[public.tf](./13-cloud/1-net/public.tf)</br>

3. Приватная подсеть, Route table, ВМ</br>
[private.tf](./13-cloud/1-net/private.tf)</br>

4. Прочие ресурсы Terraform</br>
[main.tf](./13-cloud/1-net/main.tf)</br>
[vars.tf](./13-cloud/1-net/vars.tf)</br>

```console
user@host:~$ terraform apply
...
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.


user@host:~$ yc vpc network list
+----------------------+--------------+
|          ID          |     NAME     |
+----------------------+--------------+
| enp70qikobumk2gqe1q6 | default      |
| enpfn82nl5p7q9umrjij | devops22 vpc |
+----------------------+--------------+

user@host:~$ yc vpc subnet list
+----------------------+-----------------------+----------------------+----------------------+---------------+-------------------+
|          ID          |         NAME          |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+-----------------------+----------------------+----------------------+---------------+-------------------+
| b0csd4845ljn1vercg7p | default-ru-central1-c | enp70qikobumk2gqe1q6 |                      | ru-central1-c | [10.130.0.0/24]   |
| e2l4l1v42olj7qruul67 | private subnet        | enpfn82nl5p7q9umrjij | enp8qqt8ejb3am4ng7uu | ru-central1-b | [192.168.20.0/24] |
| e2loqdquk6b6btrpu62j | default-ru-central1-b | enp70qikobumk2gqe1q6 |                      | ru-central1-b | [10.129.0.0/24]   |
| e2lqjd55mt6a7f823r5l | public subnet         | enpfn82nl5p7q9umrjij |                      | ru-central1-b | [192.168.10.0/24] |
| e9b8cb18rsl226vi4398 | default-ru-central1-a | enp70qikobumk2gqe1q6 |                      | ru-central1-a | [10.128.0.0/24]   |
+----------------------+-----------------------+----------------------+----------------------+---------------+-------------------+

user@host:~$ yc vpc route-tables list
+----------------------+-----------+-------------+----------------------+
|          ID          |   NAME    | DESCRIPTION |      NETWORK-ID      |
+----------------------+-----------+-------------+----------------------+
| enp8qqt8ejb3am4ng7uu | nat-route |             | enpfn82nl5p7q9umrjij |
+----------------------+-----------+-------------+----------------------+

user@host:~$ yc vpc route-table show --name nat-route
id: enp8qqt8ejb3am4ng7uu
folder_id: b1ga7t052sv70padtm26
created_at: "2023-08-15T16:48:07Z"
name: nat-route
network_id: enpfn82nl5p7q9umrjij
static_routes:
  - destination_prefix: 0.0.0.0/0
    next_hop_address: 192.168.10.254

user@host:~$ yc compute instance list
+----------------------+--------------+---------------+---------+----------------+----------------+
|          ID          |     NAME     |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP   |
+----------------------+--------------+---------------+---------+----------------+----------------+
| epd52tpat7unas9l25f7 | private-node | ru-central1-b | RUNNING |                | 192.168.20.6   |
| epdbjmml1818nggsnteo | nat-inst     | ru-central1-b | RUNNING | 158.160.28.245 | 192.168.10.254 |
| epdrkgqkismqk3ph6ce3 | public-node  | ru-central1-b | RUNNING | 84.201.166.232 | 192.168.10.7   |
+----------------------+--------------+---------------+---------+----------------+----------------+

```

Доступ в интернет с ноды в public subnet
```console
ubuntu@public-node:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=58 time=25.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=58 time=25.1 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=58 time=25.2 ms

```

Доступ в интернет с ноды в private subnet. По traceroute видно, что трафик идет через nat-instance (192.168.10.254):
```console
ubuntu@private-node:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=24.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=54 time=23.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=54 time=23.6 ms

ubuntu@private-node:~$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.20.1)  0.682 ms  0.652 ms  0.637 ms
 2  * * *
 3  nat-inst.nikmokrov.cloud (192.168.10.254)  0.980 ms  0.962 ms  0.947 ms
 4  nat-inst.nikmokrov.cloud (192.168.10.254)  0.932 ms  0.915 ms  0.878 ms
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  google.msk.piter-ix.net (185.0.12.11)  14.856 ms msk-ix-gw3.google.com (195.208.208.250)  8.401 ms 142.250.162.254 (142.250.162.254)  8.877 ms
10  * 108.170.250.34 (108.170.250.34)  8.830 ms *
11  209.85.255.136 (209.85.255.136)  26.074 ms 108.170.250.129 (108.170.250.129)  8.978 ms 142.250.238.214 (142.250.238.214)  26.586 ms
12  172.253.51.221 (172.253.51.221)  22.635 ms 72.14.232.190 (72.14.232.190)  24.918 ms 216.239.57.222 (216.239.57.222)  26.174 ms
13  172.253.51.243 (172.253.51.243)  25.292 ms 216.239.62.107 (216.239.62.107)  25.415 ms 216.239.56.113 (216.239.56.113)  25.575 ms
14  74.125.253.109 (74.125.253.109)  22.843 ms 74.125.253.94 (74.125.253.94)  23.686 ms *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * dns.google (8.8.8.8)  24.133 ms

```