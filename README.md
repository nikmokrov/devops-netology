# Домашнее задание к занятию «Установка Kubernetes»

## Задание 1. Установить кластер k8s с 1 master node

1. Создаем 5 ВМ (1 master, 4 worker) с помощью Terraform</br>
[main.tf](./12-kuber/11-kuber_install/task1/terraform/main.tf)
2. Производим предварительную настройку нод с помощью Ansible, устанавливаем необходимые пакеты</br>
[kubeadm.yml](./12-kuber/11-kuber_install/task1/playbook/kubeadm.yml)
3. Инициализируем кластер
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/11-kuber_install$ yc compute instance list
+----------------------+---------+---------------+---------+----------------+-------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------+---------------+---------+----------------+-------------+
| epd3sdar7m6k1dedgsdd | master1 | ru-central1-b | RUNNING | 158.160.64.109 | 10.129.0.17 |
| epdform0boii92k67gbo | worker3 | ru-central1-b | RUNNING | 158.160.64.253 | 10.129.0.29 |
| epdgjtjachq96ek8l7jp | worker2 | ru-central1-b | RUNNING | 158.160.74.249 | 10.129.0.32 |
| epdqss20bj58f53l2h6f | worker4 | ru-central1-b | RUNNING | 158.160.68.174 | 10.129.0.27 |
| epdt6jefb0qmqlc1vbua | worker1 | ru-central1-b | RUNNING | 158.160.80.240 | 10.129.0.3  |
+----------------------+---------+---------------+---------+----------------+-------------+

ubuntu@master1:~$ sudo kubeadm init --apiserver-advertise-address=10.129.0.17 --pod-network-cidr 10.244.0.0/16 --apiserver-cert-extra-sans=158.160.64.109

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.129.0.17:6443 --token tzob67.2mie765vor7ex5oj \
        --discovery-token-ca-cert-hash sha256:df000c7a6ab74ad7f58bcb5e39985b8ee45f4af5f004b328270b9457be2956c3 


ubuntu@master1:~$ mkdir -p $HOME/.kube
ubuntu@master1:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
ubuntu@master1:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

ubuntu@master1:~$ kubectl get nodes
NAME      STATUS     ROLES           AGE    VERSION
master1   NotReady   control-plane   2m3s   v1.25.12
```

4. Кластер в статусе NotReady. Чтобы он заработал, устанавливаем Calico CNI
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/11-kuber_install/task1$ kubectl create -f calico.yaml 
poddisruptionbudget.policy/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
serviceaccount/calico-node created
serviceaccount/calico-cni-plugin created
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgpfilters.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrole.rbac.authorization.k8s.io/calico-cni-plugin created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-cni-plugin created
daemonset.apps/calico-node created
deployment.apps/calico-kube-controllers created

ubuntu@master1:~$ kubectl get nodes
NAME      STATUS   ROLES           AGE     VERSION
master1   Ready    control-plane   4m10s   v1.25.12

ubuntu@master1:~$ kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-74cfc9ffcc-kdrp5   1/1     Running   0          55s
kube-system   calico-node-hnbtb                          1/1     Running   0          55s
kube-system   coredns-565d847f94-9rvq9                   1/1     Running   0          4m11s
kube-system   coredns-565d847f94-m7kfq                   1/1     Running   0          4m12s
kube-system   etcd-master1                               1/1     Running   0          4m27s
kube-system   kube-apiserver-master1                     1/1     Running   0          4m27s
kube-system   kube-controller-manager-master1            1/1     Running   0          4m25s
kube-system   kube-proxy-g6cst                           1/1     Running   0          4m12s
kube-system   kube-scheduler-master1                     1/1     Running   0          4m25s
```

5. Последовательно добавляем worker ноды в кластер. Для этого выполняем на каждой ноде:
```console
ubuntu@worker1:~$ sudo kubeadm join 10.129.0.17:6443 --token tzob67.2mie765vor7ex5oj --discovery-token-ca-cert-hash sha256:df000c7a6ab74ad7f58bcb5e39985b8ee45f4af5f004b328270b9457be2956c3
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

ubuntu@worker2:~$ sudo kubeadm join 10.129.0.17:6443 --token tzob67.2mie765vor7ex5oj --discovery-token-ca-cert-hash sha256:df000c7a6ab74ad7f58bcb5e39985b8ee45f4af5f004b328270b9457be2956c3

ubuntu@worker3:~$ sudo kubeadm join 10.129.0.17:6443 --token tzob67.2mie765vor7ex5oj --discovery-token-ca-cert-hash sha256:df000c7a6ab74ad7f58bcb5e39985b8ee45f4af5f004b328270b9457be2956c3

ubuntu@worker4:~$ sudo kubeadm join 10.129.0.17:6443 --token tzob67.2mie765vor7ex5oj --discovery-token-ca-cert-hash sha256:df000c7a6ab74ad7f58bcb5e39985b8ee45f4af5f004b328270b9457be2956c3
```

