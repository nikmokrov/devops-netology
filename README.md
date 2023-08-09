# Домашнее задание к занятию «Обновление приложений»

## Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

По условиям задачи у нас имеются следующие ограничения:
- Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
- Запас по ресурсам в менее загруженный момент времени составляет 20%.
- Обновление мажорное, новые версии приложения не умеют работать со старыми.

Основные стратегии обновления приложений - это Recreate, RollingUpdate, Blue-Green, RollingUpdate, A/B-testing, Shadow.</br>
В боевых средах применяют в основном только две - RollingUpdate и Blue-Green.</br>
Blue-Green и Shadow нам не подходят, т.к. требуют двойного резервирования ресурсов для реализации, чего у нас нет по условиям задачи (только 20% и нельзя увеличить).</br>
A/B-testing применяют в основном для тестирования нового функционала, у нас же речь именно про обновление.</br>
Recreate стратегия не подходит, т.к. приложение невозможно обновить или откатить без остановки сервисов.</br>
Остаются 2 варианта: RollingUpdate и Canary.</br>
Обе стратегии позволяют выполнить обновление в условиях ограниченности ресурсов. Но по условию задачи новые версии приложения не умеют работать со старыми, а это значит, что нельзя допускать ситуации, когда поды с новыми версиями (например, frontend) обращаются к старым версиям (backend). Обновление нужно проводить, постепенно заменяя поды старых версий новыми, направляя при этом трафик от новых версий к новым и от старых версий к старым. Простой RollingUpdate не может это обеспечить, следовательно наш выбор - стратегия Canary, которая позволяет управлять трафиком между подами приложения.


## Задание 2. Обновить приложение

[deploy.yml](./12-kuber/13-kuber_update/deploy.yml)</br>

1. Создаем deployment
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/13-kuber_update/deploy.yml 
deployment.apps/update-deployment created

user@host:~$ kubectl get deployment
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
update-deployment   5/5     5            5           16s

