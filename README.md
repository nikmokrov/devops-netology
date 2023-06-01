# Домашнее задание к занятию «Микросервисы: принципы»

## Задача 1: API Gateway
|  | Kong | Tyk | Express Gateway | Apache APISIX | Azure API Management |
|--|------|-----|-----------------|---------------|----------------------|
| **Размещение** | Собств. инфр-а/Облако | Собств. инфр-а/Облако | Собств. инфр-а | Собств. инфр-а/Облако | Собств. инфр-а(Docker)/Облако |
| **Open Source** | Да | Да | Да | Да | Нет |
| **Технология** | Nginx, Lua | GoLang | Node.js,Express | Nginx, Lua | - |
| **Сообщество** | Большое | Среднее | Маленькое | Маленькое | Большое |
| **Конфигурация** | YAML | JSON | YAML/JSON | YAML | WebAPI/PowerShell |
| **Безопасность (аутентификация и авторизация)** | Да | Да | Да | Да | Да |
| **HTTPS** | Да | Да | Да | Да | Да |
| **Стоимость** | Бесплатно/Подписка | Бесплатно/Подписка | Бесплатно | Бесплатно | Подписка |

Я бы выбрал в качестве API Gateway Kong. Это очень популярное open-source решение, основанное на Nginx и позволяющее расширять функционал с помощью языка Lua.
Широкая поддержка сообществом, множество готовых Lua-скриптов для разных задач. Имеется возможность установки как на собственной инфраструктуре, так и в облаке.
Полностью совместимая с Kubernetes архитектура. Благодаря основе в виде Nginx обеспечивается высокая производительность, балансировка, proxy-кеширование. Поддерживается большинство популярных протоколов: REST, GraphQL, gRPC. Все возможности для автоматизации в соответствии с принципами DevOps и GitOps.</br>

Kong полностью соответствует требованиям задания:
- может маршрутизировать запросы к нужному сервису на основе конфигурации (Nginx в основе)
- возможность проверки аутентификации (Key Authentication, OAuth 2.0, LDAP, OpenID)
- обеспечивает терминацию HTTPS
</br>
</br>

## Задача 2: Брокер сообщений
|  | Kafka | RabbitMQ | Memphis | Redis |
|--|-------|----------|---------|-------|
| **Open Source** | Да (Apache 2.0) | Да (Mozilla Public) | Да (BSL 1.0) | Да (BSD) |
| **Метод доставки** | Pull | Push | Pull | Pull/Push |
| **Кластеризация** | Да | Да | Да | Да | 
| **Хранение на диске** | Да (Log) | Да (Index) | Да (Log) | Нет(In-memory) |
| **Скорость (1 queue)** | 280K msg/sec | 50K msg/sec | 300K msg/sec | 1000K msg/sec |
| **Форматы сообщений** | Да | Да | Да | Да |
| **Разделение прав** | Да | Да | Нет | Нет |
| **Простота эксплуатации** | Выше средней | Средняя | Простая | Простая |

Apache Kafka хорошо подойдет в качестве брокера сообщений. Это популярный выбор для обеспечения потоковой передачи данных без сложной маршрутизации, но с максимальной пропускной способностью. Эту систему выбирают, когда важны масштабируемость и доставка сообщений в правильном порядке.
Kafka удовлетворяет следующим условиям:
- поддерживает кластеризацию благодаря встроенной службе координации ZooKeeper 
- хранит сообщения на диске в процессе доставки, в отличие от Redis
- обеспечивает высокую скорость работы, сравнимую с Memphis, и гораздо выше RabbitMQ
- может передавать сообщения практически любых форматов через сериализацию данных (сами сообщения передаются в бинарном виде)
- поддерживает разделение прав доступа через механизм Role-Based Access Control (RBAC)
- Kafka является не самым простым в настройке и эксплуатации по отношению к остальным выбранным для сравнения брокером, однако по совокупности характеристик лучше удовлетворяет прочим условиям задания
</br>
</br>

## Задача 3: API Gateway * (необязательная)

[docker-compose.yaml](11-microservices/02-principles/docker-compose.yaml)</br>
[nginx.conf](11-microservices/02-principles/gateway/nginx.conf)</br>

```console
user@host:~/Netology/DEVOPS-22/devops-netology/11-microservices/02-principles$ docker-compose up -d --build
Creating network "02-principles_default" with the default driver
Building uploader
Step 1/6 : FROM node:alpine
 ---> 8e7579c71aa8
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 796675f0b5d5
Step 3/6 : COPY package*.json ./
 ---> Using cache
 ---> 4eb5257fd3a5
Step 4/6 : RUN npm install
 ---> Using cache
 ---> 21c1e57e2628
Step 5/6 : COPY src ./
 ---> Using cache
 ---> f193d933f395
Step 6/6 : CMD ["node", "server.js"]
 ---> Using cache
 ---> 5a2d367a008b
Successfully built 5a2d367a008b
Successfully tagged 02-principles_uploader:latest
Building security
Step 1/6 : FROM python:3.9-alpine
 ---> 1353482c9f85
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 8f6f5b709865
Step 3/6 : COPY requirements.txt .
 ---> Using cache
 ---> bcecb4864fa9
Step 4/6 : RUN pip install -r requirements.txt
 ---> Using cache
 ---> 6f80050c10c3
Step 5/6 : COPY src ./
 ---> Using cache
 ---> eb96c0a0d036
Step 6/6 : CMD [ "python", "./server.py" ]
 ---> Using cache
 ---> a8da058a017b
Successfully built a8da058a017b
Successfully tagged 02-principles_security:latest
Creating 02-principles_security_1 ... done
Creating 02-principles_storage_1  ... done
Creating 02-principles_createbuckets_1 ... done
Creating 02-principles_uploader_1      ... done
Creating 02-principles_gateway_1       ... done

user@host:~/Netology/DEVOPS-22/devops-netology/11-microservices/02-principles$ docker ps
CONTAINER ID   IMAGE                    COMMAND                  CREATED         STATUS                   PORTS                                           NAMES
bbd556527a7c   nginx:alpine             "/docker-entrypoint.…"   5 minutes ago   Up 5 minutes             80/tcp, 0.0.0.0:80->8080/tcp, :::80->8080/tcp   02-principles_gateway_1
312541c6bd7b   02-principles_uploader   "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes             3000/tcp                                        02-principles_uploader_1
f52cc80d069f   minio/minio:latest       "/usr/bin/docker-ent…"   5 minutes ago   Up 5 minutes (healthy)   9000/tcp                                        02-principles_storage_1
2c3f3cad4292   02-principles_security   "python ./server.py"     5 minutes ago   Up 5 minutes             3000/tcp                                        02-principles_security_1

user@host:~/Netology/DEVOPS-22/devops-netology/11-microservices/02-principles$ curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/v1/token

eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I

user@host:~/Netology/DEVOPS-22/devops-netology/11-microservices/02-principles$ curl -X GET -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' http://localhost/v1/token/validation

{"sub":"bob"}

user@host:~/Netology/DEVOPS-22/devops-netology/11-microservices/02-principles$ curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @uptime-501.jpg http://localhost/v1/upload

{"filename":"5334101e-4534-4460-9004-1abee1b29edd.jpg"}

user@host:~/Netology/DEVOPS-22/devops-netology/11-microservices/02-principles$ curl -X GET http://localhost/image/5334101e-4534-4460-9004-1abee1b29edd.jpg > 5334101e-4534-4460-9004-1abee1b29edd.jpg
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 32000  100 32000    0     0  3906k      0 --:--:-- --:--:-- --:--:-- 3906k

```