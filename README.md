# Домашнее задание к занятию "6.Создание собственных модулей"
## Основная часть


3.
[my_own_module.py](08-ansible/06-module/my_own_module.py)

4.
```console
(venv) user@host:~/Netology/DEVOPS-22/ansible$ ansible -m my_own_module -a "path=test123*.txt content=test123" localhost
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development.
This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | FAILED! => {
    "changed": false,
    "message": "Path is not valid, forbidden chars",
    "msg": "File was not written.",
    "original_message": "Requested file test123*.txt. Content must be overwritten."
}
(venv) user@host:~/Netology/DEVOPS-22/ansible$ ansible -m my_own_module -a "path=test123.txt content=test123" localhost
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development.
This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | CHANGED => {
    "changed": true,
    "message": "File was written successfully.",
    "original_message": "Requested file test123.txt. Content must be overwritten."
}
(venv) user@host:~/Netology/DEVOPS-22/ansible$ ansible -m my_own_module -a "path=test123.txt content=test123" localhost
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development.
This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | SUCCESS => {
    "changed": false,
    "message": "Content is the same. File was NOT touched.",
    "original_message": "Requested file test123.txt. Content must be overwritten."
}
```

5.
[site.yml](08-ansible/06-module/site.yml)

```console
(venv) user@host:~/Netology/DEVOPS-22/ansible$ ANSIBLE_LIBRARY=./library ansible-playbook library/site.yml  
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development.
This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [My own module] ************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [localhost]

TASK [Execute My own module] ****************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

6.
```console
(venv) user@host:~/Netology/DEVOPS-22/ansible$ ANSIBLE_LIBRARY=./library ansible-playbook library/site.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development.
This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [My own module] ************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [localhost]

TASK [Execute My own module] ****************************************************************************************************************************************************************
ok: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
11.
[site_role.yml](08-ansible/06-module/site_role.yml)</br>

[requirements.yml](08-ansible/06-module/requirements.yml)

15.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/my_own_collection_test$ ansible-galaxy collection install nikmokrov-my_own_collection-1.0.0.tar.gz 
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'nikmokrov.my_own_collection:1.0.0' to '/home/user/.ansible/collections/ansible_collections/nikmokrov/my_own_collection'
nikmokrov.my_own_collection:1.0.0 was installed successfully
```

16.
```console
user@host:~/Облако/Documents/Netology/DEVOPS-22/my_own_collection_test$ ansible-playbook site_role.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [My own module role] *******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [localhost]

TASK [nikmokrov.my_own_collection.my_own_module_role : Run my_own_module] *******************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

17.
[Tag 1.0.0](https://github.com/nikmokrov/my_own_collection/releases/tag/1.0.0)</br>

[nikmokrov-my_own_collection-1.0.0.tar.gz](08-ansible/06-module/nikmokrov-my_own_collection-1.0.0.tar.gz)