user@host:~$ kubectl describe deployments update-deployment
Name:                   update-deployment
Namespace:              default
CreationTimestamp:      Tue, 08 Aug 2023 19:49:23 +0300
Labels:                 app=nginx-multitool
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx-multitool
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  0% max unavailable, 100% max surge
Pod Template:
  Labels:  app=nginx-multitool
  Containers:
   nginx:
    Image:        nginx:1.19.0
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
   multitool:
    Image:      wbitt/network-multitool
    Port:       <none>
    Host Port:  <none>
    Environment:
      HTTP_PORT:  8888
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   update-deployment-79b9f89c7f (5/5 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  29s   deployment-controller  Scaled up replica set update-deployment-79b9f89c7f to 5
```

2. Обновляем версию nginx в приложении до версии 1.20
```console
user@host:~$ kubectl set image deployment/update-deployment nginx=nginx:1.20.0
deployment.apps/update-deployment image updated

user@host:~$ kubectl get deployments
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
update-deployment   5/5     5            5           31s

user@host:~$ kubectl describe deployments update-deployment
Name:                   update-deployment
Namespace:              default
CreationTimestamp:      Tue, 08 Aug 2023 19:49:23 +0300
Labels:                 app=nginx-multitool
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=nginx-multitool
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  0% max unavailable, 100% max surge
Pod Template:
  Labels:  app=nginx-multitool
  Containers:
   nginx:
    Image:        nginx:1.20.0
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
   multitool:
    Image:      wbitt/network-multitool
    Port:       <none>
    Host Port:  <none>
    Environment:
      HTTP_PORT:  8888
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   update-deployment-9c779747f (5/5 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  57s   deployment-controller  Scaled up replica set update-deployment-79b9f89c7f to 5
  Normal  ScalingReplicaSet  10s   deployment-controller  Scaled up replica set update-deployment-9c779747f to 5
  Normal  ScalingReplicaSet  8s    deployment-controller  Scaled down replica set update-deployment-79b9f89c7f to 4 from 5
  Normal  ScalingReplicaSet  8s    deployment-controller  Scaled down replica set update-deployment-79b9f89c7f to 3 from 4
  Normal  ScalingReplicaSet  8s    deployment-controller  Scaled down replica set update-deployment-79b9f89c7f to 1 from 3
  Normal  ScalingReplicaSet  7s    deployment-controller  Scaled down replica set update-deployment-79b9f89c7f to 0 from 1
```

3. Пытаемся обновить nginx до версии 1.28
```console
user@host:~$ kubectl set image deployment/update-deployment nginx=nginx:1.28.0
deployment.apps/update-deployment image updated

user@host:~$ kubectl get pods
NAME                                 READY   STATUS             RESTARTS   AGE
update-deployment-5f75545945-7rlxx   1/2     ErrImagePull       0          71s
update-deployment-5f75545945-jg9cg   1/2     ErrImagePull       0          71s
update-deployment-5f75545945-rb79v   1/2     ImagePullBackOff   0          71s
update-deployment-5f75545945-rbssh   1/2     ErrImagePull       0          71s
update-deployment-5f75545945-zv222   1/2     ImagePullBackOff   0          71s
update-deployment-9c779747f-28gpg    2/2     Running            0          2m17s
update-deployment-9c779747f-7drgc    2/2     Running            0          2m17s
update-deployment-9c779747f-8c55j    2/2     Running            0          2m17s
update-deployment-9c779747f-bl4wx    2/2     Running            0          2m17s
update-deployment-9c779747f-ftgrw    2/2     Running            0          2m17s

user@host:~$ kubectl rollout status deployment/update-deployment
Waiting for deployment "update-deployment" rollout to finish: 5 old replicas are pending termination...

```

4. Откатываемся после неудачного обновления
```console
user@host:~$ kubectl rollout history deployment/update-deployment
deployment.apps/update-deployment 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
3         <none>

user@host:~$ kubectl rollout history deployment/update-deployment --revision=2
deployment.apps/update-deployment with revision #2
Pod Template:
  Labels:       app=nginx-multitool
        pod-template-hash=9c779747f
  Containers:
   nginx:
    Image:      nginx:1.20.0
    Port:       <none>
    Host Port:  <none>
    Environment:        <none>
    Mounts:     <none>
   multitool:
    Image:      wbitt/network-multitool
    Port:       <none>
    Host Port:  <none>
    Environment:
      HTTP_PORT:        8888
    Mounts:     <none>
  Volumes:      <none>

user@host:~$ kubectl rollout undo deployment/update-deployment --to-revision=2
deployment.apps/update-deployment rolled back

user@host:~$ kubectl rollout status deployment/update-deployment
deployment "update-deployment" successfully rolled out

user@host:~$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
update-deployment-9c779747f-28gpg   2/2     Running   0          6m40s
update-deployment-9c779747f-7drgc   2/2     Running   0          6m40s
update-deployment-9c779747f-8c55j   2/2     Running   0          6m40s
update-deployment-9c779747f-bl4wx   2/2     Running   0          6m40s
update-deployment-9c779747f-ftgrw   2/2     Running   0          6m40s
user@host:~$ kubectl get deployments
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
update-deployment   5/5     5            5           7m37s

user@host:~$ kubectl get rs
NAME                           DESIRED   CURRENT   READY   AGE
update-deployment-5797856659   0         0         0       6m30s
update-deployment-5f75545945   0         0         0       5m52s
update-deployment-79b9f89c7f   0         0         0       7m45s
update-deployment-9c779747f    5         5         5       6m58s

```

## Задание 3*. Создать Canary deployment

1. Устанавливаем в кластере nginx ingress
```console
user@host:~$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
"ingress-nginx" has been added to your repositories

user@host:~$ helm install ingress --namespace ingress --create-namespace --set rbac.create=true,controller.kind=DaemonSet,controller.service.type=ClusterIP,controller.hostNetwork=true ingress-nginx/ingress-nginx

```

2. Создаем deployment, configmap, service, ingress</br>
[canary.yml](./12-kuber/13-kuber_update/canary.yml)</br>

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/13-kuber_update/canary.yml 
configmap/nginx-blue-configmap created
configmap/nginx-green-configmap created
deployment.apps/nginx-blue-deployment created
deployment.apps/nginx-green-deployment created
service/nginx-blue-svc created
service/nginx-green-svc created
ingress.networking.k8s.io/blue-ingress created
ingress.networking.k8s.io/green-ingress created

user@host:~$ kubectl get ingress
NAME            CLASS   HOSTS   ADDRESS        PORTS   AGE
blue-ingress    nginx   *       10.102.46.71   80      16m
green-ingress   nginx   *       10.102.46.71   80      16m

user@host:~$ kubectl describe ingress blue-ingress
Name:             blue-ingress
Labels:           <none>
Namespace:        default
Address:          10.102.46.71
Ingress Class:    nginx
Default backend:  <default>
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /   nginx-blue-svc:nginx-port (10.244.189.65:80)
Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                From                      Message
  ----    ------  ----               ----                      -------
  Normal  Sync    16m (x2 over 16m)  nginx-ingress-controller  Scheduled for sync
  Normal  Sync    16m (x2 over 16m)  nginx-ingress-controller  Scheduled for sync

user@host:~$ kubectl describe ingress green-ingress
Name:             green-ingress
Labels:           <none>
Namespace:        default
Address:          10.102.46.71
Ingress Class:    nginx
Default backend:  <default>
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /   nginx-green-svc:nginx-port (10.244.235.131:80)
Annotations:  nginx.ingress.kubernetes.io/canary: true
              nginx.ingress.kubernetes.io/canary-by-header: x-canary
              nginx.ingress.kubernetes.io/canary-by-header-value: want green
              nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                  From                      Message
  ----    ------  ----                 ----                      -------
  Normal  Sync    8m59s (x6 over 17m)  nginx-ingress-controller  Scheduled for sync
  Normal  Sync    8m59s (x6 over 17m)  nginx-ingress-controller  Scheduled for sync

```

3. Если в запросе передать заголовок "x-canary: want green", попадаем на green deployment, во всех остальных случаях попадем на blue deployment
```console
ubuntu@worker1:~$ curl http://10.102.46.71/
<!doctype html>
<html lang="en">
  <head>
    <title>DEVOPS-22 nginx page - blue!</title>
  </head>
  <body>
    <h1>DEVOPS-22 nginx sample page for canary deployment - blue</h1>
  </body>
</html>

ubuntu@worker1:~$ curl -H "x-canary: want blue" http://10.102.46.71/
<!doctype html>
<html lang="en">
  <head>
    <title>DEVOPS-22 nginx page - blue!</title>
  </head>
  <body>
    <h1>DEVOPS-22 nginx sample page for canary deployment - blue</h1>
  </body>
</html>

ubuntu@worker1:~$ curl -H "x-canary: want green" http://10.102.46.71/
<!doctype html>
<html lang="en">
  <head>
    <title>DEVOPS-22 nginx page - green!</title>
  </head>
  <body>
    <h1>DEVOPS-22 nginx sample page for canary deployment - green</h1>
  </body>
</html>

```