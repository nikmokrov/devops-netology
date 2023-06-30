# Домашнее задание к занятию «Хранение в K8s. Часть 1»

## Задание 1

[Манифест Task1.yml](12-kuber/6-kuber_stor1/task1.yml)

1.
```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/6-kuber_stor1/task1.yml 
deployment.apps/shared-volume-deployment created

user@host:~$ kubectl get pods  
NAME                                       READY   STATUS    RESTARTS   AGE
shared-volume-deployment-9794fc8df-mct2b   2/2     Running   0          14s

user@host:~$ kubectl exec shared-volume-deployment-9794fc8df-mct2b -c busybox -- cat /output/stamp.txt
2023-06-30 05:47:57 to stamp.txt
2023-06-30 05:48:02 to stamp.txt
2023-06-30 05:48:07 to stamp.txt

user@host:~$ kubectl exec shared-volume-deployment-9794fc8df-mct2b -c multitool -- cat /input/stamp.txt    
2023-06-30 05:47:57 to stamp.txt
2023-06-30 05:48:02 to stamp.txt
2023-06-30 05:48:07 to stamp.txt
2023-06-30 05:48:12 to stamp.txt
2023-06-30 05:48:17 to stamp.txt

user@host:~$ kubectl exec shared-volume-deployment-9794fc8df-mct2b -c multitool -- cat /input/stamp.txt
2023-06-30 05:47:57 to stamp.txt
2023-06-30 05:48:02 to stamp.txt
2023-06-30 05:48:07 to stamp.txt
2023-06-30 05:48:12 to stamp.txt
2023-06-30 05:48:17 to stamp.txt
2023-06-30 05:48:22 to stamp.txt
2023-06-30 05:48:27 to stamp.txt
2023-06-30 05:48:32 to stamp.txt
2023-06-30 05:48:37 to stamp.txt

```

## Задание 2

[Манифест Task2.yml](12-kuber/6-kuber_stor1/task2.yml)

```console
user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/6-kuber_stor1/task2.yml
daemonset.apps/syslog-from-pod-daemonset created

user@host:~$ kubectl get daemonset
NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
syslog-from-pod-daemonset   1         1         1       1            1           <none>          4s

user@host:~$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
syslog-from-pod-daemonset-rvtp8   1/1     Running   0          9s

user@host:~$ kubectl exec syslog-from-pod-daemonset-rvtp8 -- tail /input/syslog
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: 2023-06-30 06:10:09.623 [WARNING][80416] ipam_plugin.go 433: Asked to release address but it doesn't exist. Ignoring ContainerID="b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a" HandleID="k8s-pod-network.b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a" Workload="microk8s-k8s-syslog--from--pod--deployment--7fjfc-eth0"
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: 2023-06-30 06:10:09.623 [INFO][80416] ipam_plugin.go 444: Releasing address using workloadID ContainerID="b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a" HandleID="k8s-pod-network.b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a" Workload="microk8s-k8s-syslog--from--pod--deployment--7fjfc-eth0"
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: time="2023-06-30T06:10:09Z" level=info msg="Released host-wide IPAM lock." source="ipam_plugin.go:378"
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: 2023-06-30 06:10:09.627 [INFO][80410] k8s.go 589: Teardown processing complete. ContainerID="b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a"
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: time="2023-06-30T06:10:09.629048948Z" level=info msg="TearDown network for sandbox \"b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a\" successfully"
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: time="2023-06-30T06:10:09.662618670Z" level=info msg="RemovePodSandbox \"b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a\" returns successfully"
Jun 30 06:10:10 microk8s systemd[1]: run-containerd-runc-k8s.io-e6ce029929f14434aeb1b934936aab719b0fd470644a270c18b157820ebe792a-runc.QXoAUV.mount: Deactivated successfully.
Jun 30 06:10:15 microk8s systemd[1]: run-containerd-runc-k8s.io-c39fabd3570ce6a95fa94a67edd2cb6846403cb43a3fffd6c79e285580df3305-runc.GzKW1a.mount: Deactivated successfully.
Jun 30 06:10:15 microk8s systemd[1]: run-containerd-runc-k8s.io-c39fabd3570ce6a95fa94a67edd2cb6846403cb43a3fffd6c79e285580df3305-runc.AmVqPM.mount: Deactivated successfully.
Jun 30 06:10:19 microk8s systemd[1]: run-containerd-runc-k8s.io-e6ce029929f14434aeb1b934936aab719b0fd470644a270c18b157820ebe792a-runc.yICHdE.mount: Deactivated successfully.

ubuntu@microk8s:~$ tail /var/log/syslog
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: 2023-06-30 06:10:09.627 [INFO][80410] k8s.go 589: Teardown processing complete. ContainerID="b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a"
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: time="2023-06-30T06:10:09.629048948Z" level=info msg="TearDown network for sandbox \"b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a\" successfully"
Jun 30 06:10:09 microk8s microk8s.daemon-containerd[14020]: time="2023-06-30T06:10:09.662618670Z" level=info msg="RemovePodSandbox \"b1b4ef351e78265531cfd28f351fc3bf70bccb8e6b3ba14fca302c39d87b4c4a\" returns successfully"
Jun 30 06:10:10 microk8s systemd[1]: run-containerd-runc-k8s.io-e6ce029929f14434aeb1b934936aab719b0fd470644a270c18b157820ebe792a-runc.QXoAUV.mount: Deactivated successfully.
Jun 30 06:10:15 microk8s systemd[1]: run-containerd-runc-k8s.io-c39fabd3570ce6a95fa94a67edd2cb6846403cb43a3fffd6c79e285580df3305-runc.GzKW1a.mount: Deactivated successfully.
Jun 30 06:10:15 microk8s systemd[1]: run-containerd-runc-k8s.io-c39fabd3570ce6a95fa94a67edd2cb6846403cb43a3fffd6c79e285580df3305-runc.AmVqPM.mount: Deactivated successfully.
Jun 30 06:10:19 microk8s systemd[1]: run-containerd-runc-k8s.io-e6ce029929f14434aeb1b934936aab719b0fd470644a270c18b157820ebe792a-runc.yICHdE.mount: Deactivated successfully.
Jun 30 06:10:20 microk8s systemd[1]: run-containerd-runc-k8s.io-6f77f9e9380bc9bdb022a3e6bb56c96310f573dd881773f2c112287703e3e09a-runc.pZpKHa.mount: Deactivated successfully.
Jun 30 06:10:20 microk8s systemd[1]: run-containerd-runc-k8s.io-e6ce029929f14434aeb1b934936aab719b0fd470644a270c18b157820ebe792a-runc.lQXfBm.mount: Deactivated successfully.
Jun 30 06:10:25 microk8s systemd[1]: run-containerd-runc-k8s.io-c39fabd3570ce6a95fa94a67edd2cb6846403cb43a3fffd6c79e285580df3305-runc.RZ8yuV.mount: Deactivated successfully.

```
