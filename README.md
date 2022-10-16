### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Синтаксические ошибки:
 - отсутствует запятая между словарями списка "elements"
 - отсутствует закрывающая двойная кавычка у ключа "ip" во втором словаре списка "elements"
 - ip адрес в значении того же ключа "ip" не является стандартным типом данных python, его следует привести к типу str (заключить в двойные кавычки) и обрабатывать отдельно

Смысловые ошибки:
 - следует убрать символ табуляции "\t" из значения ключа "info", не нужно хранить символы форматирования в самих данных, т.к. форматирование вывода - это отдельная задача
 - значение по ключу "ip" в первом словаре списка "elements" фактически является не ip адресом, а числом

Правильная выгрузка может выглядеть следующим образом:
```
    { "info" : "Sample JSON output from our service",
         "elements" :[
            { "name" : "first",
              "type" : "server",
              "ip" : "7.1.7.5"
            },
            { "name" : "second",
              "type" : "proxy",
              "ip" : "71.78.22.43"
            }
        ]
    }

```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import json
import yaml
from time import sleep

serv_list = ['drive.google.com', 'mail.google.com', 'google.com']
ip_list = [socket.gethostbyname(serv) for serv in serv_list]
serv_dict = dict(zip(serv_list, ip_list))
while True:
    with open('serv_log.json', 'w') as json_log, open('serv_log.yaml', 'w') as yaml_log:
        for serv, old_ip in serv_dict.items():
            new_ip = socket.gethostbyname(serv)
            if new_ip != old_ip:
                print(f'ERROR {serv} IP mismatch: {old_ip} {new_ip}')
                serv_dict[serv] = new_ip
            print(f'{serv}-{serv_dict[serv]}')
            json.dump({serv: serv_dict[serv]}, json_log)
            json_log.write('\n')
            yaml.dump([{serv: serv_dict[serv]}], yaml_log)
    sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
user@host:~/DEVOPS-22/Homeworks/04-script$ ./task43-2.py 
drive.google.com-108.177.14.194
mail.google.com-216.58.209.165
google.com-216.58.210.174
drive.google.com-108.177.14.194
mail.google.com-216.58.209.165
google.com-216.58.210.174
^CTraceback (most recent call last):
  File "/home/kalyam/DEVOPS-22/Homeworks/04-script/./task43-2.py", line 22, in <module>
    sleep(2)
KeyboardInterrupt
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
user@host:~/DEVOPS-22/Homeworks/04-script$ more serv_log.json 
{"drive.google.com": "108.177.14.194"}
{"mail.google.com": "216.58.209.165"}
{"google.com": "216.58.210.174"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
user@host:~/DEVOPS-22/Homeworks/04-script$ more serv_log.yaml 
- drive.google.com: 108.177.14.194
- mail.google.com: 216.58.209.165
- google.com: 216.58.210.174
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
#!/usr/bin/env python3

import sys
import json
import yaml

if len(sys.argv) < 2:
    sys.exit()

filename = sys.argv[1]
is_json = True
is_yaml = True

with open(filename, 'r') as fp:
    try:
        json_content = json.load(fp)
    except json.JSONDecodeError as exc:
        is_json = False
        json_exc = exc

with open(filename, 'r') as fp:
    try:
        yaml_content = yaml.load(fp, Loader=yaml.UnsafeLoader)
    except yaml.YAMLError as exc:
        is_yaml = False
        yaml_exc = exc

if not is_json and not is_yaml:
    print(f'File {filename} is not json nor yaml file')
    print(f'json exception: {json_exc.pos} - {json_exc.msg}')
    print(f'yaml exception: {yaml_exc}')
    sys.exit()
elif is_json:
    if filename.split('.')[0] + '.yaml' == filename:
        filename = filename.split('.')[0] + '_new.yaml'
    else:
        filename = filename.split('.')[0] + '.yaml'
    with open(filename, 'w') as fp:
        yaml.dump(json_content, fp)
elif is_yaml:
    if filename.split('.')[0] + '.json' == filename:
        filename = filename.split('.')[0] + '_new.json'
    else:
        filename = filename.split('.')[0] + '.json'
    with open(filename, 'w') as fp:
        json.dump(yaml_content, fp)
```

### Пример работы скрипта:
```
user@host:~/DEVOPS-22/Homeworks/04-script$ more files.txt 
cant-help-myself.mp3 7 MB
keep-yourself-alive.mp3 6 MB
bones.mp3 5 MB
crying-all-the-time.mp3 5 MB

user@host:~/DEVOPS-22/Homeworks/04-script$ ./task43-3.py files.txt 
File files.txt is not json nor yaml file
json exception: 0 - Expecting value
yaml exception: expected '<document start>', but found '<scalar>'
  in "files.txt", line 14, column 1

user@host:~/DEVOPS-22/Homeworks/04-script$ more json_serv_log.json 
{"drive.google.com": "108.177.14.194", "mail.google.com": "216.58.209.165", "google.com": "216.58.210.174"}

user@host:~/DEVOPS-22/Homeworks/04-script$ ./task43-3.py json_serv_log.json 

user@host:~/DEVOPS-22/Homeworks/04-script$ more json_serv_log.yaml
drive.google.com: 108.177.14.194
google.com: 216.58.210.174
mail.google.com: 216.58.209.165

user@host:~/DEVOPS-22/Homeworks/04-script$ more yaml_serv_log.yaml
- drive.google.com: 108.177.14.194
- mail.google.com: 216.58.209.165
- google.com: 216.58.210.174

user@host:~/DEVOPS-22/Homeworks/04-script$ ./task43-3.py yaml_serv_log.yaml 

user@host:~/DEVOPS-22/Homeworks/04-script$ more yaml_serv_log.json 
[{"drive.google.com": "108.177.14.194"}, {"mail.google.com": "216.58.209.165"}, {"google.com": "216.58.210.174"}]

```
