# Домашнее задание к занятию "6.5. Elasticsearch"
## Задача 1
[Dockerfile](06-db/Dockerfile)</br>

[DockerHub](https://hub.docker.com/r/nikmokrov/opensearch)

```console
user@host:~$ docker run -dtP --name opensearch --volume=opensearch:/var/lib/opensearch nikmokrov/opensearch:2.4.0
4a7850f4b64a923bdc4ca7c6f0a01cbe3aa32cdb3d9921695331ada0334ed0b8

user@host:~$ docker ps
CONTAINER ID   IMAGE                                 COMMAND                  CREATED         STATUS         PORTS                                                                                  NAMES
4a7850f4b64a   nikmokrov/opensearch:2.4.0            "sh -c ${OS_PATH}-${…"   3 seconds ago   Up 3 seconds   0.0.0.0:49155->9200/tcp, :::49155->9200/tcp  
user@host:~$ curl http://localhost:49155/
{
  "name" : "netology_test",
  "cluster_name" : "netology_cluster",
  "cluster_uuid" : "VXT1VCK-RAiOm8tNnCC5TA",
  "version" : {
    "distribution" : "opensearch",
    "number" : "2.4.0",
    "build_type" : "tar",
    "build_hash" : "744ca260b892d119be8164f48d92b8810bd7801c",
    "build_date" : "2022-11-15T04:42:29.671309257Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.1",
    "minimum_wire_compatibility_version" : "7.10.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "The OpenSearch Project: https://opensearch.org/"
}
```

## Задача 2
```console
user@host:~$ curl -X PUT -H "Content-Type: application/json" -d '{"settings": {"index": {"number_of_replicas": 0, "number_of_shards": 1}}}' http://localhost:49155/ind-1
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}

user@host:~$ curl -X PUT -H "Content-Type: application/json" -d '{"settings": {"index": {"number_of_replicas": 1, "number_of_shards": 2}}}' http://localhost:49155/ind-2
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}

user@host:~$ curl -X PUT -H "Content-Type: application/json" -d '{"settings": {"index": {"number_of_replicas": 2, "number_of_shards": 4}}}' http://localhost:49155/ind-3
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}

user@host:~$ curl http://localhost:49155/_cat/indices
green  open ind-1 SkWgmGOwTCSBE7LNnFvAlQ 1 0 0 0 208b 208b
yellow open ind-3 alMti2U6T8mDwfb3t80eEw 4 2 0 0 832b 832b
yellow open ind-2 _dwNoiqvTRusAyXdEnzZ4Q 2 1 0 0 416b 416b

user@host:~$ curl http://localhost:49155/_cluster/health
{"cluster_name":"netology_cluster","status":"yellow","timed_out":false,"number_of_nodes":1,"number_of_data_nodes":1,"discovered_master":true,"discovered_cluster_manager":true,"active_primary_shards":7,"active_shards":7,"relocating_shards":0,"initializing_shards":0,"unassigned_shards":10,"delayed_unassigned_shards":0,"number_of_pending_tasks":0,"number_of_in_flight_fetch":0,"task_max_waiting_in_queue_millis":0,"active_shards_percent_as_number":41.17647058823529}
```
  
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?</br>
Кластер состоит из одной ноды, а количество шардов для ind-2 и ind-3 больше 1, соответственно, 
кластер не может распределить эти шарды по другим нодам. 
Поэтому состояние ind-1 - green, а ind-2 и ind-3 - yellow.

```console
user@host:~$ curl -X DELETE http://localhost:49155/ind-1
{"acknowledged":true}

user@host:~$ curl -X DELETE http://localhost:49155/ind-2
{"acknowledged":true}

user@host:~$ curl -X DELETE http://localhost:49155/ind-3
{"acknowledged":true}

```

## Задача 3
```console
user@host:~$ docker exec -t opensearch mkdir /var/lib/opensearch/repo/snapshots

user@host:~$ curl -X PUT -H "Content-Type: application/json" -d '{"type": "fs", "settings": {"location": "/var/lib/opensearch/repo/snapshots"}}' http://localhost:49155/_snapshot/netology_backup
{"acknowledged":true}

user@host:~$ curl -X PUT -H "Content-Type: application/json" -d '{"settings": {"index": {"number_of_replicas": 0, "number_of_shards": 1}}}' http://localhost:49155/test
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}

user@host:~$ curl http://localhost:49155/_cat/indices
green open test yavYq9J7Sv23wxzW6-tONQ 1 0 0 0 208b 208b

user@host:~$ curl -X PUT -H "Content-Type: application/json" http://localhost:49155/_snapshot/netology_backup/snapshot-1
{"accepted":true}

user@host:~$ docker exec -t opensearch bash -c 'ls -l /var/lib/opensearch/repo/snapshots'
total 20
-rw-r--r-- 1 1000 root  411 Dec  6 12:31 index-0
-rw-r--r-- 1 1000 root    8 Dec  6 12:31 index.latest
drwxr-xr-x 3 1000 root 4096 Dec  6 12:31 indices
-rw-r--r-- 1 1000 root  371 Dec  6 12:31 meta-LNDuV1MfQe2p-EgpR9TDMg.dat
-rw-r--r-- 1 1000 root  267 Dec  6 12:31 snap-LNDuV1MfQe2p-EgpR9TDMg.dat

user@host:~$ curl -X DELETE http://localhost:49155/test
{"acknowledged":true}

user@host:~$ curl -X PUT -H "Content-Type: application/json" -d '{"settings": {"index": {"number_of_replicas": 0, "number_of_shards": 1}}}' http://localhost:49155/test-2
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"} 

user@host:~$ curl http://localhost:49155/_cat/indices
green open test-2 iWAdQ75dQjS5uZk0vGdr-w 1 0 0 0 208b 208b

user@host:~$ curl -X POST http://localhost:49155/_snapshot/netology_backup/snapshot-1/_restore
{"accepted":true}

user@host:~$ curl http://localhost:49155/_cat/indices
green open test-2 iWAdQ75dQjS5uZk0vGdr-w 1 0 0 0 208b 208b
green open test   wie3447_RISXsHjV3CaBfw 1 0 0 0 208b 208b

```
