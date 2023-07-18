# Домашнее задание к занятию «Конфигурация приложений»

## Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

[Манифест Task1.yml](12-kuber/8-kuber_config/task1.yml)

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/8-kuber_config/task1.yml
configmap/multitool-port-configmap created
configmap/nginx-index-configmap created
deployment.apps/nginx-configmap-deployment created
service/nginx-svc created
pod/external-multitool created

user@host:~$ kubectl get pods
NAME                                          READY   STATUS    RESTARTS   AGE
nginx-configmap-deployment-795c45d684-zk9fh   2/2     Running   0          8s
external-multitool                            1/1     Running   0          8s

user@host:~$ kubectl get configmaps
NAME                       DATA   AGE
kube-root-ca.crt           1      29m
multitool-port-configmap   1      17s
nginx-index-configmap      1      17s

user@host:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP   29m
nginx-svc    ClusterIP   10.152.183.166   <none>        80/TCP    28s

user@host:~$ kubectl exec external-multitool -- curl http://nginx-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   192  100   192    0     0   114k      0 --:--:-- --:--:-- --:--:--  187k
<!doctype html>
<html lang="en">
  <head>
    <title>DEVOPS-22 nginx sample page</title>
  </head>
  <body>
    <h1>DEVOPS-22 nginx sample page for k8s ConfigMap lesson</h1>
  </body>
</html>


```


## Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS

[Манифест Task2.yml](12-kuber/8-kuber_config/task2.yml)

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/8-kuber_config/task2.yml
configmap/nginx-index-configmap created
secret/nginx-tls-secret created
deployment.apps/nginx-configmap-deployment created
service/nginx-svc created
ingress.networking.k8s.io/nginx-ingress created

user@host:~$ kubectl get pods
NAME                                          READY   STATUS    RESTARTS   AGE
nginx-configmap-deployment-6d969dc844-cdgbr   1/1     Running   0          8s

user@host:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP   21m
nginx-svc    ClusterIP   10.152.183.37   <none>        80/TCP    13s

user@host:~$ kubectl get ingress
NAME            CLASS    HOSTS   ADDRESS   PORTS     AGE
nginx-ingress   public   *                 80, 443   15s

user@host:~$ kubectl get configmap
NAME                    DATA   AGE
kube-root-ca.crt        1      22m
nginx-index-configmap   1      23s

user@host:~$ kubectl get secret
NAME               TYPE   DATA   AGE
nginx-tls-secret   tls    2      28s

ubuntu@microk8s:~$ curl -k https://localhost
<!doctype html>
<html lang="en">
  <head>
    <title>DEVOPS-22 nginx sample page</title>
  </head>
  <body>
    <h1>DEVOPS-22 nginx sample page for k8s ConfigMap lesson</h1>
  </body>
</html>

ubuntu@microk8s:~$ curl -k https://10.129.0.30
<!doctype html>
<html lang="en">
  <head>
    <title>DEVOPS-22 nginx sample page</title>
  </head>
  <body>
    <h1>DEVOPS-22 nginx sample page for k8s ConfigMap lesson</h1>
  </body>
</html>

```
