### Задача 1
https://hub.docker.com/r/nikmokrov/nginx

```console
vagrant@server1:~$ docker run --rm -d -p 8080:80 --name web nikmokrov/nginx:netology
5d0819f3402ac012212ccf9908119a459cbe8508a5fcba20b073fd2e7db61f77
vagrant@server1:~$ curl localhost:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```


### Задача 2
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:
- Высоконагруженное монолитное java веб-приложение;</br>
Возможно Docker, но java в контейнере нужно аккуратно настраивать (https://habr.com/ru/company/ruvds/blog/324756/)
- Nodejs веб-приложение;</br>
Docker, есть официальный образ (https://hub.docker.com/_/node) и рекомендации по настройке
(https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
- Мобильное приложение c версиями для Android и iOS;</br>
ВМ. Хотя Android и iOS - это Unix-like ОС, но все же их ядра отличаются от ядра Linux, особенно iOS.
Хоть и есть примеры удачных запусков (https://dev.to/ianito/how-to-emulate-ios-on-linux-with-docker-4gj3),
я думаю, что приложения будут стабильнее работать в ВМ в "родных" ОС.
- Шина данных на базе Apache Kafka;</br>
Docker. Есть официальный образ (https://hub.docker.com/r/bitnami/kafka)
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три 
ноды elasticsearch, два logstash и две ноды kibana;</br>
ВМ. Кластер по определению разворачивается на нескольких нодах для отказоустойчивости,
т.е. требуется несколько виртуальных или физических машин. Кластер в контейнерах на одной ноде - 
это фактически не кластер.
- Мониторинг-стек на базе Prometheus и Grafana;</br>
ВМ. В целом тоже самое, что и в случае с Elasticsearch, если необходима кластеризация. 
Небольшой мониторинг без необходимости кластеризации можно и в Docker, соответствующие образы имеются.
- MongoDB, как основное хранилище данных для java-приложения;</br>
Docker. Есть официальная статья, в которой рекомендуется использование Docker в
продакшене (https://www.mongodb.com/compatibility/docker)
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.</br>
ВМ. Слишком масштабная задача для контейнеризации, требующая хранения большого объема данных.
Скорее всего также потребуется кластеризация.

### Задача 3
```console
vagrant@server1:~$ docker run -td -v ~/data:/data centos:centos8
vagrant@server1:~$ docker run -td -v ~/data:/data debian:stable
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE            COMMAND       CREATED          STATUS          PORTS     NAMES
0b5fbb523d2a   debian:stable    "bash"        2 minutes ago   Up 2 minutes             unruffled_solomon
0f84190bd9f8   centos:centos8   "/bin/bash"   2 minutes ago   Up 2 minutes             eager_dirac
vagrant@server1:~$ docker exec -t eager_dirac bash -c 'echo 123 > /data/123.txt'
vagrant@server1:~$ ls -l data
total 4
-rw-r--r-- 1 root root 4 Nov  4 11:37 123.txt
vagrant@server1:~$ echo 456 > data/456.txt
vagrant@server1:~$ docker exec -ti unruffled_solomon bash
root@0b5fbb523d2a:/# ls -l /data
total 8
-rw-r--r-- 1 root root 4 Nov  4 11:37 123.txt
-rw-rw-r-- 1 1000 1000 4 Nov  4 11:38 456.txt
root@0b5fbb523d2a:/# more /data/123.txt 
123
root@0b5fbb523d2a:/# more /data/456.txt 
456
```

### Задача 4
https://hub.docker.com/r/nikmokrov/ansible