# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

## Задание 1. Создать Deployment приложений backend и frontend

[Манифест Task1.yml](12-kuber/5-kuber_net2/task1.yml)

1.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/5-kuber_net2/task1.yml 
deployment.apps/frontend-deployment created
deployment.apps/backend-deployment created
service/frontend-svc created
service/backend-svc created

user@host:~$ kubectl get pods
NAME                                  READY   STATUS              RESTARTS   AGE
frontend-deployment-bb967c945-vzs9g   0/1     ContainerCreating   0          12s
frontend-deployment-bb967c945-zn7c9   0/1     ContainerCreating   0          12s
frontend-deployment-bb967c945-245jj   0/1     ContainerCreating   0          12s
backend-deployment-58979d9689-gjk5g   0/1     ContainerCreating   0          12s
backend-deployment-58979d9689-cfs7d   0/1     ContainerCreating   0          11s
backend-deployment-58979d9689-5dkbv   0/1     ContainerCreating   0          11s

user@host:~$ kubectl get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP   10m
frontend-svc   ClusterIP   10.152.183.210   <none>        80/TCP    15s
backend-svc    ClusterIP   10.152.183.105   <none>        80/TCP    14s

user@host:~$ kubectl exec pod/frontend-deployment-bb967c945-vzs9g -- curl http://backend-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   152  100   152    0     0  39800      0 --:--:-- --:--:-- --:--:-- 50666
WBITT Network MultiTool (with NGINX) - backend-deployment-58979d9689-5dkbv - 10.1.128.208 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl exec pod/backend-deployment-58979d9689-gjk5g -- curl http://frontend-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   202k      0 --:--:-- --:--:-- --:--:--  300k
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

## Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

[Манифест Task2.yml](12-kuber/5-kuber_net2/task2.yml)

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/5-kuber_net2/task2.yml
ingress.networking.k8s.io/task2-ingress created

user@host:~$ kubectl get ingress
NAME            CLASS    HOSTS   ADDRESS     PORTS   AGE
task2-ingress   public   *       127.0.0.1   80      6m31s

user@host:~$ kubectl get ep
NAME           ENDPOINTS                                         AGE
kubernetes     10.129.0.20:16443                                 35m
frontend-svc   10.1.128.203:80,10.1.128.204:80,10.1.128.205:80   25m
backend-svc    10.1.128.206:80,10.1.128.207:80,10.1.128.208:80   25m

ubuntu@microk8s:~$ curl http://10.129.0.20/
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

ubuntu@microk8s:~$ curl http://10.129.0.20/api
WBITT Network MultiTool (with NGINX) - backend-deployment-58979d9689-cfs7d - 10.1.128.207 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

```
