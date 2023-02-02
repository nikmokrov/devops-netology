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



# Домашнее задание к занятию "3. Использование Yandex Cloud"
## Основная часть

1.
Я создаю в Yandex Cloud 3 ноды с помощью Terraform [main.tf](./08-ansible/03-yandex/terraform/main.tf)</br>
Terraform формирует inventory файл prod.ini, который и используется для работы с нодами.

[Playbook site.yml](./08-ansible/03-yandex/playbook/site.yml)

5.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/02-playbook/playbook$ ansible-lint site.yml 
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/02-playbook/playbook$ 
```

6.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/03-yandex/playbook$ ansible-playbook -i inventory/prod.ini site.yml --check

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Add clickhouse repo] ******************************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************
failed: [clickhouse.nikmokrov.cloud] (item=clickhouse-client) => {"ansible_loop_var": "item", "changed": false, "item": "clickhouse-client", "msg": "No package matching 'clickhouse-client-22.12.3.5' found available, installed or updated", "rc": 126, "results": ["No package matching 'clickhouse-client-22.12.3.5' found available, installed or updated"]}                         
failed: [clickhouse.nikmokrov.cloud] (item=clickhouse-server) => {"ansible_loop_var": "item", "changed": false, "item": "clickhouse-server", "msg": "No package matching 'clickhouse-server-22.12.3.5' found available, installed or updated", "rc": 126, "results": ["No package matching 'clickhouse-server-22.12.3.5' found available, installed or updated"]}                         

PLAY RECAP **********************************************************************************************************************************************************************************
clickhouse.nikmokrov.cloud : ok=3    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0 
```

В режиме _--check_ play остановился на установке пакетов clickhouse, т.к. пакеты не могут быть скачаны, 
репозиторий фактически не установлен.

7.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/03-yandex/playbook$ ansible-playbook -i inventory/prod.ini site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Add clickhouse repo] ******************************************************************************************************************************************************************
--- before: /etc/yum.repos.d/clickhouse.repo
+++ after: /etc/yum.repos.d/clickhouse.repo
@@ -0,0 +1,4 @@
+[clickhouse]
+baseurl = https://packages.clickhouse.com/rpm/stable/
+name = Clickhouse repo
+

changed: [clickhouse.nikmokrov.cloud]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud] => (item=clickhouse-client)
changed: [clickhouse.nikmokrov.cloud] => (item=clickhouse-server)

TASK [Generate clickhouse server config] ****************************************************************************************************************************************************
--- before
+++ after: /home/user/.ansible/tmp/ansible-local-32700qrk8jt_m/tmp26emczta/server-config.j2
@@ -0,0 +1 @@
+listen_host: 0.0.0.0

changed: [clickhouse.nikmokrov.cloud]

TASK [Generate clickhouse user config] ******************************************************************************************************************************************************
--- before
+++ after: /home/user/.ansible/tmp/ansible-local-32700qrk8jt_m/tmpmosj9hgv/user-config.j2
@@ -0,0 +1,3 @@
+users:
+  default:
+    password: "J3QQ4-H7H2V"

changed: [clickhouse.nikmokrov.cloud]

RUNNING HANDLER [Restart clickhouse service] ************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [Create database] **********************************************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

PLAY [Install Vector] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [Add vector repo] **********************************************************************************************************************************************************************
--- before: /etc/yum.repos.d/vector.repo
+++ after: /etc/yum.repos.d/vector.repo
@@ -0,0 +1,4 @@
+[vector]
+baseurl = https://repositories.timber.io/public/vector/rpm/any-distro/any-version/x86_64
+name = Vector repo
+

changed: [vector.nikmokrov.cloud]

TASK [Install vector package] ***************************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [Delete all other possible vector config files] ****************************************************************************************************************************************
ok: [vector.nikmokrov.cloud] => (item=vector.yaml)
ok: [vector.nikmokrov.cloud] => (item=vector.json)

TASK [Generate vector config file] **********************************************************************************************************************************************************
--- before: /etc/vector/vector.toml
+++ after: /home/user/.ansible/tmp/ansible-local-32700qrk8jt_m/tmpmec62sqn/vector.j2
@@ -1,44 +1,18 @@
-#                                    __   __  __
-#                                    \ \ / / / /
-#                                     \ V / / /
-#                                      \_/  \/
-#
-#                                    V E C T O R
-#                                   Configuration
-#
-# ------------------------------------------------------------------------------
-# Website: https://vector.dev
-# Docs: https://vector.dev/docs
-# Chat: https://chat.vector.dev
-# ------------------------------------------------------------------------------
+data_dir = "/var/lib/vector"
 
-# Change this to use a non-default directory for Vector data storage:
-# data_dir = "/var/lib/vector"
+[sources.syslog]
+type = "file"
+include = [ "/var/log/syslog" ]
+ignore_older = 86400
 
