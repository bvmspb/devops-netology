# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 sysadmin 06.03 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «6.3. MySQL»

# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```yaml
version: '3'

services:
  mysql:
    image: mysql:8
    ports:
      - 3306:3306
    volumes:
      - ./volume:/var/lib/mysql
      - ./backup:/tmp/backup
    environment:
      - MYSQL_ROOT_PASSWORD=S3cret
      - MYSQL_PASSWORD=mysqlpass
      - MYSQL_USER=mysql_user
      - MYSQL_DATABASE=test_db
```

```answer1.1
Запустил контейнер командой
sudo docker-compose up
Чтобы видеть консольный лог работы сервера, по мере того 
как я буду подключаться к нему из параллельного сеанса.
```
```bash
  ubuntu@vm1-amd-1-1:~/06-db-03-mysql$ sudo docker-compose up
  Creating network "06-db-03-mysql_default" with the default driver
  Creating 06-db-03-mysql_mysql_1 ... done
  Attaching to 06-db-03-mysql_mysql_1
  mysql_1  | 2022-03-08 17:33:30+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.28-1debian10 started.
  mysql_1  | 2022-03-08 17:33:30+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
  mysql_1  | 2022-03-08 17:33:30+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.28-1debian10 started.
  mysql_1  | 2022-03-08 17:33:30+00:00 [Note] [Entrypoint]: Initializing database files
  mysql_1  | 2022-03-08T17:33:30.698574Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.28) initializing of server in progress as process 42
  mysql_1  | 2022-03-08T17:33:30.707064Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
  mysql_1  | 2022-03-08T17:33:32.931469Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
  mysql_1  | 2022-03-08T17:33:37.178744Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
  mysql_1  | 2022-03-08 17:33:45+00:00 [Note] [Entrypoint]: Database files initialized
  mysql_1  | 2022-03-08 17:33:45+00:00 [Note] [Entrypoint]: Starting temporary server
  mysql_1  | 2022-03-08T17:33:46.069068Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.28) starting as process 89
  mysql_1  | 2022-03-08T17:33:46.108389Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
  mysql_1  | 2022-03-08T17:33:47.135728Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
  mysql_1  | 2022-03-08T17:33:47.902872Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
  mysql_1  | 2022-03-08T17:33:47.903059Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
  mysql_1  | 2022-03-08T17:33:47.909158Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different di
  rectory.
  mysql_1  | 2022-03-08T17:33:47.984287Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: /var/run/mysqld/mysqlx.sock
  mysql_1  | 2022-03-08T17:33:47.985342Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.28'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server - GPL.
  mysql_1  | 2022-03-08 17:33:48+00:00 [Note] [Entrypoint]: Temporary server started.
  mysql_1  | Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
  mysql_1  | Warning: Unable to load '/usr/share/zoneinfo/leap-seconds.list' as time zone. Skipping it.
  mysql_1  | Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
  mysql_1  | Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
  mysql_1  | 2022-03-08 17:34:01+00:00 [Note] [Entrypoint]: Creating database test_db
  mysql_1  | 2022-03-08 17:34:01+00:00 [Note] [Entrypoint]: Creating user mysql_user
  mysql_1  | 2022-03-08 17:34:01+00:00 [Note] [Entrypoint]: Giving user mysql_user access to schema test_db
  mysql_1  |
  mysql_1  | 2022-03-08 17:34:01+00:00 [Note] [Entrypoint]: Stopping temporary server
  mysql_1  | 2022-03-08T17:34:01.482498Z 13 [System] [MY-013172] [Server] Received SHUTDOWN from user root. Shutting down mysqld (Version: 8.0.28).
  mysql_1  | 2022-03-08T17:34:04.075346Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.28)  MySQL Community Server - GPL.
  mysql_1  | 2022-03-08 17:34:04+00:00 [Note] [Entrypoint]: Temporary server stopped
  mysql_1  |
  mysql_1  | 2022-03-08 17:34:04+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.
  mysql_1  |
  mysql_1  | 2022-03-08T17:34:04.976350Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.28) starting as process 1
  mysql_1  | 2022-03-08T17:34:05.004353Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
  mysql_1  | 2022-03-08T17:34:06.037622Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
  mysql_1  | 2022-03-08T17:34:06.617962Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
  mysql_1  | 2022-03-08T17:34:06.618020Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
  mysql_1  | 2022-03-08T17:34:06.621938Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different di
  rectory.
  mysql_1  | 2022-03-08T17:34:06.695947Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
  mysql_1  | 2022-03-08T17:34:06.696154Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.28'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

