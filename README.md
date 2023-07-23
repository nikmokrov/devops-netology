# Домашнее задание к занятию «Управление доступом»

## Задание 1. Создайте конфигурацию для подключения пользователя

[Манифест csr.yml](12-kuber/9-kuber_rbac/csr.yml)

[Манифест Task1.yml](12-kuber/9-kuber_rbac/task1.yml)

```console
user@host:~$ openssl genrsa -out devops22.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
.......................................+++++
.+++++
e is 65537 (0x010001)

user@host:~$ openssl req -new -key devops22.key -out devops22.csr -subj "/CN=devops22"

user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/9-kuber_rbac/csr.yml 
certificatesigningrequest.certificates.k8s.io/devops22 created

user@host:~$ kubectl get csr
NAME       AGE   SIGNERNAME                            REQUESTOR   REQUESTEDDURATION   CONDITION
devops22   18s   kubernetes.io/kube-apiserver-client   admin       10d                 Pending

user@host:~$ kubectl certificate approve devops22
certificatesigningrequest.certificates.k8s.io/devops22 approved

user@host:~$ kubectl get csr
NAME       AGE   SIGNERNAME                            REQUESTOR   REQUESTEDDURATION   CONDITION
devops22   61s   kubernetes.io/kube-apiserver-client   admin       10d                 Approved,Issued

user@host:~$ kubectl get csr devops22 -o jsonpath='{.status.certificate}'| base64 -d > devops22.crt

user@host:~$ ls -l devops22*
-rw-r--r-- 1 user user 1094 июл 23 16:09 devops22.crt
-rw-r--r-- 1 user user  891 июл 23 15:52 devops22.csr
-rw------- 1 user user 1679 июл 23 15:51 devops22.key

user@host:~$ kubectl create ns devops22
namespace/devops22 created

user@host:~$ kubectl apply -f Netology/DEVOPS-22/devops-netology/12-kuber/9-kuber_rbac/task1.yml 
role.rbac.authorization.k8s.io/devops22 created
rolebinding.rbac.authorization.k8s.io/devops22 created

user@host:~$ kubectl get roles
NAME       CREATED AT
devops22   2023-07-23T13:19:03Z

user@host:~$ kubectl get rolebindings
NAME       ROLE            AGE
devops22   Role/devops22   19s

user@host:~$ kubectl describe role/devops22
Name:         devops22
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  pods/log   []                 []              [get watch list]
  pods       []                 []              [get watch list]

user@host:~$ kubectl config set-credentials devops22 --client-key=devops22.key --client-certificate=devops22.crt --embed-certs=true
User "devops22" set.

user@host:~$ kubectl config set-context devops22 --cluster=microk8s-cluster --user=devops22
Context "devops22" created.

user@host:~$ kubectl config get-contexts
CURRENT   NAME       CLUSTER            AUTHINFO   NAMESPACE
*         devops22   microk8s-cluster   devops22   
          microk8s   microk8s-cluster   admin      

user@host:~$ kubectl config use-context devops22
Switched to context "devops22".

user@host:~$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://130.193.54.9:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: devops22
  name: devops22
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: devops22
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: REDACTED
- name: devops22
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED

user@host:~$ kubectl auth can-i list pods -n devops22
yes

user@host:~$ kubectl auth can-i list pods/logs -n devops22
yes

user@host:~$ kubectl auth can-i create pods -n devops22
no

user@host:~$ kubectl auth can-i create ingress -n devops22
no

user@host:~$ kubectl auth can-i list ingress -n devops22
no

```
