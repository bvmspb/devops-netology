# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 sysadmin 06.02 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «6.2. SQL»

# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```yaml
version: '3'
services:
  postgres:
    image: postgres:12
    restart: always
    environment:
           POSTGRES_DB: "testdb"
           POSTGRES_USER: "postgres"
           POSTGRES_PASSWORD: "postgres"
           PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - ./volume:/var/lib/postgresql/data
      - ./backup:/tmp/backup
        #      - /var/run/postgresql/:var/run/postgresql  
    ports:
      - "5432:5432"
```
```answer1
    При первом запуске
    sudo docker-compose up
    в текущем каталоге рядом с docker-compose.yml файлом создаются два каталога:
    ./volume - для хранения данных БД контейнера
    ./backup - будет исопльзоваться для сохранения резверных копий из контейнеров  
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

```answer2.1-1
    ubuntu@vm1-amd-1-1:~$ psql -h 0.0.0.0 -p 5432 -U postgres -d testdb
    Password for user postgres:
    psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10 (Debian 12.10-1.pgdg110+1))
    Type "help" for help.
    test_db=# create database test_db;
    CREATE DATABASE
    ubuntu@vm1-amd-1-1:~$ psql -h 0.0.0.0 -p 5432 -U postgres -d test_db
    Password for user postgres:
    psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10 (Debian 12.10-1.pgdg110+1))
    Type "help" for help.
    
    test_db=# create role "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN PASSWORD 'adminpass';
    CREATE ROLE
    test_db=# GRANT ALL ON orders TO "test-admin-user";
    GRANT
    test_db=# GRANT ALL ON clients TO "test-admin-user";
    GRANT
    test_db=# create role "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN PASSWORD 'simplepass';
    CREATE ROLE
    test_db=# GRANT SELECT, UPDATE, INSERT, DELETE ON clients TO "test-simple-user";
    GRANT
    test_db=# GRANT SELECT, UPDATE, INSERT, DELETE ON orders TO "test-simple-user";
    GRANT
```
```answer2.1-2
    Полезными оказались следующие ссылки на документацию:
    https://www.postgresql.org/docs/12/user-manag.html
    https://www.postgresql.org/docs/12/ddl-priv.html
    https://www.postgresql.org/docs/12/sql-createrole.html
    https://www.postgresql.org/docs/12/sql-createindex.html
    https://dba.stackexchange.com/questions/4286/list-the-database-privileges-using-psql

```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

```answer2.2-1
    test_db=# CREATE TABLE orders
    (
    id serial NOT NULL primary key,
    name text NOT NULL,
    price integer NOT NULL
    );
```

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

```answer2.3-1
    test_db=# CREATE TABLE clients
    (
     id serial NOT NULL PRIMARY KEY,
     lastname text NOT NULL,
     country text,
     orderref integer,
     FOREIGN KEY (orderref) REFERENCES orders (id)
    );
    CREATE TABLE
    test_db=# CREATE INDEX country ON clients (country);
    CREATE INDEX
```

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```answer2.4-1
    testdb-# \l
                                     List of databases
       Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
    -----------+----------+----------+------------+------------+-----------------------
     postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
     template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
     testdb    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
    (5 rows)
    
    test_db=# \d orders
                                Table "public.orders"
     Column |  Type   | Collation | Nullable |              Default
    --------+---------+-----------+----------+------------------------------------
     id     | integer |           | not null | nextval('orders_id_seq'::regclass)
     name   | text    |           | not null |
     price  | integer |           | not null |
    Indexes:
        "orders_pkey" PRIMARY KEY, btree (id)
    
    test_db=# \d clients
                                 Table "public.clients"
      Column  |  Type   | Collation | Nullable |               Default
    ----------+---------+-----------+----------+-------------------------------------
     id       | integer |           | not null | nextval('clients_id_seq'::regclass)
     lastname | text    |           | not null |
     country  | text    |           |          |
     orderref | integer |           |          |
    Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)
        "country" btree (country)
    Foreign-key constraints:
        "clients_orderref_fkey" FOREIGN KEY (orderref) REFERENCES orders(id)
    
    test_db=# \dp
                                                  Access privileges
     Schema |         Name         |   Type   |         Access privileges          | Column privileges | Policies
    --------+----------------------+----------+------------------------------------+-------------------+----------
     public | clients              | table    | postgres=arwdDxt/postgres         +|                   |
            |                      |          | "test-admin-user"=arwdDxt/postgres+|                   |
            |                      |          | "test-simple-user"=arwd/postgres   |                   |
     public | clients_id_seq       | sequence |                                    |                   |
     public | clients_orderref_seq | sequence |                                    |                   |
     public | orders               | table    | postgres=arwdDxt/postgres         +|                   |
            |                      |          | "test-admin-user"=arwdDxt/postgres+|                   |
            |                      |          | "test-simple-user"=arwd/postgres   |                   |
     public | orders_id_seq        | sequence |                                    |                   |
    (5 rows)
    
    test_db=# SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name in ('orders','clients');
     table_name |     grantee      | privilege_type
    ------------+------------------+----------------
     orders     | postgres         | INSERT
     orders     | postgres         | SELECT
     orders     | postgres         | UPDATE
     orders     | postgres         | DELETE
     orders     | postgres         | TRUNCATE
     orders     | postgres         | REFERENCES
     orders     | postgres         | TRIGGER
     orders     | test-admin-user  | INSERT
     orders     | test-admin-user  | SELECT
     orders     | test-admin-user  | UPDATE
     orders     | test-admin-user  | DELETE
     orders     | test-admin-user  | TRUNCATE
     orders     | test-admin-user  | REFERENCES
     orders     | test-admin-user  | TRIGGER
     orders     | test-simple-user | INSERT
     orders     | test-simple-user | SELECT
     orders     | test-simple-user | UPDATE
     orders     | test-simple-user | DELETE
     clients    | postgres         | INSERT
     clients    | postgres         | SELECT
     clients    | postgres         | UPDATE
     clients    | postgres         | DELETE
     clients    | postgres         | TRUNCATE
     clients    | postgres         | REFERENCES
     clients    | postgres         | TRIGGER
     clients    | test-admin-user  | INSERT
     clients    | test-admin-user  | SELECT
     clients    | test-admin-user  | UPDATE
     clients    | test-admin-user  | DELETE
     clients    | test-admin-user  | TRUNCATE
     clients    | test-admin-user  | REFERENCES
     clients    | test-admin-user  | TRIGGER
     clients    | test-simple-user | INSERT
     clients    | test-simple-user | SELECT
     clients    | test-simple-user | UPDATE
     clients    | test-simple-user | DELETE
    (36 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

```answer3.1-1
    test_db=# INSERT INTO orders (name, price) VALUES ('Шоколад',10), ('Принтер',3000), ('Книга',500), ('Монитор',7000), ('Гитара',4000);
    INSERT 0 5