```answer1.2
Подключился в консоль контейнера:
  ubuntu@vm1-amd-1-1:~/06-db-03-mysql$ sudo docker ps
  CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                                  NAMES
  d55e98b39bb3   mysql:8   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   06-db-03-mysql_mysql_1
  ubuntu@vm1-amd-1-1:~/06-db-03-mysql$ sudo docker exec -it d55e98b39bb3 bash
  root@d55e98b39bb3:/#

Восстановил из дампа таблицу orders с ее данными:
  root@d55e98b39bb3:/# mysql -u root -p -D test_db </tmp/backup/test_dump.sql
  Enter password:
  root@d55e98b39bb3:/#

```

Перейдите в управляющую консоль `mysql` внутри контейнера.

```answer1.3
  root@d55e98b39bb3:/# mysql -u root -p -D test_db
  Enter password:
  Reading table information for completion of table and column names
  You can turn off this feature to get a quicker startup with -A
  
  Welcome to the MySQL monitor.  Commands end with ; or \g.
  Your MySQL connection id is 13
  Server version: 8.0.28 MySQL Community Server - GPL
  
  Copyright (c) 2000, 2022, Oracle and/or its affiliates.
  
  Oracle is a registered trademark of Oracle Corporation and/or its
  affiliates. Other names may be trademarks of their respective
  owners.
  
  Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
  
  mysql> select * from orders;
  +----+-----------------------+-------+
  | id | title                 | price |
  +----+-----------------------+-------+
  |  1 | War and Peace         |   100 |
  |  2 | My little pony        |   500 |
  |  3 | Adventure mysql times |   300 |
  |  4 | Server gravity falls  |   300 |
  |  5 | Log gossips           |   123 |
  +----+-----------------------+-------+
  5 rows in set (0.00 sec)
```

Используя команду `\h` получите список управляющих команд.

```answer1.4
  mysql> \h
  
  For information about MySQL products and services, visit:
     http://www.mysql.com/
  For developer information, including the MySQL Reference Manual, visit:
     http://dev.mysql.com/
  To buy MySQL Enterprise support, training, or other products, visit:
     https://shop.mysql.com/
  
  List of all MySQL commands:
  Note that all text commands must be first on line and end with ';'
  ?         (\?) Synonym for `help'.
  clear     (\c) Clear the current input statement.
  connect   (\r) Reconnect to the server. Optional arguments are db and host.
  delimiter (\d) Set statement delimiter.
  edit      (\e) Edit command with $EDITOR.
  ego       (\G) Send command to mysql server, display result vertically.
  exit      (\q) Exit mysql. Same as quit.
  go        (\g) Send command to mysql server.
  help      (\h) Display this help.
  nopager   (\n) Disable pager, print to stdout.
  notee     (\t) Don't write into outfile.
  pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
  print     (\p) Print current command.
  prompt    (\R) Change your mysql prompt.
  quit      (\q) Quit mysql.
  rehash    (\#) Rebuild completion hash.
  source    (\.) Execute an SQL script file. Takes a file name as an argument.
  status    (\s) Get status information from the server.
  system    (\!) Execute a system shell command.
  tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
  use       (\u) Use another database. Takes database name as argument.
  charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
  warnings  (\W) Show warnings after every statement.
  nowarning (\w) Don't show warnings after every statement.
  resetconnection(\x) Clean session context.
  query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
  
  For server side help, type 'help contents'
```

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Версия: **Server version:         8.0.28 MySQL Community Server - GPL**
```answer1.5
  mysql> status
  --------------
  mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)
  
  Connection id:          13
  Current database:       test_db
  Current user:           root@localhost
  SSL:                    Not in use
  Current pager:          stdout
  Using outfile:          ''
  Using delimiter:        ;
  Server version:         8.0.28 MySQL Community Server - GPL
  Protocol version:       10
  Connection:             Localhost via UNIX socket
  Server characterset:    utf8mb4
  Db     characterset:    utf8mb4
  Client characterset:    latin1
  Conn.  characterset:    latin1
  UNIX socket:            /var/run/mysqld/mysqld.sock
  Binary data as:         Hexadecimal
  Uptime:                 13 min 57 sec
  
  Threads: 2  Questions: 46  Slow queries: 0  Opens: 168  Flush tables: 3  Open tables: 86  Queries per second avg: 0.054
  --------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```answer1.5
  mysql> show tables;
  +-------------------+
  | Tables_in_test_db |
  +-------------------+
  | orders            |
  +-------------------+
  1 row in set (0.10 sec)
```

