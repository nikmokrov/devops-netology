# Домашнее задание к занятию «Запуск приложений в K8S»

## Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

[Манифест Task1.yml](12-kuber/3-runapp/task1.yml)

1.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/3-runapp/task1.yml 
deployment.apps/nginx-and-multitool-deployment created

user@host:~$ kubectl get pods
NAME                                              READY   STATUS   RESTARTS      AGE
nginx-and-multitool-deployment-849bc75b88-n56pd   1/2     Error    1 (15s ago)   19s

user@host:~$ kubectl logs nginx-and-multitool-deployment-849bc75b88-n56pd -c multitool
The directory /usr/share/nginx/html is not mounted.
Therefore, over-writing the default index.html file with some useful information:
WBITT Network MultiTool (with NGINX) - nginx-and-multitool-deployment-849bc75b88-n56pd - 10.1.128.207 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
2023/06/15 11:33:08 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
2023/06/15 11:33:08 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
2023/06/15 11:33:08 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
2023/06/15 11:33:08 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
2023/06/15 11:33:08 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
2023/06/15 11:33:08 [emerg] 1#1: still could not bind()
nginx: [emerg] still could not bind()
```

nginx и multitool по-умолчанию используют 80-й порт. nginx стартует первым, поэтому к моменту запуска multitool 80-й порт уже занят, что и видно по логам контейнера. Решение - запустить multitool на другом порту, передав его через переменную окружения HTTP_PORT

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/3-runapp/task1.yml 
deployment.apps/nginx-and-multitool-deployment configured

user@host:~$ kubectl get pods
NAME                                              READY   STATUS    RESTARTS   AGE
nginx-and-multitool-deployment-5d58f84bbd-fvrls   2/2     Running   0          13s

```
2. Увеличиваем кол-во replicas до 2

3.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/3-runapp/task1.yml 
deployment.apps/nginx-and-multitool-deployment configured

user@host:~$ kubectl get pods
NAME                                              READY   STATUS    RESTARTS   AGE
nginx-and-multitool-deployment-5d58f84bbd-fvrls   2/2     Running   0          82s
nginx-and-multitool-deployment-5d58f84bbd-snvf5   2/2     Running   0          5s

```

4.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/3-runapp/task1.yml 
deployment.apps/nginx-and-multitool-deployment unchanged
service/multitool-svc created

user@host:~$ kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE
kubernetes      ClusterIP   10.152.183.1     <none>        443/TCP           59m
multitool-svc   ClusterIP   10.152.183.188   <none>        80/TCP,8888/TCP   30s
```

5.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/3-runapp/task1.yml 
deployment.apps/nginx-and-multitool-deployment unchanged
service/multitool-svc unchanged
pod/another-one-multitool created

user@host:~$ kubectl get pod
NAME                                              READY   STATUS    RESTARTS   AGE
nginx-and-multitool-deployment-5d58f84bbd-fvrls   2/2     Running   0          8m34s
nginx-and-multitool-deployment-5d58f84bbd-snvf5   2/2     Running   0          7m17s
another-one-multitool                             1/1     Running   0          86s

user@host:~$ kubectl exec pod/another-one-multitool -it bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.

bash-5.1# curl http://multitool-svc:80
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

bash-5.1# curl http://multitool-svc:8888
WBITT Network MultiTool (with NGINX) - nginx-and-multitool-deployment-5d58f84bbd-fvrls - 10.1.128.208 - HTTP: 8888 , HTTPS: 443 . (Formerly praqma/network-multitool)


```

## Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

[Манифест Task2.yml](12-kuber/3-runapp/task2.yml)

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/3-runapp/task2.yml 
deployment.apps/nginx-with-init-deployment created

user@host:~$ kubectl get pod
NAME                                          READY   STATUS     RESTARTS   AGE
nginx-with-init-deployment-567977478b-qtxcp   0/1     Init:0/1   0          2s

user@host:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   101m

user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/3-runapp/task2.yml 
deployment.apps/nginx-with-init-deployment unchanged
service/nginx-with-init-svc created

user@host:~$ kubectl get svc
NAME                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes            ClusterIP   10.152.183.1     <none>        443/TCP   101m
nginx-with-init-svc   ClusterIP   10.152.183.187   <none>        80/TCP    4s

user@host:~$ kubectl get pod
NAME                                          READY   STATUS    RESTARTS   AGE
nginx-with-init-deployment-567977478b-qtxcp   1/1     Running   0          23s

```
