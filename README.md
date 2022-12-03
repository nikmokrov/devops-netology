# Домашнее задание к занятию "6.4. PostgreSQL"
## Задача 1
[docker-compose.yaml](06-db/docker-compose.yaml)

```console
user@host:~$ docker-compose exec postgres psql -U postgres
postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres-# \c postgres
You are now connected to database "postgres" as user "postgres".

postgres-# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
...

postgres-# \dS pg_aggregate
               Table "pg_catalog.pg_aggregate"
      Column      |   Type   | Collation | Nullable | Default 
------------------+----------+-----------+----------+---------
 aggfnoid         | regproc  |           | not null | 
 aggkind          | "char"   |           | not null | 
 aggnumdirectargs | smallint |           | not null | 
 aggtransfn       | regproc  |           | not null | 
 aggfinalfn       | regproc  |           | not null | 
 aggcombinefn     | regproc  |           | not null | 
 aggserialfn      | regproc  |           | not null | 
 aggdeserialfn    | regproc  |           | not null | 
 aggmtransfn      | regproc  |           | not null | 
 aggminvtransfn   | regproc  |           | not null | 
 aggmfinalfn      | regproc  |           | not null | 
 aggfinalextra    | boolean  |           | not null | 
 aggmfinalextra   | boolean  |           | not null | 
 aggfinalmodify   | "char"   |           | not null | 
 aggmfinalmodify  | "char"   |           | not null | 
 aggsortop        | oid      |           | not null | 
 aggtranstype     | oid      |           | not null | 
 aggtransspace    | integer  |           | not null | 
 aggmtranstype    | oid      |           | not null | 
 aggmtransspace   | integer  |           | not null | 
 agginitval       | text     | C         |          | 
 aggminitval      | text     | C         |          | 
Indexes:
    "pg_aggregate_fnoid_index" UNIQUE, btree (aggfnoid)


postgres-# \q

```
  
## Задача 2
```console
user@host:~$ docker-compose exec postgres psql -U postgres -c 'CREATE DATABASE test_database;'
CREATE DATABASE
user@host:~$ docker-compose exec postgres bash -c 'psql -U postgres -d test_database < /data/backup/pg_test_dump.sql'
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

user@host:~$ docker-compose exec postgres psql -U postgres
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner   
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE orders;
ANALYZE

test_database=# select tablename, attname, avg_width from pg_stats where tablename='orders' and avg_width=(select max(avg_width) from pg_stats where tablename='orders');
 tablename | attname | avg_width 
-----------+---------+-----------
 orders    | title   |        16
(1 row)

```

## Задача 3

Преобразуем таблицу **orders** в секционированную:
```console
test_database=# BEGIN;
CREATE TABLE new_orders(LIKE orders) PARTITION BY RANGE(price);
CREATE TABLE orders_1 PARTITION OF new_orders FOR VALUES FROM (500) TO (MAXVALUE); 
CREATE TABLE orders_2 PARTITION OF new_orders FOR VALUES FROM (MINVALUE) TO (500); 
INSERT INTO new_orders SELECT * FROM orders;
DROP TABLE orders;
ALTER TABLE new_orders RENAME TO orders;
COMMIT;
BEGIN
CREATE TABLE
CREATE TABLE
CREATE TABLE
INSERT 0 8
DROP TABLE
ALTER TABLE
COMMIT
test_database=# \d
                List of relations
 Schema |   Name   |       Type        |  Owner   
--------+----------+-------------------+----------
 public | orders   | partitioned table | postgres
 public | orders_1 | table             | postgres
 public | orders_2 | table             | postgres
(3 rows)

test_database=# select * from orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# select * from orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# select * from orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?</br>
Да, если изначально создать orders как секционированную таблицу.
```console
test_database=# BEGIN;
CREATE TABLE orders(id int, title varchar(80), price int) PARTITION BY RANGE(price);
CREATE TABLE orders_1 PARTITION OF orders FOR VALUES FROM (500) TO (MAXVALUE); 
CREATE TABLE orders_2 PARTITION OF orders FOR VALUES FROM (MINVALUE) TO (500); 
COMMIT;
```

## Задача 4
В секционированных таблицах можно создать ограничение уникальности только если в ограничение входят все столбцы 
ключа секционирования. Поэтому создать ограничение уникальности только на столбец **title** для 
секционированной таблицы **orders** не получится, нужно включать в него ключ разбиения, т.е. столбец
**price**. Таким образом в файл дампа нужно вставить строку
```console
ALTER TABLE orders ADD UNIQUE (title, price);
```
после CREATE TABLE public.orders().</br>
Уникальным будет сочетание записей (title, price).

Можно задать ограничение уникальности на каждую таблицу-секцию:
```console
ALTER TABLE orders_1 ADD UNIQUE (title);
ALTER TABLE orders_2 ADD UNIQUE (title);
```
Это гарантирует уникальность записей в **title**, но только в пределах своей секции.