```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```answer3.2-1
    test_db=# INSERT INTO clients (lastname, country) VALUES ('Иванов Иван Иванович','USA'), ('Петров Петр Петрович','Canada'), ('Иоганн Себастьян Бах','Japan'), ('Ронни Джеймс Дио','Russia'), ('Ritchie Blackmore','Russia');
    INSERT 0 5
```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```answer3.3-1
    Если я правильно понял - вывести счетчик количества строк в таблице 
    (всего - без дополнительных условий) - по 5 строк в каждой.
    
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

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```answer4.1-1
    test_db=# UPDATE clients SET orderref=3 WHERE id=1;
    UPDATE 1
    test_db=# UPDATE clients SET orderref=4 WHERE id=2;
    UPDATE 1
    test_db=# UPDATE clients SET orderref=5 WHERE id=3;
    UPDATE 1
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```answer4.1-2
    test_db=# select * from clients where orderref notnull;
     id |       lastname       | country | orderref
    ----+----------------------+---------+----------
      1 | Иванов Иван Иванович | USA     |        3
      2 | Петров Петр Петрович | Canada  |        4
      3 | Иоганн Себастьян Бах | Japan   |        5
    (3 rows)
```
 
Подсказк - используйте директиву `UPDATE`.

```answer4.1-3
    Сначала смотрю какие id нужно прописать в orderref в соответствии с 
    товарами:
    Книга = 3
    Монитор = 4
    Гитара = 5
    
    test_db=# select * from orders;
     id |  name   | price
    ----+---------+-------
      1 | Шоколад |    10
      2 | Принтер |  3000
      3 | Книга   |   500
      4 | Монитор |  7000
      5 | Гитара  |  4000
    (5 rows)
    
    
    Далее ищу id клиентов, которым нужно добавить ссылку на заказ:
    Иванов ИИ = 1
    Петров ПП = 2
    Иоганн СБ = 3
    
    test_db=# select * from clients;
     id |       lastname       | country | orderref
    ----+----------------------+---------+----------
      1 | Иванов Иван Иванович | USA     |
      2 | Петров Петр Петрович | Canada  |
      3 | Иоганн Себастьян Бах | Japan   |
      4 | Ронни Джеймс Дио     | Russia  |
      5 | Ritchie Blackmore    | Russia  |
    (5 rows)
    
    После чего делаю Update нужными значениями со ссылкой в orderref.
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

```answer5.1-1
test_db=# EXPLAIN select * from clients where orderref notnull;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (orderref IS NOT NULL)
(2 rows)
```

Приведите получившийся результат и объясните что значат полученные значения.

