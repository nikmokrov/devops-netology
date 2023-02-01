# Домашнее задание к занятию "2. Работа с Playbook"
## Основная часть

1.
Я создаю в Yandex Cloud 2 ноды с помощью Terraform [main.tf](./08-ansible/02-playbook/terraform/main.tf)</br>
Terraform формирует inventory файл prod.ini, который и используется для работы с нодами.

5.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/02-playbook/playbook$ ansible-lint site.yml 
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/02-playbook/playbook$ 
```

6.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/02-playbook/playbook$ ansible-playbook -i inventory/prod.ini site.yml --check

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud] => (item=clickhouse-client)
changed: [clickhouse.nikmokrov.cloud] => (item=clickhouse-server)
failed: [clickhouse.nikmokrov.cloud] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}                                                                                                                                                                  

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************
fatal: [clickhouse.nikmokrov.cloud]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}                                                                                                                       

PLAY RECAP **********************************************************************************************************************************************************************************
clickhouse.nikmokrov.cloud : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```

В режиме _--check_ play остановился на установке пакета, т.к. пакеты не были фактически скачаны и еще отсутствуют.

7.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/02-playbook/playbook$ ansible-playbook -i inventory/prod.ini site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud] => (item=clickhouse-client)
changed: [clickhouse.nikmokrov.cloud] => (item=clickhouse-server)
failed: [clickhouse.nikmokrov.cloud] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}                                                                                                                                                                  

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Fire up clickhouse service] ***********************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Create database] **********************************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

RUNNING HANDLER [Start clickhouse service] **************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

PLAY [Install Vector] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Get vector distrib] *******************************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [Extract vector archive] ***************************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [Copy vector files to vector_path] *****************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [Create vector data dir] ***************************************************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0777",
     "path": "/var/lib/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector.nikmokrov.cloud]

TASK [Generate vector config file] **********************************************************************************************************************************************************
--- before
+++ after: /home/user/.ansible/tmp/ansible-local-316960owaxe_w/tmpevk614eb/config.j2
@@ -0,0 +1,15 @@
+data_dir: /var/lib/vector
+sources:
+  syslog:
+    type: file
+    include:
+      - /var/log/syslog
+    ignore_older: 86400
+sinks:
+  clickhouse:
+    inputs:
+      - syslog
+    type: clickhouse
+    database: "logs"
+    table: "syslog"
+    endpoint: "http://84.201.136.48:8123"

changed: [vector.nikmokrov.cloud]

TASK [Start vector service] *****************************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

RUNNING HANDLER [Restart vector service] ****************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

PLAY RECAP **********************************************************************************************************************************************************************************
clickhouse.nikmokrov.cloud : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector.nikmokrov.cloud     : ok=8    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

8.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/02-playbook/playbook$ ansible-playbook -i inventory/prod.ini site.yml --diff --skip-tags "Run vector"

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud] => (item=clickhouse-client)
ok: [clickhouse.nikmokrov.cloud] => (item=clickhouse-server)
failed: [clickhouse.nikmokrov.cloud] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Fire up clickhouse service] ***********************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Create database] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

PLAY [Install Vector] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Get vector distrib] *******************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Extract vector archive] ***************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Copy vector files to vector_path] *****************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Create vector data dir] ***************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Generate vector config file] **********************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

PLAY RECAP **********************************************************************************************************************************************************************************
clickhouse.nikmokrov.cloud : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector.nikmokrov.cloud     : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Здесь я пропустил задачу "Start vector service", помеченную тэгом "Run vector", т.к. она не является идемпотентеной.

9.
В playbook добавлен play "Install Vector". В нем последовательно выполняются следующие tasks:</br>
- Скачать дистрибутив vector нужной версии - "Get vector distrib"
- Распаковать полученный архив - "Extract vector archive"
- Скопировать файлы из архива в путь установки vector - "Copy vector files to vector_path"
- Создать директорию для данных - "Create vector data dir" (используется в файле конфигурации vector)
- Сгенерировать на основе шаблона файл конфигурации - "Generate vector config file"
- Запустить vector в фоновом режиме - "Start vector service"

Имеется также handler "Restart vector service", который отправляет сигнал процессу vector. Этот сигнал заставляет 
vector перечитать свой файл конфигурации. Handler вызывается в task "Generate vector config file".</br>
Task "Start vector service" помечен тэгом "Run vector", с помощью которого можно пропустить его 
выполнение, т.к. этот task не является идемпотентеным.</br>

В playbook используются параметры:</br>
- vector_version - требуемая версия vector
- vector_path - путь, куда устанавливается vector
- vector_data_dir - рабочая директория vector