# Домашнее задание к занятию "6.3. MySQL"
## Задача 1
[docker-compose.yaml](06-db/docker-compose.yaml)

```console
mysql> \s
--------------
...
Server version:         8.0.31 MySQL Community Server - GPL


mysql> \u test_db
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

```
  
## Задача 2
```console
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
Query OK, 0 rows affected (0.01 sec)

mysql> select user,plugin,max_questions,password_lifetime,user_attributes from mysql.user where user='test';
+------+-----------------------+---------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| user | plugin                | max_questions | password_lifetime | user_attributes                                                                                                                     |
+------+-----------------------+---------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| test | mysql_native_password |           100 |               180 | {"metadata": {"fname": "James", "lname": "Pretty"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 0}} |
+------+-----------------------+---------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> grant select on test_db.* to test@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> show grants for test@'localhost';
+---------------------------------------------------+
| Grants for test@localhost                         |
+---------------------------------------------------+
| GRANT USAGE ON *.* TO `test`@`localhost`          |
| GRANT SELECT ON `test_db`.* TO `test`@`localhost` |
+---------------------------------------------------+
2 rows in set (0.00 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

```

## Задача 3
```console
mysql> SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_NAME = 'orders';
+--------+
| ENGINE |
+--------+
| InnoDB |
+--------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE MyISAM;
Query OK, 5 rows affected (0.05 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE InnoDB;
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+--------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                    |
+----------+------------+--------------------------------------------------------------------------+
|        1 | 0.00055100 | show engines                                                             |
|        2 | 0.00013800 | show table                                                               |
|        3 | 0.00283025 | show tables                                                              |
|        4 | 0.00257000 | SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_NAME = 'orders' |
|        5 | 0.00410150 | SELECT ENGINE FROM information_schema.TABLES                             |
|        6 | 0.01248100 | SELECT * FROM information_schema.TABLES WHERE TABLE_NAME = 'orders'      |
|        7 | 0.00478325 | SELECT table_name FROM information_schema.TABLES                         |
|        8 | 0.00221450 | SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_NAME = 'orders' |
|        9 | 0.05471950 | ALTER TABLE orders ENGINE MyISAM                                         |
|       10 | 0.08581425 | ALTER TABLE orders ENGINE InnoDB                                         |
+----------+------------+--------------------------------------------------------------------------+
10 rows in set, 1 warning (0.01 sec)


```

## Задача 4
```console
[mysqld]
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 10G  # 32G RAM
innodb_log_file_size = 100M
```
