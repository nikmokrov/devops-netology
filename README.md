# Ответы на задание к занятию "3.4. Операционные системы, лекция 2"
1. 
Скачал готовый бинарник _wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz_ и распаковал его в _/usr/local/bin_

Создал файл /etc/systemd/system/node_exporter.service со следующим содержимым:</br>
[Unit]</br>
Description=Node Exporter</br>
Wants=network-online.target</br>
After=network-online.target</br>
</br>
[Service]</br>
User=node_exporter</br>
Group=node_exporter</br>
Type=simple</br>
EnvironmentFile=-/etc/default/node_exporter</br>
ExecStart=/usr/local/bin/node_exporter $EXTRA_OPTS</br>
</br>
[Install]</br>
WantedBy=multi-user.target</br>
</br>

_systemctl daemon-reload_ применит новый unit-файл в systemd. 
Служба запустится автоматически после _network-online.target_. Нужно только включить ее командой _systemctl enable node_exporter_.

Опции сервису можно задавать через файл _/etc/default/node_exporter_.</br>
Например, строка в файле</br>
EXTRA_OPTS=--web.listen-address=":9200"</br>
изменит порт, на котором слушает node_exporter, со стандарного 9100 на 9200.</br>

![Pic. 1](/pics/node1.png "pic. 1")
![Pic. 2](/pics/node2.png "pic. 2")

Служба корректно останавливается и запускается:</br>
![Pic. 3](/pics/node3.png "pic. 3")
![Pic. 4](/pics/node4.png "pic. 4")

2. 
![Pic. 5](/pics/node_exporter.png "pic. 5") </br>
Для мониторинга я бы выбрал следующие метрики:</br>
**CPU**</br>
node_load1 - средняя загрузка системы</br>
node_load5</br>
node_load15</br>
**RAM**</br>
node_memory_MemTotal_bytes - объем памяти</br>
node_memory_MemFree_bytes - свободная память</br>
node_memory_SwapTotal_bytes - объем свопа</br>
node_memory_SwapFree_bytes - свободный своп</br>
node_memory_Buffers_bytes - буферы</br>
node_memory_Cached_bytes - кэш</br>
**Disk**</br>
node_filesystem_size_bytes - размер файловой системы в байтах</br>
node_filesystem_free_bytes - свободное место на файловой системе в байтах</br>
node_disk_io_now - текущее количество IO операций</br>
**Network**</br>
node_network_receive_bytes_total - байт принято</br>
node_network_receive_drop_total - количество дропов при получении</br>
node_network_receive_errs_total - количество ошибок при получении</br>
node_network_transmit_bytes_total - байт передано</br>
node_network_transmit_errs_total - количество дропов при передаче</br>
node_network_transmit_drop_total - количество ошибок при передаче</br>


3. ![Pic. 6](/pics/netdata.png "pic. 6") </br>

4. Можно, если гипервизор позволяет.</br>
dmesg виртуалки выводит следующее:</br>
_[    0.000000] Hypervisor detected: KVM</br>
[    0.057878] Booting paravirtualized kernel on KVM_</br>

Linux прямо сообщает, что обнаружен гипервизор KVM и загружается паравиртуализованное ядро.</br>

В приниципе, гипервизор может скрыть от ВМ, что она запущена под его управлением и ВМ будет думать, что она запущена на bare metal, хотя современные популярные гипервизоры (KVM, Xen, Vmware, Hyper-V) так не делают.

5. Команда </br>
_sysctl -a | grep nr_open_</br>
показывает</br>
_fs.nr_open = 1048576_</br>
_fs.nr_open_ задает максимальное количество файловых дескрипторов, доступных для процесса (https://www.kernel.org/doc/Documentation/sysctl/fs.txt).</br>
Это "hard" лимит, его может изменить только root.</br>
Другое ограничение - это "soft" лимит (ulimit -Sn), ограничение на количество файловых дескрипторов по-умолчанию для всех процессов, на ВМ Ubuntu 20.04 оно равно 1024. Это ограничение пользователь или процесс может изменять вплоть до "hard" лимита в пределах своей сессии.</br>

6.  ![Pic. 7](/pics/ns1.png "pic. 7") </br>
![Pic. 8](/pics/ns2.png "pic. 8") </br>

7.  _:(){ :|:& };:_ - это т.н. fork-бомба для bash. Создает бесконечное количество процессов, используя вызов fork().</br>
Работает таким образом:</br>
_:()_ - это определение функции без аргументов с именем ":"</br>
_{ :|:& }_ - в теле функции происходит рекурсивный вызов ее самой и перенаправление ее вывода через пайп на вход еще одного вызова ее же. & отправляет на исполнение в фоновом режиме, так что потомки не могут завершиться и начинают
расходовать системные ресурсы.</br>
_;:_ - завершает определение функции и запускает ее на исполнение.</br>

После запуска бомбы и стабилизации системы dmesg сообщает:</br>
_[   82.867964] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope_</br>

Сработал механизм cgroup (control group или контрольная группа). cgroup - группа процессов в Linux, для которой механизмами ядра наложена изоляция и установлены ограничения на вычислительные ресурсы (процессорные, сетевые, ресурсы памяти, ресурсы ввода-вывода).
cgroup ограничил количество вызовов fork() и, достигнув предела, в определенный момент бомба не смогла создать новый процесс и функция ":" рекурсивно завершилась.   

По умолчанию, systemd устанавливает ограничение на количество процессов пользователя в 33% от sysctl kernel.threads-max. Ограничение задается в параметре TasksMax в файле /usr/lib/systemd/system/user-.slice.d/10-defaults.conf
