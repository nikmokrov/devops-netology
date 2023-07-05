# Домашнее задание к занятию «Хранение в K8s. Часть 2»

## Задание 1

[Манифест Task1.yml](12-kuber/7-kuber_stor2/task1.yml)

1-3.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/7-kuber_stor2/task1.yml 
deployment.apps/pv-deployment created
persistentvolume/persist-vol created
persistentvolumeclaim/persist-vol-claim created

user@host:~$ kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
pv-deployment-77855c664-hhlkp   2/2     Running   0          23s

user@host:~$ kubectl get pv
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                       STORAGECLASS   REASON   AGE
persist-vol   100Mi      RWO            Delete           Bound    default/persist-vol-claim                           28s

user@host:~$ kubectl get pvc
NAME                STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persist-vol-claim   Bound    persist-vol   100Mi      RWO                           31s

user@host:~$ kubectl exec pv-deployment-77855c664-hhlkp -c busybox -- tail /output/stamp.txt
2023-07-05 14:17:34 to stamp.txt
2023-07-05 14:17:39 to stamp.txt
2023-07-05 14:17:44 to stamp.txt
2023-07-05 14:17:49 to stamp.txt
2023-07-05 14:17:54 to stamp.txt
2023-07-05 14:17:59 to stamp.txt
2023-07-05 14:18:04 to stamp.txt
2023-07-05 14:18:09 to stamp.txt
2023-07-05 14:18:14 to stamp.txt
2023-07-05 14:18:19 to stamp.txt

user@host:~$ kubectl exec pv-deployment-77855c664-hhlkp -c multitool -- tail /input/stamp.txt
2023-07-05 14:17:49 to stamp.txt
2023-07-05 14:17:54 to stamp.txt
2023-07-05 14:17:59 to stamp.txt
2023-07-05 14:18:04 to stamp.txt
2023-07-05 14:18:09 to stamp.txt
2023-07-05 14:18:14 to stamp.txt
2023-07-05 14:18:19 to stamp.txt
2023-07-05 14:18:24 to stamp.txt
2023-07-05 14:18:29 to stamp.txt
2023-07-05 14:18:34 to stamp.txt

root@microk8s:/# tail /srv/persist-vol/stamp.txt 
2023-07-05 14:18:04 to stamp.txt
2023-07-05 14:18:09 to stamp.txt
2023-07-05 14:18:14 to stamp.txt
2023-07-05 14:18:19 to stamp.txt
2023-07-05 14:18:24 to stamp.txt
2023-07-05 14:18:29 to stamp.txt
2023-07-05 14:18:34 to stamp.txt
2023-07-05 14:18:39 to stamp.txt
2023-07-05 14:18:44 to stamp.txt
2023-07-05 14:18:49 to stamp.txt
```
4.
```console
user@host:~$ kubectl delete deploy pv-deployment
deployment.apps "pv-deployment" deleted

user@host:~$ kubectl delete pvc persist-vol-claim
persistentvolumeclaim "persist-vol-claim" deleted

user@host:~$ kubectl get pv
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                       STORAGECLASS   REASON   AGE
persist-vol   100Mi      RWO            Retain           Released   default/persist-vol-claim                           81s

root@microk8s:/# tail /srv/persist-vol/stamp.txt 
2023-07-05 14:23:26 to stamp.txt
2023-07-05 14:23:31 to stamp.txt
2023-07-05 14:23:36 to stamp.txt
2023-07-05 14:23:41 to stamp.txt
2023-07-05 14:23:46 to stamp.txt
2023-07-05 14:23:51 to stamp.txt
2023-07-05 14:23:56 to stamp.txt
2023-07-05 14:24:01 to stamp.txt
2023-07-05 14:24:06 to stamp.txt
2023-07-05 14:24:11 to stamp.txt
```
После удаления Deployment и PVC PV перешел в статус Released. Это означает, что PV может стать доступным для другого PVC, но только после ручной очистки администратором. Файл на ноде, куда писал busybox, не удален.

5.
```console
user@host:~$ kubectl delete pv persist-vol
persistentvolume "persist-vol" deleted

user@host:~$ kubectl get pv
No resources found

root@microk8s:/# tail /srv/persist-vol/stamp.txt 
2023-07-05 14:23:26 to stamp.txt
2023-07-05 14:23:31 to stamp.txt
2023-07-05 14:23:36 to stamp.txt
2023-07-05 14:23:41 to stamp.txt
2023-07-05 14:23:46 to stamp.txt
2023-07-05 14:23:51 to stamp.txt
2023-07-05 14:23:56 to stamp.txt
2023-07-05 14:24:01 to stamp.txt
2023-07-05 14:24:06 to stamp.txt
2023-07-05 14:24:11 to stamp.txt

```

Файл по-прежнему существует, т.к. PV был создан статически с Reclaim Policy: Retain, что полностью исключает удаление данных даже после удаления PV.

## Задание 2

[Манифест Task2.yml](12-kuber/7-kuber_stor2/task2.yml)

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/7-kuber_stor2/task2.yml 
deployment.apps/pv-on-nfs-deployment created
persistentvolumeclaim/pv-on-nfs-claim created

user@host:~$ kubectl get sc
NAME      PROVISIONER      RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-csi   nfs.csi.k8s.io   Delete          Immediate           false                  3m9s

user@host:~$ kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
pv-on-nfs-deployment-c97976766-k6ncc   1/1     Running   0          15s

user@host:~$ kubectl get pvc
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pv-on-nfs-claim   Bound    pvc-af9cfc41-4abb-426c-9eac-93d2c258cf30   100Mi      RWO            nfs-csi        5s

user@host:~$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                     STORAGECLASS   REASON   AGE
pvc-af9cfc41-4abb-426c-9eac-93d2c258cf30   100Mi      RWO            Delete           Bound    default/pv-on-nfs-claim   nfs-csi                 5m44s

user@host:~$ kubectl exec pv-on-nfs-deployment-c97976766-k6ncc -- bash -c 'echo test > /pv-on-nfs/test.txt'

user@host:~$ kubectl exec pv-on-nfs-deployment-c97976766-k6ncc -- cat /pv-on-nfs/test.txt
test

root@microk8s:~# cat /srv/nfs/pvc-af9cfc41-4abb-426c-9eac-93d2c258cf30/test.txt
test

```
