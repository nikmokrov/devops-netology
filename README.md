## Домашнее задание к занятию «Микросервисы: масштабирование»

# Задача 1: Кластеризация

Очевидным выбором станет Kubernetes - система оркестрации контейнеров, позволяющая автоматизировать развертывание, 
масштабирование, репликацию и мониторинг контейнерных приложений.

Решение полностью удовлетворяет всем требованиям:

- поддерживает контейнеры, разумеется, причем сразу несколько сред исполнения: Docker, containerd, CRI-O;
- умеет выполнять обнаружение сервисов с помощью DNS или переменных окружения и маршрутизацию запросов (kube-proxy);
- горизонтальное масштабирование обеспечивается службой Horizontal Pod Autoscaler (HPA), которая автоматически масштабирует количество подов,
причем показатели для масштабирования могут быть произвольными благодяря API Custom Metrics;
- автоматическое масштабирование кластера (Cluster Autoscaler) позволяет постепенно увеличивать или уменьшать число узлов в группе 
(до указанного максимального и минимального размера) в зависимости от нагрузки на кластер;
- явное разделение ресурсов, доступных извне и внутри системы, обеспечивается при помощи пространств имён (namespaces);
- возможность конфигурировать приложения с помощью переменных среды имеется, в том числе в переменные среды можно
 передавать чувствительные данные (пароли, ключи доступа, ключи шифрования) из специального ресурса - Kubernetes Secrets

 В качестве альтернативы Kubernetes можно рассмотреть систему HashiCorp Nomad. Nomad более универсален за счет поддержки не только контейнеризованных
 приложений (поддерживаются микросервисные и пакетные приложения, включая Docker, Java, Qemu и др.). Nomad проще в развертывании, он доступен как в виде
 бинарного файла, так и в виде готовых пакетов для различных операционных систем, а также может быть собран из исходников. Nomad поддерживает большее
 число узлов и контейнеров в кластере, и в целом несколько производительнее. В Nomad имеется и горизонтальное и автомасштабирование кластера, а также
 поддерживаются namespaces. К недостаткам Nomad можно отнести отсутствие встроенной возможности обнаружения сервисов, для этого необходимо использовать 
 связку с Consul, а также он проигрывает в плане безопасности, для хранения чувствительных данных придется использовать стороннюю систему Vault.

 # Задача 2: Распределённый кеш

 1. Создаем 3 ноды с помощью Terraform</br>
 [main.tf](11-microservices/04-scaling/terraform/main.tf)</br>

 2. Устанавливаем и настраиваем по 2 инстанса Redis на каждой ноде с помощью Ansible</br>
 [site.yml](11-microservices/04-scaling/playbook/site.yml)</br>

 3. Собираем кластер согласно схеме. Сначала создаем кластер из 3-х нод без репликации, а затем последовательно добавляем 3 реплики.
 ```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/tools/redis$ ./redis-cli -h 158.160.25.2 -a VeryVeryStrongPass --cluster create 158.160.25.2:6379 158.160.4.136:6379 158.160.6.230:6379 --cluster-replicas 0 --cluster-yes
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Performing hash slots allocation on 3 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
M: 78cbbd0c7e2d24d117c63bca27d733916d0d77f7 158.160.25.2:6379
   slots:[0-5460] (5461 slots) master
M: 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 158.160.4.136:6379
   slots:[5461-10922] (5462 slots) master
M: cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621 158.160.6.230:6379
   slots:[10923-16383] (5461 slots) master
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node 158.160.25.2:6379)
M: 78cbbd0c7e2d24d117c63bca27d733916d0d77f7 158.160.25.2:6379
   slots:[0-5460] (5461 slots) master
M: cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621 158.160.6.230:6379
   slots:[10923-16383] (5461 slots) master
M: 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 158.160.4.136:6379
   slots:[5461-10922] (5462 slots) master
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

user@host:~/Облако/Documents/Netology/DEVOPS-22/tools/redis$ ./redis-cli -h 158.160.25.2 -a VeryVeryStrongPass --cluster add-node 158.160.6.230:6380 158.160.25.2:6379 --cluster-slave --cluster-master-id 78cbbd0c7e2d24d117c63bca27d733916d0d77f7 --cluster-yes
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Adding node 158.160.6.230:6380 to cluster 158.160.25.2:6379
>>> Performing Cluster Check (using node 158.160.25.2:6379)
M: 78cbbd0c7e2d24d117c63bca27d733916d0d77f7 158.160.25.2:6379
   slots:[0-5460] (5461 slots) master
M: cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621 158.160.6.230:6379
   slots:[10923-16383] (5461 slots) master
M: 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 158.160.4.136:6379
   slots:[5461-10922] (5462 slots) master
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node 158.160.6.230:6380 to make it join the cluster.
Waiting for the cluster to join

>>> Configure node as replica of 158.160.25.2:6379.
[OK] New node added correctly.
user@host:~/Облако/Documents/Netology/DEVOPS-22/tools/redis$ ./redis-cli -h 158.160.25.2 -a VeryVeryStrongPass --cluster add-node 158.160.25.2:6380 158.160.25.2:6379 --cluster-slave --cluster-master-id 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 --cluster-yes
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Adding node 158.160.25.2:6380 to cluster 158.160.25.2:6379
>>> Performing Cluster Check (using node 158.160.25.2:6379)
M: 78cbbd0c7e2d24d117c63bca27d733916d0d77f7 158.160.25.2:6379
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621 158.160.6.230:6379
   slots:[10923-16383] (5461 slots) master
M: 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 158.160.4.136:6379
   slots:[5461-10922] (5462 slots) master
S: 3139bdf61ca0537dc949d7637e7375c0dd11d60f 158.160.6.230:6380
   slots: (0 slots) slave
   replicates 78cbbd0c7e2d24d117c63bca27d733916d0d77f7
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node 158.160.25.2:6380 to make it join the cluster.
Waiting for the cluster to join

>>> Configure node as replica of 158.160.4.136:6379.
[OK] New node added correctly.

user@host:~/Облако/Documents/Netology/DEVOPS-22/tools/redis$ ./redis-cli -h 158.160.25.2 -a VeryVeryStrongPass --cluster add-node 158.160.4.136:6380 158.160.25.2:6379 --cluster-slave --cluster-master-id 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 --cluster-yes
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Adding node 158.160.4.136:6380 to cluster 158.160.25.2:6379
>>> Performing Cluster Check (using node 158.160.25.2:6379)
M: 78cbbd0c7e2d24d117c63bca27d733916d0d77f7 158.160.25.2:6379
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: 21e1aa07775e51a8136ce025671685a0428bd94b 158.160.25.2:6380
   slots: (0 slots) slave
   replicates 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2
M: 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 158.160.4.136:6379
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
M: cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621 158.160.6.230:6379
   slots:[10923-16383] (5461 slots) master
S: 3139bdf61ca0537dc949d7637e7375c0dd11d60f 158.160.6.230:6380
   slots: (0 slots) slave
   replicates 78cbbd0c7e2d24d117c63bca27d733916d0d77f7
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node 158.160.4.136:6380 to make it join the cluster.
Waiting for the cluster to join

>>> Configure node as replica of 158.160.4.136:6379.
[OK] New node added correctly.

user@host:~/Облако/Documents/Netology/DEVOPS-22/tools/redis$ ./redis-cli -h 158.160.25.2 -a VeryVeryStrongPass
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
158.160.25.2:6379> cluster nodes
21e1aa07775e51a8136ce025671685a0428bd94b 158.160.25.2:6380@16380 slave cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621 0 1685947722429 3 connected
960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 158.160.4.136:6379@16379 master - 0 1685947724435 2 connected 5461-10922
cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621 158.160.6.230:6379@16379 master - 0 1685947720422 3 connected 10923-16383
3139bdf61ca0537dc949d7637e7375c0dd11d60f 158.160.6.230:6380@16380 slave 78cbbd0c7e2d24d117c63bca27d733916d0d77f7 0 1685947723432 1 connected
78cbbd0c7e2d24d117c63bca27d733916d0d77f7 10.129.0.35:6379@16379 myself,master - 0 1685947723000 1 connected 0-5460
9869860e75a791ffd0767cb99438e0a0f7f4dc7d 158.160.4.136:6380@16380 slave 960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2 0 1685947724000 2 connected

158.160.25.2:6379> cluster slots
1) 1) (integer) 5461
   2) (integer) 10922
   3) 1) "158.160.4.136"
      2) (integer) 6379
      3) "960c5c8d76ac3058f4b38d4cad88f3c611b6a8d2"
   4) 1) "158.160.4.136"
      2) (integer) 6380
      3) "9869860e75a791ffd0767cb99438e0a0f7f4dc7d"
2) 1) (integer) 10923
   2) (integer) 16383
   3) 1) "158.160.6.230"
      2) (integer) 6379
      3) "cda4d56beda7cc91ff1b5f397c0ffb47dcb4e621"
   4) 1) "158.160.25.2"
      2) (integer) 6380
      3) "21e1aa07775e51a8136ce025671685a0428bd94b"
3) 1) (integer) 0
   2) (integer) 5460
   3) 1) "10.129.0.35"
      2) (integer) 6379
      3) "78cbbd0c7e2d24d117c63bca27d733916d0d77f7"
   4) 1) "158.160.6.230"
      2) (integer) 6380
      3) "3139bdf61ca0537dc949d7637e7375c0dd11d60f"

 ```