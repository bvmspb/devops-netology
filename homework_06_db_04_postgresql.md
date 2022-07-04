# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 db 06.04 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «6.4. PostgreSQL»

# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```yaml
version: '3'
services:
  postgres:
    image: postgres:13
    restart: always
    environment:
           #POSTGRES_DB: "testdb"
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
```answer1.1
    При первом запуске
    sudo docker-compose up
    в текущем каталоге рядом с docker-compose.yml файлом создаются два каталога:
    ./volume - для хранения данных БД контейнера
    ./backup - будет исопльзоваться для сохранения резверных копий из контейнеров  
```

Подключитесь к БД PostgreSQL используя `psql`.

```bash
    bvm@bvm-HP-EliteBook-8470p:~$ psql -U postgres -h localhost -p 5432
    Password for user postgres: 
    psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
    WARNING: psql major version 12, server major version 13.
             Some psql features might not work.
    Type "help" for help.
    
    postgres=# 
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД

```answer1.2
    \l[+]   [PATTERN]      list databases
```

- подключения к БД

```answer1.3
    Connection
      \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                             connect to new database (currently "postgres")
```

- вывода списка таблиц

```answer1.4
    \dt[S+] [PATTERN]      list tables
```

- вывода описания содержимого таблиц

```answer1.5
    \d[S+]  NAME           describe table, view, sequence, or index
```

- выхода из psql

```answer1.6
    \q                     quit psql
```
```bash
    postgres=# \l
                                     List of databases
       Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -----------+----------+----------+------------+------------+-----------------------
     postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
     template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
    (3 rows)
    
    postgres=# \c postgres
    psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
    WARNING: psql major version 12, server major version 13.
             Some psql features might not work.
    You are now connected to database "postgres" as user "postgres".
    
    postgres=# \dt
    Did not find any relations.
    postgres=# \dtS
    (Получил длинный список 62 системных таблиц)
    
    postgres=# \d pg_aggregate
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
    
    postgres=# \q
    bvm@bvm-HP-EliteBook-8470p:~$ 
```

## Задача 2

Используя `psql` создайте БД `test_database`.

```answer2.1
    bvm@bvm-HP-EliteBook-8470p:~$ psql -U postgres -h localhost -p 5432
    Password for user postgres: 
    psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
    WARNING: psql major version 12, server major version 13.
             Some psql features might not work.
    Type "help" for help.
    
    postgres=# create database test_database;
    CREATE DATABASE
    postgres=# \l
    
                                       List of databases
         Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    ---------------+----------+----------+------------+------------+-----------------------
     postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
     template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                   |          |          |            |            | postgres=CTc/postgres
     template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                   |          |          |            |            | postgres=CTc/postgres
     test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    (4 rows)
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```answer2.2
    postgres=# \c test_database 
    psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
    WARNING: psql major version 12, server major version 13.
             Some psql features might not work.
    You are now connected to database "test_database" as user "postgres".
    test_database=# \i ~/netology/devops-netology/06_db_04_postgresql/test_dump.sql
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
    
    test_database=# \dt
    Did not find any relations.
    test_database=# \l
                                       List of databases
         Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    ---------------+----------+----------+------------+------------+-----------------------
     postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
     template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                   |          |          |            |            | postgres=CTc/postgres
     template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                   |          |          |            |            | postgres=CTc/postgres
     test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    (4 rows)
    
    test_database=# \c test_database 
    psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
    WARNING: psql major version 12, server major version 13.
             Some psql features might not work.
    You are now connected to database "test_database" as user "postgres".
    test_database=# \dt
             List of relations
     Schema |  Name  | Type  |  Owner   
    --------+--------+-------+----------
     public | orders | table | postgres
    (1 row)
```

Перейдите в управляющую консоль `psql` внутри контейнера.

