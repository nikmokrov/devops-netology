# Домашнее задание к занятию "4. Работа с roles"
## Основная часть

1.
[requirements.yml](./08-ansible/04-role/playbook/requirements.yml)

2.
```console
user@host:~/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook$ ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
```

3.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22$ ansible-galaxy role init vector-role
- Role vector-role was created successfully
user@host:~/Облако/Documents/Netology/DEVOPS-22$ ansible-galaxy role init lighthouse-role        
- Role lighthouse-role was created successfully
```

8.
[requirements.yml](./08-ansible/04-role/playbook/requirements.yml)
```console
user@host:~/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook$ ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- clickhouse (1.11.0) is already installed, skipping.
- extracting vector to /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/vector
- vector (1.0.1) was installed successfully
- extracting lighthouse to /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/lighthouse
- lighthouse (1.0.0) was installed successfully
```

9.
[site.yml](./08-ansible/04-role/playbook/site.yml)
```console
user@host:~/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook$ ansible-playbook -i ../../03-yandex/playbook/inventory/prod.ini site.yml 

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Include OS Family Specific Variables] ************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
included: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse/tasks/precheck.yml for clickhouse.nikmokrov.cloud

TASK [clickhouse : Requirements check | Checking sse4_2 support] ****************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Requirements check | Not supported distribution && release] **************************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
included: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse/tasks/params.yml for clickhouse.nikmokrov.cloud

TASK [clickhouse : Set clickhouse_service_enable] *******************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Set clickhouse_service_ensure] *******************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
included: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse/tasks/install/yum.yml for clickhouse.nikmokrov.cloud

TASK [clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ****************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] ***********************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***********************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version 22.2.2.1)] *************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
included: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse/tasks/configure/sys.yml for clickhouse.nikmokrov.cloud

TASK [clickhouse : Check clickhouse config, data and logs] **********************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud] => (item=/var/log/clickhouse-server)
changed: [clickhouse.nikmokrov.cloud] => (item=/etc/clickhouse-server)
changed: [clickhouse.nikmokrov.cloud] => (item=/var/lib/clickhouse/tmp/)
changed: [clickhouse.nikmokrov.cloud] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] *****************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Create users.d folder] ******************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Generate system config] *****************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Generate users config] ******************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Generate remote_servers config] *********************************************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Generate macros config] *****************************************************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Generate zookeeper servers config] ******************************************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] **************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

RUNNING HANDLER [clickhouse : Restart Clickhouse Service] ***********************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
included: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse/tasks/service.yml for clickhouse.nikmokrov.cloud

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] **************************************************************************************************
changed: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] ******************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
included: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse/tasks/configure/db.yml for clickhouse.nikmokrov.cloud

TASK [clickhouse : Set ClickHose Connection String] *****************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Gather list of existing databases] ***************************************************************************************************************************************
ok: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : Config | Delete database config] *****************************************************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud] => (item={'name': 'logs'}) 

TASK [clickhouse : Config | Create database config] *****************************************************************************************************************************************
changed: [clickhouse.nikmokrov.cloud] => (item={'name': 'logs'})

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
included: /home/user/Облако/Documents/Netology/DEVOPS-22/devops-netology/08-ansible/04-role/playbook/roles/clickhouse/tasks/configure/dict.yml for clickhouse.nikmokrov.cloud

TASK [clickhouse : Config | Generate dictionary config] *************************************************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

TASK [clickhouse : include_tasks] ***********************************************************************************************************************************************************
skipping: [clickhouse.nikmokrov.cloud]

PLAY [Install Vector] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [vector.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [vector : Add vector repo] *************************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [vector : Install vector package] ******************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

TASK [vector : Delete all other possible vector config files] *******************************************************************************************************************************
ok: [vector.nikmokrov.cloud] => (item=vector.yaml)
ok: [vector.nikmokrov.cloud] => (item=vector.json)

TASK [vector : Generate vector config file] *************************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

RUNNING HANDLER [vector : Restart vector service] *******************************************************************************************************************************************
changed: [vector.nikmokrov.cloud]

PLAY [Install Lighthouse] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [lighthouse.nikmokrov.cloud]

TASK [Install some useful packages] *********************************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

TASK [lighthouse : Add EPEL repository] *****************************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

TASK [lighthouse : Install nginx] ***********************************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

TASK [lighthouse : Create lighthouse data dir] **********************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

TASK [lighthouse : Get lighthouse sources] **************************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

TASK [lighthouse : Generate nginx config for lighthouse] ************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

RUNNING HANDLER [lighthouse : Restart nginx service] ****************************************************************************************************************************************
changed: [lighthouse.nikmokrov.cloud]

PLAY RECAP **********************************************************************************************************************************************************************************
clickhouse.nikmokrov.cloud : ok=26   changed=10   unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
lighthouse.nikmokrov.cloud : ok=8    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector.nikmokrov.cloud     : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```