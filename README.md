# Домашнее задание к занятию "6.2. SQL"
## Задача 1
[docker-compose.yaml](06-db/docker-compose.yaml)

```console
user@host:~$ docker-compose up -d
```
  
## Задача 2
```console
user@host:~$ docker-compose exec postgres01 psql -U postgres
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

postgres=#

postgres=# create user "test-admin-user" with password 'admin';
CREATE ROLE
postgres=# create database test_db;
CREATE DATABASE
test_db=# create table orders(id serial primary key, product varchar(255), price int);
CREATE TABLE
test_db=# create table clients(id serial primary key, full_name varchar(255), country varchar(255), order_id int REFERENCES orders(id));
CREATE TABLE
test_db=# grant all on all tables in schema public to "test-admin-user";
GRANT
test_db=# create user "test-simple-user" with password 'simple';
CREATE ROLE
test_db=# grant select, insert, update, delete on all tables in schema public to "test-simple-user";
GRANT


test_db=# SELECT datname FROM pg_database;
  datname  
-----------
 postgres
 test_db
 template1
 template0
(4 rows)

test_db=# select table_name, column_name, data_type from information_schema.columns where table_name='orders';
 table_name | column_name |     data_type     
------------+-------------+-------------------
 orders     | id          | integer
 orders     | product     | character varying
 orders     | price       | integer
(3 rows)

test_db=# select table_name, column_name, data_type from information_schema.columns where table_name='clients';
 table_name | column_name |     data_type     
------------+-------------+-------------------
 clients    | id          | integer
 clients    | full_name   | character varying
 clients    | country     | character varying
 clients    | order_id    | integer
(4 rows)

test_db=# select * from information_schema.role_table_grants where grantee='test-admin-user' or grantee='test-simple-user';
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
(22 rows)
```

## Задача 3
```console
test_db=# insert into orders (product,price) values ('Шоколад', 10);
INSERT 0 1
test_db=# insert into orders (product,price) values ('Принтер', 3000);     
INSERT 0 1
test_db=# insert into orders (product,price) values ('Книга', 500);
INSERT 0 1
test_db=# insert into orders (product,price) values ('Монитор', 7000);
INSERT 0 1
test_db=# insert into orders (product,price) values ('Гитара', 4000);
INSERT 0 1
test_db=# insert into clients (full_name,country) values ('Иванов Иван Иванович', 'США');
INSERT 0 1
test_db=# insert into clients (full_name,country) values ('Петров Петр Петрович', 'Canada');
INSERT 0 1
test_db=# insert into clients (full_name,country) values ('Иоганн Себастьян Бах', 'Japan');
INSERT 0 1
test_db=# insert into clients (full_name,country) values ('Ронни Джеймс Дио', 'Russia');
INSERT 0 1
test_db=# insert into clients (full_name,country) values ('Ritchie Blackmore', 'Russia');
INSERT 0 1
test_db=# select * from orders;
 id | product | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_db=# select * from clients;
 id |      full_name       | country | order_id 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |         
  2 | Петров Петр Петрович | Canada  |         
  3 | Иоганн Себастьян Бах | Japan   |         
  4 | Ронни Джеймс Дио     | Russia  |         
  5 | Ritchie Blackmore    | Russia  |         
(5 rows)

test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)

test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)

```
## Задача 4
```console
test_db=# update clients set order_id=(select id from orders where orders.product='Книга') where clients.full_name='Иванов Иван Иванович';
UPDATE 1
test_db=# update clients set order_id=(select id from orders where orders.product='Монитор') where clients.full_name='Петров Петр Петрович';
UPDATE 1
test_db=# update clients set order_id=(select id from orders where orders.product='Гитара') where clients.full_name='Иоганн Себастьян Бах';
UPDATE 1

test_db=# select full_name from clients where order_id is not null;
      full_name       
----------------------
 Иванов Иван Иванович
 Петров Петр Петрович
 Иоганн Себастьян Бах
(3 rows)

```
## Задача 5
```console
test_db=# explain select full_name from clients where order_id is not null;
                       QUERY PLAN                       
--------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.05 rows=3 width=33)
   Filter: (order_id IS NOT NULL)
(2 rows)
```
EXPLAIN выводит информацию, показывающую, что делает Postgres при выполнении запроса.
В нашем случае сообщается, что используется Seq Scan — последовательное, блок за блоком, 
чтение данных таблицы clients. cost показывает условную стоимость исполнения: 0.00 — затраты на получение первой строки;
1.05 — затраты на получение всех строк. rows — приблизительное количество возвращаемых строк при выполнении 
операции. width — средний размер одной строки в байтах. Filter показывает условие WHERE.


## Задача 6
```console
user@host:~$ docker-compose exec postgres01 bash -c 'pg_dump -U postgres test_db > /data/backup/test_db.sql'
user@host:~$ docker-compose exec postgres01 bash -c 'pg_dumpall -r -U postgres > /data/backup/roles.sql'
user@host:~$ docker-compose exec postgres02 bash -c 'psql -U postgres < /data/backup/roles.sql'              
user@host:~$ docker-compose exec postgres02 bash -c "psql -U postgres -c 'CREATE DATABASE test_db;'"
user@host:~$ docker-compose exec postgres02 bash -c 'psql -d test_db -U postgres < /data/backup/test_db.sql'
user@host:~$ docker-compose exec postgres02 psql -d test_db -U postgres
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

test_db=# select * from clients;
 id |      full_name       | country | order_id 
----+----------------------+---------+----------
  4 | Ронни Джеймс Дио     | Russia  |         
  5 | Ritchie Blackmore    | Russia  |         
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(5 rows)

test_db=# select * from orders;
 id | product | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

```