6. Кластер собран
```console
ubuntu@master1:~$ kubectl get nodes
NAME      STATUS   ROLES           AGE     VERSION
master1   Ready    control-plane   7m56s   v1.25.12
worker1   Ready    <none>          2m41s   v1.25.12
worker2   Ready    <none>          117s    v1.25.12
worker3   Ready    <none>          66s     v1.25.12
worker4   Ready    <none>          33s     v1.25.12
```


## Задание 2*. Установить HA кластер

1. Создаем 7 ВМ (3 master, 3 worker, 1 loadbalncer) с помощью Terraform</br>
[main.tf](./12-kuber/11-kuber_install/task2/terraform/main.tf)
2. Производим предварительную настройку нод с помощью Ansible, устанавливаем необходимые пакеты, настраиваем haproxy</br>
[kubeadm.yml](./12-kuber/11-kuber_install/task2/playbook/kubeadm.yml)
3. Инициализируем кластер, указываем в качестве control-plane-endpoint адрес haproxy, устанавливаем Calico CNI
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/12-kuber/11-kuber_install/task2/playbook$ yc compute instance list
+----------------------+---------------+---------------+---------+----------------+-------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------------+---------------+---------+----------------+-------------+
| epd0k8c2fkdneaam9dqo | worker1       | ru-central1-b | RUNNING | 158.160.68.190 | 10.129.0.20 |
| epda1i0nrue9f241cgtj | worker3       | ru-central1-b | RUNNING | 158.160.81.16  | 10.129.0.30 |
| epdb0548muo851scs8u4 | worker2       | ru-central1-b | RUNNING | 130.193.55.180 | 10.129.0.34 |
| epdb822d5icj4l6hg419 | master3       | ru-central1-b | RUNNING | 158.160.6.170  | 10.129.0.27 |
| epdhk7e40pr1iabb3k75 | loadbalancer1 | ru-central1-b | RUNNING | 51.250.31.213  | 10.129.0.7  |
| epdjtrf4dkgqss49tl1f | master1       | ru-central1-b | RUNNING | 158.160.80.86  | 10.129.0.3  |
| epdq6b47t979l22rgl61 | master2       | ru-central1-b | RUNNING | 158.160.77.218 | 10.129.0.19 |
+----------------------+---------------+---------------+---------+----------------+-------------+

ubuntu@master1:~$ sudo kubeadm init --apiserver-advertise-address=10.129.0.3 --apiserver-bind-port=6443 --pod-network-cidr 10.244.0.0/16 --apiserver-cert-extra-sans=51.250.31.213,10.129.0.7,10.129.0.3,10.129.0.19,10.129.0.27 --control-plane-endpoint=10.129.0.7:7443

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 10.129.0.7:7443 --token q53z7k.tw3p324jkyuxa0iz \
        --discovery-token-ca-cert-hash sha256:c4ab12992b28c0a12a07e3677f6c201baf0ec836916cd4cbe61c97fbadaa0c7c \
        --control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.129.0.7:7443 --token q53z7k.tw3p324jkyuxa0iz \
        --discovery-token-ca-cert-hash sha256:c4ab12992b28c0a12a07e3677f6c201baf0ec836916cd4cbe61c97fbadaa0c7c 


user@host:~$ kubectl create -f Netology/DEVOPS-22/devops-netology/12-kuber/11-kuber_install/task2/calico.yaml

user@host:~$ kubectl get nodes
NAME      STATUS   ROLES           AGE     VERSION
master1   Ready    control-plane   3m53s   v1.25.12

user@host:~$ kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-74cfc9ffcc-rz6vl   1/1     Running   0          55s
kube-system   calico-node-l6nkn                          1/1     Running   0          55s
kube-system   coredns-565d847f94-dvffp                   1/1     Running   0          3m55s
kube-system   coredns-565d847f94-h7bgr                   1/1     Running   0          3m55s
kube-system   etcd-master1                               1/1     Running   0          4m8s
kube-system   kube-apiserver-master1                     1/1     Running   0          4m8s
kube-system   kube-controller-manager-master1            1/1     Running   0          4m8s
kube-system   kube-proxy-pgwz2                           1/1     Running   0          3m55s
kube-system   kube-scheduler-master1                     1/1     Running   0          4m9s

```

4. Добавляем master ноды в кластер. Для этого выполняем на каждой ноде:
```console
ubuntu@master1:~$ sudo kubeadm init phase upload-certs --upload-certs
I0802 16:59:57.716254   17536 version.go:256] remote version is much newer: v1.27.4; falling back to: stable-1.25
[upload-certs] Storing the certificates in Secret "kubeadm-certs" in the "kube-system" Namespace
[upload-certs] Using certificate key:
14821d133699402d36bb3cfc5cbbb26a1162d175b5d621c23d348710ad4fb470