```answer2.3
    bvm@bvm-HP-EliteBook-8470p:~$ sudo docker ps
    CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
    56ed1a55545d   postgres:13   "docker-entrypoint.s…"   47 minutes ago   Up 47 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   06_db_04_postgresql_postgres_1
    bvm@bvm-HP-EliteBook-8470p:~$ sudo docker exec -it 56ed1a55545d bash
    root@56ed1a55545d:/# psql -u postgres
    /usr/lib/postgresql/13/bin/psql: invalid option -- 'u'
    Try "psql --help" for more information.
    root@56ed1a55545d:/# psql -U postgres
    psql (13.7 (Debian 13.7-1.pgdg110+1))
    Type "help" for help.
    
    postgres=# 
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```answer2.4
    test_database=# \c test_database 
    You are now connected to database "test_database" as user "postgres".
    test_database=# \h ANALYZE
    Command:     ANALYZE
    Description: collect statistics about a database
    Syntax:
    ANALYZE [ ( option [, ...] ) ] [ table_and_columns [, ...] ]
    ANALYZE [ VERBOSE ] [ table_and_columns [, ...] ]
    
    where option can be one of:
    
        VERBOSE [ boolean ]
        SKIP_LOCKED [ boolean ]
    
    and table_and_columns is:
    
        table_name [ ( column_name [, ...] ) ]
    
    URL: https://www.postgresql.org/docs/13/sql-analyze.html
    
    test_database=# \dt
             List of relations
     Schema |  Name  | Type  |  Owner   
    --------+--------+-------+----------
     public | orders | table | postgres
    (1 row)
    
    test_database=# analyze verbose orders ;
    INFO:  analyzing "public.orders"
    INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
    ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```answer2.5
    test_database=# select attname, avg_width from pg_stats where tablename like('orders') order by avg_width desc limit 1;
     attname | avg_width 
    ---------+-----------
     title   |        16
    (1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```answer3
    Опирался на документацию:
        https://www.postgresql.org/docs/13/ddl-partitioning.html
    Также помогла небольшая статья с "примером из жизни":
        https://rodoq.medium.com/partition-an-existing-table-on-postgresql-480b84582e8d
    
    Существующую таблицу с данными, которую создавали изначально как обычную
    таблицу, невозможно трансформировать непосредственно в партицированную 
    (partitioned), но при этом можно такую обычную таблицу подключить в 
    качестве партиции к другой (partitioned) таблице. Это может быть удобно 
    при работе, например, с данными в таблице, которые наклапливаются в 
    хронологическом порядке - такие как логи и т.п. В нашем же случае данные 
    в таблице уже могут находиться в обоих диапазонах будущих двух партиций, 
    поэтому я пошел по пути создания параллельной копии старой таблицы, но 
    изначально созданной для работы с партициями, после чего перенесу данные 
    из старой таблицы и переименую новую таблицу в старое имя. Тем самым 
    новая таблица со своими партициями полностью заменит собой одну старую 
    таблицу.
    
    В документации описывается описание условий для партцийи через триггер, 
    либо через использование правил - мне вариант с правилами показался проще 
    и я использовал его, хотя у него может быть дополнительная 
    нагрузка/замедление по сравнению с триггером, как написано, но в каждом 
    случае нужно исходить из регулярных задач для БД и этой таблицы. В нашем
    случае я решил пренебречь этим оверхедом, т.к. с академической точки 
    зрения это не важно - главное разобраться с партициями для таблиц, как 
    мне кажется.
    
    Конечный результат фомально получился правильным - как написано в задании,
    но такой подход подразумевает работу с дополнительной копией данных, что
    значит удвоенное использование места в период такой трансформации - может
    быть проблемой для действительно больших таблиц. Опять же - невозможно 
    полностью исключить задержки доступа к данным при работе в live prod DB.
    Вариантов осуществления такого разбиения я встретил несколько в сети, но
    ни одной решение не позволяло "одной командой разбить таблицу, без 
    существенного замедления/отсутствия блокировок доступа", к сожалению.      