**Приведите в ответе** количество записей с `price` > 300.

```answer1.6
Так как условие введено строго больше, а не больше или 
равно - получили только одну строку:
  mysql> select count(*) from orders where price > 300;
  +----------+
  | count(*) |
  +----------+
  |        1 |
  +----------+
  1 row in set (0.00 sec)
```

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```answer2.1
  mysql> CREATE USER 'test'@'localhost'
      ->   IDENTIFIED WITH mysql_native_password BY 'test-pass'
      ->   WITH MAX_QUERIES_PER_HOUR 100
      ->   PASSWORD EXPIRE INTERVAL 180 DAY
      ->   FAILED_LOGIN_ATTEMPTS 3
      ->   ATTRIBUTE '{"lname":"Pretty", "fname":"James"}';
  Query OK, 0 rows affected (0.14 sec)
```

Предоставьте привилегии пользователю `test` на операции SELECT базы `test_db`.

```answer2.2
  mysql> GRANT SELECT ON test_db.orders TO 'test'@'localhost';
  Query OK, 0 rows affected, 1 warning (0.01 sec)
  mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
  Query OK, 0 rows affected, 1 warning (0.12 sec)
```
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

```answer2.3
  mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
  +------+-----------+---------------------------------------+
  | USER | HOST      | ATTRIBUTE                             |
  +------+-----------+---------------------------------------+
  | test | localhost | {"fname": "James", "lname": "Pretty"} |
  +------+-----------+---------------------------------------+
  1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```answer3.1
  mysql> SELECT TABLE_NAME,
      ->        ENGINE
      -> FROM   information_schema.TABLES
      -> WHERE  TABLE_SCHEMA = 'test_db'
      ->         AND TABLE_NAME = 'orders';
  +------------+--------+
  | TABLE_NAME | ENGINE |
  +------------+--------+
  | orders     | InnoDB |
  +------------+--------+
  1 row in set (0.00 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`

```answer3.2
ALTER TABLE orders ENGINE = MyISAM;
```

- на `InnoDB`

```answer3.2
ALTER TABLE orders ENGINE = InnoDB;
```
```answer3.3
  mysql> SHOW PROFILES;
  +----------+------------+-------------------------------------------------------------------------------------------------------------------------------------+
  | Query_ID | Duration   | Query                                                                                                                               |
  +----------+------------+-------------------------------------------------------------------------------------------------------------------------------------+
  |        1 | 0.01267050 | SELECT TABLE_NAME,
         ENGINE
  FROM   information_schema.TABLES
  WHERE  TABLE_SCHEMA = 'test_db'                                   |
  |        2 | 0.00113550 | SELECT TABLE_NAME,
         ENGINE
  FROM   information_schema.TABLES
  WHERE  TABLE_SCHEMA = 'test_db'
          AND TABLE_NAME = 'orders' |
  |        3 | 0.17753200 | ALTER TABLE orders ENGINE = MyISAM                                                                                                  |
  |        4 | 0.05583675 | ALTER TABLE orders ENGINE = InnoDB                                                                                                  |
  +----------+------------+-------------------------------------------------------------------------------------------------------------------------------------+
  4 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

```answer4.1
  root@d55e98b39bb3:/# cat /etc/mysql/my.cnf
  # Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
  #
  # This program is free software; you can redistribute it and/or modify
  # it under the terms of the GNU General Public License as published by
  # the Free Software Foundation; version 2 of the License.
  #
  # This program is distributed in the hope that it will be useful,
  # but WITHOUT ANY WARRANTY; without even the implied warranty of
  # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  # GNU General Public License for more details.
  #
  # You should have received a copy of the GNU General Public License
  # along with this program; if not, write to the Free Software
  # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
  
  #
  # The MySQL  Server configuration file.
  #
  # For explanations see
  # http://dev.mysql.com/doc/mysql/en/server-system-variables.html
  
  [mysqld]
  pid-file        = /var/run/mysqld/mysqld.pid
  socket          = /var/run/mysqld/mysqld.sock
  datadir         = /var/lib/mysql
  secure-file-priv= NULL
  
  # Custom config should go here
  !includedir /etc/mysql/conf.d/
```

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```answer4.2
Вывел все доступные параметры с описанием при помощи команды:
  root@d55e98b39bb3:/# mysqld --verbose --help >/tmp/backup/mysqld_verbose.txt

Далее искал IO и нашел статью в базе знаний на сайте самого 
mysql (все ссылки в конце документа), где перечислены 
основные параметры для тонкой настройки производительности 
при упоре в IO. Так как у меня работает сервер БД в 
контейнера, запущенном в минимальной ВМ (Oracle free tear), 
то не могу непосредственно сам применить-проверить настройки 
в полной мере, но должны быть следующие параметры:
 
  [mysqld]
  pid-file        = /var/run/mysqld/mysqld.pid
  socket          = /var/run/mysqld/mysqld.sock
  datadir         = /var/lib/mysql
  secure-file-priv= NULL
  
  innodb_flush_log_at_trx_commit = 2
  innodb-compression-level=9
  innodb_log_buffer_size = 1M
  innodb_buffer_pool_size = 330M (примерно треть от 1Gb у моей ВМ, 
        но в качестве рекомендуемого значения указано 50-75%, 
        в статье, кстати)  
  innodb_log_file_size = 100M
  # Custom config should go here
  !includedir /etc/mysql/conf.d/

Еще были указаны эти параметры/значения тоже в качестве 
рекомендуемых при попытке оптимизировать/настроить 
производительность IO:
  innodb_use_fdatasync = ON
  innodb_flush_method = O_DIRECT
  innodb_io_capacity = 1000
  innodb_io_capacity_max = 2500
```

---

```comment
При работе над ДЗ использовал следующие ресурсы:
https://citizix.com/how-to-run-mysql-8-with-docker-and-docker-compose/
https://stackoverflow.com/questions/105776/how-do-i-restore-a-dump-file-from-mysqldump
https://dev.mysql.com/doc/refman/8.0/en/create-user.html
https://dev.mysql.com/doc/refman/8.0/en/grant.html
https://stackoverflow.com/questions/213543/how-can-i-check-mysql-engine-type-for-a-specific-table
https://dev.mysql.com/doc/refman/8.0/en/alter-table.html
https://dev.mysql.com/doc/refman/8.0/en/option-files.html
https://dev.mysql.com/doc/refman/8.0/en/optimizing-innodb-diskio.html
https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html

```

---