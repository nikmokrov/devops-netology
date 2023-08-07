# Домашнее задание к занятию «Как работает сеть в K8s»

## Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Манифесты

[deploy.yml](./12-kuber/12-kuber_netpolicy/deploy.yml)</br>
[netpolicy.yml](./12-kuber/12-kuber_netpolicy/netpolicy.yml)</br>

2. Создаем deployment'ы приложений frontend, backend и cache и соответствующие сервисы в неймспейсе app
```console
user@host:~$ kubectl create ns app
namespace/app created

user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/12-kuber_netpolicy/deploy.yml 
deployment.apps/frontend-deployment created
deployment.apps/backend-deployment created
deployment.apps/cache-deployment created
service/frontend-svc created
service/backend-svc created
service/cache-svc created

user@host:~$ kubectl -n app get pods
NAME                                   READY   STATUS    RESTARTS   AGE
backend-deployment-5496d7bd69-mfrpn    1/1     Running   0          38s
cache-deployment-7fb65c8f9f-mqkbx      1/1     Running   0          38s
frontend-deployment-699c98ccc7-7dj4q   1/1     Running   0          38s

user@host:~$ kubectl -n app get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
backend-svc    ClusterIP   10.97.228.135    <none>        80/TCP    49s
cache-svc      ClusterIP   10.100.103.124   <none>        80/TCP    49s
frontend-svc   ClusterIP   10.108.53.149    <none>        80/TCP    49s
```

3. Изначально, когда нет никаких сетевых политик, все приложения имеют доступ к друг другу
```console
user@host:~$ kubectl -n app exec frontend-deployment-699c98ccc7-7dj4q -- curl -s --connect-timeout 5 http://frontend-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - frontend-deployment-699c98ccc7-7dj4q - 10.244.235.129 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec frontend-deployment-699c98ccc7-7dj4q -- curl -s --connect-timeout 5 http://backend-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - backend-deployment-5496d7bd69-mfrpn - 10.244.189.65 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec frontend-deployment-699c98ccc7-7dj4q -- curl -s --connect-timeout 5 http://cache-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - cache-deployment-7fb65c8f9f-mqkbx - 10.244.235.130 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec backend-deployment-5496d7bd69-mfrpn -- curl -s --connect-timeout 5 http://frontend-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - frontend-deployment-699c98ccc7-7dj4q - 10.244.235.129 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec backend-deployment-5496d7bd69-mfrpn -- curl -s --connect-timeout 5 http://backend-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - backend-deployment-5496d7bd69-mfrpn - 10.244.189.65 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec backend-deployment-5496d7bd69-mfrpn -- curl -s --connect-timeout 5 http://cache-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - cache-deployment-7fb65c8f9f-mqkbx - 10.244.235.130 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec cache-deployment-7fb65c8f9f-mqkbx -- curl -s --connect-timeout 5 http://frontend-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - frontend-deployment-699c98ccc7-7dj4q - 10.244.235.129 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec cache-deployment-7fb65c8f9f-mqkbx -- curl -s --connect-timeout 5 http://backend-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - backend-deployment-5496d7bd69-mfrpn - 10.244.189.65 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

user@host:~$ kubectl -n app exec cache-deployment-7fb65c8f9f-mqkbx -- curl -s --connect-timeout 5 http://cache-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - cache-deployment-7fb65c8f9f-mqkbx - 10.244.235.130 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

```

4. Создаем сетевые политики для обеспечения доступа frontend -> backend -> cache
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/12-kuber_netpolicy/netpolicy.yml 
networkpolicy.networking.k8s.io/frontend-netpolicy created
networkpolicy.networking.k8s.io/backend-netpolicy created
networkpolicy.networking.k8s.io/cache-netpolicy created

user@host:~$ kubectl -n app get networkpolicy
NAME                 POD-SELECTOR   AGE
backend-netpolicy    app=backend    26m
cache-netpolicy      app=cache      26m
frontend-netpolicy   app=frontend   26m
```

5. frontend имеет доступ только в backend
```console
user@host:~$ kubectl -n app exec frontend-deployment-699c98ccc7-7dj4q -- curl -s --connect-timeout 5 http://frontend-svc.app.svc.cluster.local
command terminated with exit code 28

user@host:~$ kubectl -n app exec frontend-deployment-699c98ccc7-7dj4q -- curl -s --connect-timeout 5 http://cache-svc.app.svc.cluster.local
command terminated with exit code 28

user@host:~$ kubectl -n app exec frontend-deployment-699c98ccc7-7dj4q -- curl -s --connect-timeout 5 http://backend-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - backend-deployment-5496d7bd69-mfrpn - 10.244.189.65 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

6. backend имеет доступ только в cache
```console
user@host:~$ kubectl -n app exec backend-deployment-5496d7bd69-mfrpn -- curl -s --connect-timeout 5 http://backend-svc.app.svc.cluster.local
command terminated with exit code 28

user@host:~$ kubectl -n app exec backend-deployment-5496d7bd69-mfrpn -- curl -s --connect-timeout 5 http://frontend-svc.app.svc.cluster.local
command terminated with exit code 28

user@host:~$ kubectl -n app exec backend-deployment-5496d7bd69-mfrpn -- curl -s --connect-timeout 5 http://cache-svc.app.svc.cluster.local
WBITT Network MultiTool (with NGINX) - cache-deployment-7fb65c8f9f-mqkbx - 10.244.235.130 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

7. Из cache нет доступа никуда
```console
user@host:~$ kubectl -n app exec cache-deployment-7fb65c8f9f-mqkbx -- curl -s --connect-timeout 5 http://cache-svc.app.svc.cluster.local
command terminated with exit code 28

user@host:~$ kubectl -n app exec cache-deployment-7fb65c8f9f-mqkbx -- curl -s --connect-timeout 5 http://frontend-svc.app.svc.cluster.local
command terminated with exit code 28

user@host:~$ kubectl -n app exec cache-deployment-7fb65c8f9f-mqkbx -- curl -s --connect-timeout 5 http://backend-svc.app.svc.cluster.local
command terminated with exit code 28

```