```answer5.2-1
    Описание данной директивы можно почитать в документации на сайте: 
    https://www.postgresql.org/docs/12/using-explain.html
    
    В данном случае план запроса состоит их двух шагов:
    1 Последовательное чтение/сканирование данных посторочно из таблицы
    2 Фильтрация результатов в соответствии с критерием в моем запросе
    
    Судя по всему - этот запрос достаточно простой и эффективный.
    Насколько я понял - есть еще не "простое последовательное сканирование", 
    но чтение из индекса - заранее отсортированный список по столбцу\группе 
    столбцов, который значительно ускоряет поиск данных в нем - то есть 
    правильно созданный индекс позволит ускорить операции чтения данных из 
    таблицы при необходимости фильтрации/сортировки данных постолбцам 
    описанных в индексе. Обратной стороной использования индексов является 
    дополнительная нагрузка/замедление при добавлении/изменении данных в 
    таблице, т.к. при этом должен быть также обновлен и индекс.  
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```answer6
Сначала запустил bash shell внутри контейнера, где запущена PostgreSQL:
ubuntu@vm1-amd-1-1:~$ sudo docker exec -i -t 612c6a4d8a51 bash
root@612c6a4d8a51:/#

Далее сдампил БД в файл по пути, который подключен в контейнере как volume:
root@612c6a4d8a51:/# pg_dump -U postgres -c -C -f /tmp/backup/backup.sql test_db

Также выгрузил роли:
root@612c6a4d8a51:/# pg_dumpall -U postgres -g -f /tmp/backup/backuproles.sql

После чего полностью остановил контейнер с PostgreeSQL:
ubuntu@vm1-amd-1-1:~/06-db-02-sql$ sudo docker-compose down
Removing 06-db-02-sql_postgres_1 ... done
Removing network 06-db-02-sql_default
ubuntu@vm1-amd-1-1:~/06-db-02-sql$

Далее запустил базовый образ с PostgreSQL:12 с одним подмапленным volume - где расположен backup:
ubuntu@vm1-amd-1-1:~/06-db-02-sql$ sudo docker run --name pg12 -e POSTGRES_PASSWORD=postgres -v /home/ubuntu/06-db-02-sql/backup:/tmp/backup -d -p 5432:5432 postgres:12
2b2adf56d018d627e42a5dfb1a84d6fe5a9f151181cfee1944167379f8ee7cb8
ubuntu@vm1-amd-1-1:~/06-db-02-sql$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS         PORTS                                       NAMES
2b2adf56d018   postgres:12   "docker-entrypoint.s…"   11 seconds ago   Up 9 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg12

Запустил bash shell в данном контейнере:
ubuntu@vm1-amd-1-1:~$ sudo docker exec -i -t 2b2adf56d018 bash
root@2b2adf56d018:/# ls -la /tmp/backup/
total 20
drwxr-xr-x 2 root root 4096 Mar  7 20:07 .
drwxrwxrwt 1 root root 4096 Mar  7 20:17 ..
-rw-r--r-- 1 root root  771 Mar  7 20:07 backuproles.sql
-rw-r--r-- 1 root root 4928 Mar  7 20:00 backup.sql

Восстановил из дампа роли и затем объекты БД:
root@2b2adf56d018:/# psql -h 0.0.0.0 -p 5432 -U postgres -f /tmp/backup/backuproles.sql
SET
SET
SET
psql:/tmp/backup/backuproles.sql:14: ERROR:  role "postgres" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE

root@2b2adf56d018:/# psql -h 0.0.0.0 -p 5432 -U postgres -f /tmp/backup/backup.sql
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
psql:/tmp/backup/backup.sql:19: ERROR:  database "test_db" does not exist
CREATE DATABASE
ALTER DATABASE
You are now connected to database "test_db" as user "postgres".
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
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
root@2b2adf56d018:/#

После чего можно подключиться к указанной БД и видны все данные:
root@2b2adf56d018:/# psql -h 0.0.0.0 -p 5432 -U postgres -d test_db
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

test_db=# select * from clients;
 id |       lastname       | country | orderref
----+----------------------+---------+----------
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(5 rows)

test_db=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of
------------------+------------------------------------------------------------+-----------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  | Superuser, No inheritance                                  | {}
 test-simple-user | No inheritance                                             | {}

```

Файлы backup и docker composer:

[backup.sql](https://github.com/bvmspb/devops-netology/tree/main/06_db_02_sql/backup.sql)

[06_db_02_sql/backup.sql](./06_db_02_sql/backup.sql)

[backuproles.sql](https://github.com/bvmspb/devops-netology/tree/main/06_db_02_sql/backuproles.sql)

[06_db_02_sql/backuproles.sql](./06_db_02_sql/backuproles.sql)

[docker-compose.yml](https://github.com/bvmspb/devops-netology/tree/main/06_db_02_sql/docker-compose.yml)

[06_db_02_sql/docker-compose.yml](./06_db_02_sql/docker-compose.yml)

---

