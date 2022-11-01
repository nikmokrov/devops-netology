### Задача 1
1. Опишите своими словами основные преимущества применения на практике IaaC паттернов.

- более быстрый выход на рынок, уменьшение показателя TTM (Time to Market), обеспечивающий конкурентное 
преимущество, благодаря применению систем управления конфигурациями (Ansible, 
Puppet, Chef). Системы управления конфигурациями значительно ускоряют подготовку и развертывание
тестовых и продуктовых сред, что значительно ускоряет разработку продукта в целом.
- стабильность результата благодаря реализации принципа идемпотентности
- повышение производительности труда специалистов DevOps, благодаря системам управления конфигурациями
они могут создавать гораздо более масштабные инфраструктуры
- автоматическое документирование и версионирование инфраструктуры и уменьшение количества ошибок 
конфигурации (уменьшение дрейфа), т.к. появляется возможности проверки конфигурации на стандарты качества,
а также тестирование конфигураций
- более быстрое восстановление инфраструктуры после сбоев благодаря значительному сокращению доли
ручного труда, автоматизация процесса восстановления

2. Какой из принципов IaaC является основополагающим?</br>
Принцип идемпотентности - гарантирует стабильный предсказуемый результат, не зависящий от количества
повторений (развертываний) конфигураций инфраструктуры.


### Задача 2
1. Чем Ansible выгодно отличается от других систем управления конфигурациями?
- Отсутствие необходимости установки агента на управляемые хосты
- Низкий порог входа благодаря использованию Python и YAML
- Поддержка как push, так и pull режимов развертывания конфигурации
- Широкий набор модулей на все случаи жизни
- Легко написать свой модуль в случае необходимости
- Подробная, регулярно обновляющаяся документация
- Поддержка RedHat, крупнейшей компании, разрабатывающей open source ПО

2. Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?</br>
Я считаю в целом более надежным метод push, т.к. он позволяет в любой момент убедиться в том, 
что конфигурации применены правильно, на нужных хостах и именно те, что нужны. Для этого достаточно
сделать очередной прогон, если условия позволяют, конечно. 
При pull методе же необходимо анализировать отчеты хостов о примененных конфигурациях и смотреть
в систему мониторинга. 
Однако у pull метода есть очень важная и полезная особенность. В случае применения неправильной
конфигурации, например, плохо настроенного файервола или указание ошибочного пароля, мы можем 
потерять связь с хостом. В этом случае push метод не позволит исправить ситуацию, а pull позволит -
достаточно исправить конфигурацию и хост через некоторое время заберет ее и применит.
Так что наиболее надежным будет все же грамотное сочетание методов.


### Задача 3
```console
user@host:~$ VBoxManage --version
6.1.40r154048
user@host:~$ vagrant --version
Vagrant 2.2.14
user@host:~$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110]
```

### Задача 4
```console
user@host:~/DEVOPS-22/Homeworks/05-virt/vagrant$ vagrant status
Current machine states:

server1.netology          not created (virtualbox)

The environment has not yet been created. Run `vagrant up` to
create the environment. If a machine is not created, only the
default provider will be shown. So if a provider is not listed,
then the machine is not created for that environment.
user@host:~/DEVOPS-22/Homeworks/05-virt/vagrant$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202206.03.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/user/DEVOPS-22/Homeworks/05-virt/vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

user@host:~/DEVOPS-22/Homeworks/05-virt/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue 01 Nov 2022 11:52:17 AM UTC

  System load:  0.91               Users logged in:          0
  Usage of /:   13.1% of 30.63GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 23%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    149


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Nov  1 11:52:11 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker --version
Docker version 20.10.21, build baeda1f
```