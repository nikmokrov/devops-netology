# Домашнее задание к занятию «Helm»

## Задание 1. Подготовить Helm-чарт для приложения

Чарт

[Chart.yml](12-kuber/10-kuber_helm/devops22-chart/Chart.yaml)</br>
[values.yml](12-kuber/10-kuber_helm/devops22-chart/values.yaml)</br>
[deployment.yml](12-kuber/10-kuber_helm/devops22-chart/templates/deployment.yaml)</br>
[service.yml](12-kuber/10-kuber_helm/devops22-chart/templates/service.yaml)</br>
[ingress.yml](12-kuber/10-kuber_helm/devops22-chart/templates/ingress.yaml)</br>

```console
user@host:~/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm$ helm create devops22-chart
Creating devops22-chart

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm package ./
Successfully packaged chart and saved it to: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart/devops22-chart-0.1.0.tgz

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm install deploy-1 devops22-chart-0.1.0.tgz 
NAME: deploy-1
LAST DEPLOYED: Tue Jul 25 11:35:42 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Just installed deploy-1-devops22-chart-app

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm install deploy-2 --set image.tag="1.20.0" devops22-chart-0.1.0.tgz 
NAME: deploy-2
LAST DEPLOYED: Tue Jul 25 11:36:08 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Just installed deploy-2-devops22-chart-app

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl get pods
NAME                                           READY   STATUS    RESTARTS   AGE
deploy-1-devops22-chart-app-9ffcbd767-fvkb7    1/1     Running   0          50s
deploy-2-devops22-chart-app-668bd668c5-s6mnw   1/1     Running   0          21s

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl exec deploy-1-devops22-chart-app-9ffcbd767-fvkb7 -- nginx -Vnginx version: nginx/1.19.0
built by gcc 8.3.0 (Debian 8.3.0-6) 
built with OpenSSL 1.1.1d  10 Sep 2019

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl exec deploy-2-devops22-chart-app-668bd668c5-s6mnw -- nginx -V
nginx version: nginx/1.20.0
built by gcc 8.3.0 (Debian 8.3.0-6) 
built with OpenSSL 1.1.1d  10 Sep 2019

```

## Задание 2. Запустить две версии в разных неймспейсах

```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm install deploy-1 -n app1 --create-namespace devops22-chart-0.1.0.tgz NAME: deploy-1
LAST DEPLOYED: Tue Jul 25 11:38:10 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Just installed deploy-1-devops22-chart-app

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm install deploy-2 -n app1 --create-namespace --set image.tag="1.20.0" devops22-chart-0.1.0.tgz 
NAME: deploy-2
LAST DEPLOYED: Tue Jul 25 11:38:32 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Just installed deploy-2-devops22-chart-app

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm install deploy-3 -n app2 --create-namespace --set image.tag="1.21.0" devops22-chart-0.1.0.tgz 
NAME: deploy-3
LAST DEPLOYED: Tue Jul 25 11:38:45 2023
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Just installed deploy-3-devops22-chart-app

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm list -n app1
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
deploy-1        app1            1               2023-07-25 11:38:10.344357198 +0300 MSK deployed        devops22-chart-0.1.0    1.19.0     
deploy-2        app1            1               2023-07-25 11:38:32.112660441 +0300 MSK deployed        devops22-chart-0.1.0    1.19.0     

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ helm list -n app2
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
deploy-3        app2            1               2023-07-25 11:38:45.214961096 +0300 MSK deployed        devops22-chart-0.1.0    1.19.0 

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl get pods -n app1
NAME                                           READY   STATUS    RESTARTS   AGE
deploy-1-devops22-chart-app-9ffcbd767-qls99    1/1     Running   0          90s
deploy-2-devops22-chart-app-668bd668c5-ts4hp   1/1     Running   0          68s

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl get pods -n app2
NAME                                          READY   STATUS    RESTARTS   AGE
deploy-3-devops22-chart-app-7c849db6b-d89tj   1/1     Running   0          58s

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl exec -n app1 deploy-1-devops22-chart-app-9ffcbd767-qls99 -- nginx -V
nginx version: nginx/1.19.0
built by gcc 8.3.0 (Debian 8.3.0-6) 
built with OpenSSL 1.1.1d  10 Sep 2019

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl exec -n app1 deploy-2-devops22-chart-app-668bd668c5-ts4hp -- nginx -V
nginx version: nginx/1.20.0
built by gcc 8.3.0 (Debian 8.3.0-6) 
built with OpenSSL 1.1.1d  10 Sep 2019

user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/10-kuber_helm/devops22-chart$ kubectl exec -n app2 deploy-3-devops22-chart-app-7c849db6b-d89tj  -- nginx -V
nginx version: nginx/1.21.0
built by gcc 8.3.0 (Debian 8.3.0-6) 
built with OpenSSL 1.1.1d  10 Sep 2019

```