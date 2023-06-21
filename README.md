# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

## Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

[Манифест Task1.yml](12-kuber/4-kuber_net1/task1.yml)

1.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/4-kuber_net1/task1.yml 
deployment.apps/nginx-and-multitool-deployment created
service/multitool-svc created
pod/standalone-multitool created

user@host:~$ kubectl get pods
NAME                                             READY   STATUS              RESTARTS   AGE
nginx-and-multitool-deployment-8b5b7df68-2kldc   0/2     ContainerCreating   0          12s
nginx-and-multitool-deployment-8b5b7df68-h2rq8   0/2     ContainerCreating   0          12s
nginx-and-multitool-deployment-8b5b7df68-8vcns   0/2     ContainerCreating   0          12s
standalone-multitool                             0/1     ContainerCreating   0          12s

user@host:~$ kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes      ClusterIP   10.152.183.1     <none>        443/TCP             13m
multitool-svc   ClusterIP   10.152.183.242   <none>        9001/TCP,9002/TCP   16s

user@host:~$ kubectl exec pod/standalone-multitool -- curl http://multitool-svc:9001
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   392k      0 --:--:-- --:--:-- --:--:--  600k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
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

user@host:~$ kubectl exec pod/standalone-multitool -- curl http://multitool-svc:9002
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   165  100   165    0     0  62571      0 --:--:-- --:--:-- --:--:-- 82500
WBITT Network MultiTool (with NGINX) - nginx-and-multitool-deployment-8b5b7df68-8vcns - 10.1.128.205 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)

```

## Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

[Манифест Task2.yml](12-kuber/4-kuber_net1/task2.yml)

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/4-kuber_net1/task2.yml 
service/nodeport-svc created

user@host:~$ kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes      ClusterIP   10.152.183.1     <none>        443/TCP             50m
multitool-svc   ClusterIP   10.152.183.242   <none>        9001/TCP,9002/TCP   36m
nodeport-svc    NodePort    10.152.183.69    <none>        80:30001/TCP        2s

user@host:~$ kubectl get ep
NAME            ENDPOINTS                                                           AGE
kubernetes      10.129.0.24:16443                                                   50m
multitool-svc   10.1.128.203:8080,10.1.128.204:8080,10.1.128.205:8080 + 3 more...   37m
nodeport-svc    10.1.128.203:80,10.1.128.204:80,10.1.128.205:80                     5s

ubuntu@microk8s:~$ curl http://10.129.0.24:30001
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
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
