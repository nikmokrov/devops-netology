# Домашнее задание к занятию «Troubleshooting»

1. Устанавливаем приложение
```console
user@host:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found

user@host:~$ kubectl create ns web
namespace/web created

user@host:~$ kubectl create ns data
namespace/data created

user@host:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created

user@host:~$ kubectl get pods -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-85cccb47d4-4xltj   1/1     Running   0          3m27s
web-consumer-85cccb47d4-v8vsr   1/1     Running   0          3m27s

user@host:~$ kubectl get pods -n data
NAME                       READY   STATUS    RESTARTS   AGE
auth-db-7778bc87f9-8q6wp   1/1     Running   0          3m35s

```

2. В первую очередь обращает на себя внимание то, что поды создаются в разных namespace - web и data. Это уже потенциальная причина для неполадок, запомним.</br>
Проверяем логи подов:
```console
user@host:~$ kubectl -n data logs auth-db-7778bc87f9-8q6wp
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up

user@host:~$ kubectl -n web logs pod/web-consumer-85cccb47d4-4xltj  
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'

user@host:~$ kubectl -n web logs pod/web-consumer-85cccb47d4-v8vsr
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'

```

В логе деплоя auth-bd ничего подозрительного.</br>
А вот в логах подов web-consumer сразу видим, что не может быть разрешено имя auth-db.</br>

Проверяем вручную:
```console
user@host:~$ kubectl -n web exec pod/web-consumer-85cccb47d4-v8vsr -- nslookup auth-db
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'auth-db'
command terminated with exit code 1
```

Имя auth-db не разрешается. Поды в разных namespace, поэтому не могут обращаться друг к другу по коротким именам DNS.
Пробуем разрешить полное имя:
```console
user@host:~$ kubectl -n web exec pod/web-consumer-85cccb47d4-v8vsr -- nslookup auth-db.data.svc.cluster.local
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      auth-db.data.svc.cluster.local
Address 1: 10.107.34.217 auth-db.data.svc.cluster.local
```
Полное имя разрешается.</br>

**Причина, почему web-consumer не может подключиться к auth-db - использование короткого имени DNS при помещении подов в разные namespace.**

3. Очевидных решений два: </br>

или обращаться к auth-db по полному DNS имени </br>
[task_ver1.yaml](./12-kuber/14-kuber_troubleshooting/task_ver1.yaml)</br>

или поместить все поды в один namespace </br>
[task_ver2.yaml](./12-kuber/14-kuber_troubleshooting/task_ver2.yaml)</br>

4. Решение с использованием полного имени:
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/14-kuber_troubleshooting/task_ver1.yaml 
deployment.apps/web-consumer configured
deployment.apps/auth-db unchanged
service/auth-db unchanged

user@host:~$ kubectl -n web logs pod/web-consumer-86588bdc6f-brnv6
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

                                 Dload  Upload   Total   Spent    Left  Speed
<p><em>Thank you for using nginx.</em></p>
100   612  100   612    0     0   134k      0 --:--:-- --:--:-- --:--:--  298k
</body>
</html>

```

Решение с помещением подов в один namespace:
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/14-kuber_troubleshooting/task_ver2.yaml 
deployment.apps/web-consumer configured
deployment.apps/auth-db created
service/auth-db created
user@host:~$ kubectl -n web get pods
NAME                            READY   STATUS        RESTARTS   AGE
auth-db-7778bc87f9-f4cvb        1/1     Running       0          16s
web-consumer-85cccb47d4-nqvtd   1/1     Running       0          15s
web-consumer-85cccb47d4-p8pvq   1/1     Running       0          16s
web-consumer-86588bdc6f-brnv6   1/1     Terminating   0          40m
web-consumer-86588bdc6f-lq7q6   1/1     Terminating   0          39m

user@host:~$ kubectl -n web logs pods/web-consumer-85cccb47d4-nqvtd
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  58733      0 --:--:-- --:--:-- --:--:--  199k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

Оба решения рабочие, но правильное скорее первое, т.к. для помещения подов в разные namespace могут быть веские причины (например, вопрос безопасности или разделения сфер ответственности).