```
```answer3.1
    test_database=# \d+ orders
                                                           Table "public.orders"
     Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description 
    --------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
     id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
     title  | character varying(80) |           | not null |                                    | extended |              | 
     price  | integer               |           |          | 0                                  | plain    |              | 
    Indexes:
        "orders_pkey" PRIMARY KEY, btree (id)
    Access method: heap
    
    test_database=# create table orders_new (like orders including all);
    CREATE TABLE
    test_database=# \d+ orders_new
                                                         Table "public.orders_new"
     Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description 
    --------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
     id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
     title  | character varying(80) |           | not null |                                    | extended |              | 
     price  | integer               |           |          | 0                                  | plain    |              | 
    Indexes:
        "orders_new_pkey" PRIMARY KEY, btree (id)
    Access method: heap
    
    test_database=# create table orders_1 ( check (price >499) ) inherits ( orders_new );
    CREATE TABLE
    test_database=# create table orders_2 ( check (price <=499) ) inherits ( orders_new );
    CREATE TABLE
    test_database=# create index orders_1_price on orders_1 (price);
    CREATE INDEX
    test_database=# create index orders_2_price on orders_2 (price);
    CREATE INDEX
    
    test_database=# alter table orders rename to orders_legacy;
    ALTER TABLE
    test_database=# alter table orders_new rename to orders;
    ALTER TABLE
    
    test_database=# create rule orders_insert_ge499_to_1 as on insert to orders where (price >499) do instead insert into orders_1 values (NEW.*);
    CREATE RULE
    test_database=# create rule orders_insert_le499_to_2 as on insert to orders where (price <=499) do instead insert into orders_2 values (NEW.*);
    CREATE RULE
    
    test_database=# \d+ orders
                                                           Table "public.orders"
     Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description 
    --------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
     id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
     title  | character varying(80) |           | not null |                                    | extended |              | 
     price  | integer               |           |          | 0                                  | plain    |              | 
    Indexes:
        "orders_new_pkey" PRIMARY KEY, btree (id)
    Rules:
        orders_insert_ge499_to_1 AS
        ON INSERT TO orders
       WHERE new.price > 499 DO INSTEAD  INSERT INTO orders_1 (id, title, price)
      VALUES (new.id, new.title, new.price)
        orders_insert_le499_to_2 AS
        ON INSERT TO orders
       WHERE new.price <= 499 DO INSTEAD  INSERT INTO orders_2 (id, title, price)
      VALUES (new.id, new.title, new.price)
    Child tables: orders_1,
                  orders_2
    Access method: heap
    test_database=# \d+ orders_1
                                                          Table "public.orders_1"
     Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description 
    --------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
     id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
     title  | character varying(80) |           | not null |                                    | extended |              | 
     price  | integer               |           |          | 0                                  | plain    |              | 
    Indexes:
        "orders_1_price" btree (price)
    Check constraints:
        "orders_1_price_check" CHECK (price > 499)
    Inherits: orders
    Access method: heap
    
    test_database=# \d+ orders_2
                                                          Table "public.orders_2"
     Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description 
    --------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
     id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
     title  | character varying(80) |           | not null |                                    | extended |              | 
     price  | integer               |           |          | 0                                  | plain    |              | 
    Indexes:
        "orders_2_price" btree (price)
    Check constraints:
        "orders_2_price_check" CHECK (price <= 499)
    Inherits: orders
    Access method: heap
    
    test_database=# insert into orders (id, title, price) select id, title, price from orders_legacy;
    INSERT 0 0
    
    test_database=# select * from orders;
     id |        title         | price 
    ----+----------------------+-------
      2 | My little database   |   500
      6 | WAL never lies       |   900
      8 | Dbiezdmin            |   501
      1 | War and peace        |   100
      3 | Adventure psql time  |   300
      4 | Server gravity falls |   300
      5 | Log gossips          |   123
      7 | Me and my bash-pet   |   499
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

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

```answer3.2
    Да, более того в документации прямо говорится о том, чтобы при дизайне 
    будущего решения сразу учитывалась возможность/необходимость разбиения 
    таблицы - например между носителями с различной скоростью работы - 
    данные текущего квартала хранить на быстром ssd, а архивные данные за 
    предыдущие периоды хранить на более медленных (и дешевых) дисках.
    Насколько я понимаю - главная сложность при таком планировании дизайна
    состоит в том, чтобы корректно составить список всех правил для 
    разбиения.  
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```answer4.1
    Резервную копию выполнил прямо в контейнере, но в подключенный volume для backup'ов:
        root@56ed1a55545d:/# cd /tmp/backup/
        root@56ed1a55545d:/tmp/backup# pg_dump -U postgres -d test_database -f ./backup.sql
        root@56ed1a55545d:/tmp/backup# ls -l
        total 8
        -rw-r--r-- 1 root root 5240 Jul  4 14:46 backup.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```answer4.2
В созданном бэкапе есть следующий фрагмент, который отвечает за создание 
таблицы orders, частью которой и является столбец title. Добавил
параметр UNIQUE для этого поля таблицы:
```
```sql
CREATE TABLE public.orders (
    id integer DEFAULT nextval('public.orders_id_seq'::regclass) NOT NULL,
    title character varying(80) UNIQUE,
    price integer DEFAULT 0
);
```

---