-# Random Syslog-formatted logs
-[sources.dummy_logs]
-type = "demo_logs"
-format = "syslog"
-interval = 1
+[sinks.clickhouse]
+inputs = [ "syslog" ]
+type = "clickhouse"
+database = "logs"
+table = "syslog"
+endpoint = "http://51.250.96.50:8123"
+auth.strategy = "basic"
+auth.user = "default"
+auth.password = "J3QQ4-H7H2V"
 
-# Parse Syslog logs
-# See the Vector Remap Language reference for more info: https://vrl.dev
-[transforms.parse_logs]
-type = "remap"
-inputs = ["dummy_logs"]
-source = '''
-. = parse_syslog!(string!(.message))
-'''
 
-# Print parsed logs to stdout
-[sinks.print]
-type = "console"
-inputs = ["parse_logs"]
-encoding.codec = "json"
-
-# Vector's GraphQL API (disabled by default)
-# Uncomment to try it out with the `vector top` command or
-# in your browser at http://localhost:8686
-#[api]
-#enabled = true
-#address = "127.0.0.1:8686"

changed: [vector.nikmokrov.cloud]

RUNNING HANDLER [Restart vector service] ****************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

PLAY [Install Lighthouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

TASK [Add EPEL repository] ******************************************************************************************************************************************************************
--- before: /etc/yum.repos.d/epel.repo
+++ after: /etc/yum.repos.d/epel.repo
@@ -0,0 +1,4 @@
+[epel]
+baseurl = https://download.fedoraproject.org/pub/epel/$releasever/$basearch/
+name = EPEL YUM repo
+

changed: [lighthouse.nikmokrov.cloud]

TASK [Install nginx] ************************************************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

TASK [Create lighthouse data dir] ***********************************************************************************************************************************************************
--- before
+++ after
@@ -1,6 +1,6 @@
 {
-    "mode": "0755",
-    "owner": 0,
+    "mode": "0700",
+    "owner": 997,
     "path": "/opt/lighthouse",
-    "state": "absent"
+    "state": "directory"
 }

changed: [lighthouse.nikmokrov.cloud]

TASK [Get lighthouse sources] ***************************************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse.nikmokrov.cloud]

TASK [Generate nginx config for lighthouse] *************************************************************************************************************************************************
--- before: /etc/nginx/nginx.conf
+++ after: /home/user/.ansible/tmp/ansible-local-32700qrk8jt_m/tmpaguwd8s4/nginx.j2
@@ -39,7 +39,7 @@
         listen       80;
         listen       [::]:80;
         server_name  _;
-        root         /usr/share/nginx/html;
+        root         /opt/lighthouse;
 
         # Load configuration files for the default server block.
         include /etc/nginx/default.d/*.conf;

changed: [lighthouse.nikmokrov.cloud]

RUNNING HANDLER [Restart nginx service] *****************************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

PLAY RECAP **********************************************************************************************************************************************************************************
clickhouse.nikmokrov.cloud : ok=8    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
lighthouse.nikmokrov.cloud : ok=8    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector.nikmokrov.cloud     : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0      
```

8.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/03-yandex/playbook$ ansible-playbook -i inventory/prod.ini site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Add clickhouse repo] ******************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud] => (item=clickhouse-client)
ok: [clickhouse.nikmokrov.cloud] => (item=clickhouse-server)

TASK [Generate clickhouse server config] ****************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Generate clickhouse user config] ******************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [Create database] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

PLAY [Install Vector] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Add vector repo] **********************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Install vector package] ***************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Delete all other possible vector config files] ****************************************************************************************************************************************
ok: [vector.nikmokrov.cloud] => (item=vector.yaml)
ok: [vector.nikmokrov.cloud] => (item=vector.json)

TASK [Generate vector config file] **********************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

PLAY [Install Lighthouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Add EPEL repository] ******************************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Install nginx] ************************************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Create lighthouse data dir] ***********************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Get lighthouse sources] ***************************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Generate nginx config for lighthouse] *************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

PLAY RECAP **********************************************************************************************************************************************************************************
clickhouse.nikmokrov.cloud : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
lighthouse.nikmokrov.cloud : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector.nikmokrov.cloud     : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Второй запуск с --diff не показывает task со статусом changed, playbook идемпотентен.

9.
В playbook добавлен play "Install Lighthouse". В нем последовательно выполняются следующие tasks:</br>
- Устанавливаются некоторые полезные пакеты из стандартного репозитория - "Install some useful packages"
- Подключается EPEL репозиторий (нужен для установки nginx) - "Add EPEL repository"
- Устанавливается nginx - "Install nginx"
- Создается директория для статики lighthouse - "Create lighthouse data dir"
- Клонируется git lighthouse с созданную директорию - "Get lighthouse sources"
- Создается файл конфигурации nginx из шаблона - "Generate nginx config for lighthouse"

Nginx запускается при помощи handler "Restart nginx service".</br>

В playbook только 1 параметр [lighthouse_vars](./08-ansible/03-yandex/playbook/group_vars/lighthouse/vars.yml):</br>
- _lighthouse_path_ - путь, куда устанавливается статика lighthouse

В этом playbook я не использовал теги.