ubuntu@master2:~$ sudo kubeadm join 10.129.0.7:7443 --token q53z7k.tw3p324jkyuxa0iz --discovery-token-ca-cert-hash sha256:c4ab12992b28c0a12a07e3677f6c201baf0ec836916cd4cbe61c97fbadaa0c7c --control-plane --certificate-key 14821d133699402d36bb3cfc5cbbb26a1162d175b5d621c23d348710ad4fb470

ubuntu@master3:~$ sudo kubeadm join 10.129.0.7:7443 --token q53z7k.tw3p324jkyuxa0iz --discovery-token-ca-cert-hash sha256:c4ab12992b28c0a12a07e3677f6c201baf0ec836916cd4cbe61c97fbadaa0c7c --control-plane --certificate-key 14821d133699402d36bb3cfc5cbbb26a1162d175b5d621c23d348710ad4fb470

ubuntu@master1:~$ kubectl get nodes
NAME      STATUS   ROLES           AGE     VERSION
master1   Ready    control-plane   10m     v1.25.12
master2   Ready    control-plane   2m30s   v1.25.12
master3   Ready    control-plane   43s     v1.25.12

```

5. Добавляем worker ноды в кластер. Для этого выполняем на каждой ноде:
```console
ubuntu@worker1:~$ sudo kubeadm join 10.129.0.7:7443 --token q53z7k.tw3p324jkyuxa0iz --discovery-token-ca-cert-hash sha256:c4ab12992b28c0a12a07e3677f6c201baf0ec836916cd4cbe61c97fbadaa0c7c

ubuntu@worker2:~$ sudo kubeadm join 10.129.0.7:7443 --token q53z7k.tw3p324jkyuxa0iz --discovery-token-ca-cert-hash sha256:c4ab12992b28c0a12a07e3677f6c201baf0ec836916cd4cbe61c97fbadaa0c7c

ubuntu@worker3:~$ sudo kubeadm join 10.129.0.7:7443 --token q53z7k.tw3p324jkyuxa0iz --discovery-token-ca-cert-hash sha256:c4ab12992b28c0a12a07e3677f6c201baf0ec836916cd4cbe61c97fbadaa0c7c
```

6. Кластер собран
```console
ubuntu@master1:~$ kubectl get nodes
NAME      STATUS   ROLES           AGE     VERSION
master1   Ready    control-plane   12m     v1.25.12
master2   Ready    control-plane   5m18s   v1.25.12
master3   Ready    control-plane   3m31s   v1.25.12
worker1   Ready    <none>          113s    v1.25.12
worker2   Ready    <none>          62s     v1.25.12
worker3   Ready    <none>          33s     v1.25.12

ubuntu@master1:~$ kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS        AGE
kube-system   calico-kube-controllers-74cfc9ffcc-rz6vl   1/1     Running   0               9m49s
kube-system   calico-node-2bj46                          1/1     Running   0               2m6s
kube-system   calico-node-52bh7                          1/1     Running   0               46s
kube-system   calico-node-9bd9k                          1/1     Running   0               3m44s
kube-system   calico-node-b76gk                          1/1     Running   0               75s
kube-system   calico-node-l6nkn                          1/1     Running   0               9m49s
kube-system   calico-node-vr77p                          1/1     Running   0               5m31s
kube-system   coredns-565d847f94-dvffp                   1/1     Running   0               12m
kube-system   coredns-565d847f94-h7bgr                   1/1     Running   0               12m
kube-system   etcd-master1                               1/1     Running   0               13m
kube-system   etcd-master2                               1/1     Running   0               5m21s
kube-system   etcd-master3                               1/1     Running   0               3m33s
kube-system   kube-apiserver-master1                     1/1     Running   0               13m
kube-system   kube-apiserver-master2                     1/1     Running   1 (5m22s ago)   5m19s
kube-system   kube-apiserver-master3                     1/1     Running   0               3m28s
kube-system   kube-controller-manager-master1            1/1     Running   1 (5m20s ago)   13m
kube-system   kube-controller-manager-master2            1/1     Running   0               5m26s
kube-system   kube-controller-manager-master3            1/1     Running   0               2m37s
kube-system   kube-proxy-62kqr                           1/1     Running   0               5m31s
kube-system   kube-proxy-g8wcj                           1/1     Running   0               46s
kube-system   kube-proxy-gg2sb                           1/1     Running   0               75s
kube-system   kube-proxy-gzx8j                           1/1     Running   0               3m44s
kube-system   kube-proxy-ncbjg                           1/1     Running   0               2m6s
kube-system   kube-proxy-pgwz2                           1/1     Running   0               12m
kube-system   kube-scheduler-master1                     1/1     Running   1 (5m20s ago)   13m
kube-system   kube-scheduler-master2                     1/1     Running   0               5m22s
kube-system   kube-scheduler-master3                     1/1     Running   0               2m30s

```