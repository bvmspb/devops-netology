# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 sysadmin 05.03 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера»

# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

```answer1-1
        Подготовил index.html с указанным содержимым. Также создал Dockerfile 
        со следуюим содржимым:
```
```Dokerfile
        FROM nginx:alpine
        COPY index.html /usr/share/nginx/html/index.html
        EXPOSE 80
        STOPSIGNAL SIGQUIT
```
```answer1-2
        Далее создал собственнй образ используя созданный Dockerfile:
```
```bash
        ubuntu@vm1-amd-1-1:~/nginx$ sudo docker build -t simple-nginx .
        Sending build context to Docker daemon  3.072kB
        Step 1/4 : FROM nginx:alpine
         ---> cc44224bfe20
        Step 2/4 : COPY index.html /usr/share/nginx/html/index.html
         ---> 550b36c26359
        Step 3/4 : EXPOSE 80
         ---> Running in 030dfb342776
        Removing intermediate container 030dfb342776
         ---> ee5c97988a3f
        Step 4/4 : STOPSIGNAL SIGQUIT
         ---> Running in b8a1e0cb3115
        Removing intermediate container b8a1e0cb3115
         ---> 144df15ee62c
        Successfully built 144df15ee62c
        Successfully tagged simple-nginx:latest
```
```answer1-3
        После чего пробно запустил контейнер из созданного образа и проверил 
        возможность подключиться к запущенному таким образом серверу:
```
```bash
        ubuntu@vm1-amd-1-1:~/nginx$ sudo docker run --rm -it -p 80:80 simple-nginx
        /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
        /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
        /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
        10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
        10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
        /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
        /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
        /docker-entrypoint.sh: Configuration complete; ready for start up
        2022/01/24 18:25:26 [notice] 1#1: using the "epoll" event method
        2022/01/24 18:25:26 [notice] 1#1: nginx/1.21.5
        2022/01/24 18:25:26 [notice] 1#1: built by gcc 10.3.1 20211027 (Alpine 10.3.1_git20211027)
        2022/01/24 18:25:26 [notice] 1#1: OS: Linux 5.11.0-1022-oracle
        2022/01/24 18:25:26 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
        2022/01/24 18:25:26 [notice] 1#1: start worker processes
        2022/01/24 18:25:26 [notice] 1#1: start worker process 33
        2022/01/24 18:25:26 [notice] 1#1: start worker process 34
        5.18.180.181 - - [24/Jan/2022:18:25:30 +0000] "GET / HTTP/1.1" 200 90 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36" "-"
        5.18.180.181 - - [24/Jan/2022:18:25:36 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36" "-"
        ^C2022/01/24 18:25:40 [notice] 1#1: signal 2 (SIGINT) received, exiting
        2022/01/24 18:25:40 [notice] 33#33: signal 2 (SIGINT) received, exiting
        2022/01/24 18:25:40 [notice] 33#33: exiting
        2022/01/24 18:25:40 [notice] 33#33: exit
        2022/01/24 18:25:40 [notice] 34#34: signal 2 (SIGINT) received, exiting
        2022/01/24 18:25:40 [notice] 34#34: exiting
        2022/01/24 18:25:40 [notice] 34#34: exit
        2022/01/24 18:25:40 [notice] 1#1: signal 17 (SIGCHLD) received from 33
        2022/01/24 18:25:40 [notice] 1#1: worker process 33 exited with code 0
        2022/01/24 18:25:40 [notice] 1#1: signal 29 (SIGIO) received
        2022/01/24 18:25:40 [notice] 1#1: signal 17 (SIGCHLD) received from 34
        2022/01/24 18:25:40 [notice] 1#1: worker process 34 exited with code 0
        2022/01/24 18:25:40 [notice] 1#1: exit
```
```answer1-4
        Далее попробовал отправить локальный образ в удаленное хранилище 
        hub.docker.io 
```
```bash
        ubuntu@vm1-amd-1-1:~/nginx$ sudo docker tag simple-nginx bvmspb/homeworks:simple-nginx
        ubuntu@vm1-amd-1-1:~/nginx$ sudo docker push bvmspb/homeworks:simple-nginx
        The push refers to repository [docker.io/bvmspb/homeworks]
        74a87574ae61: Preparing
        419df8b60032: Preparing
        0e835d02c1b5: Preparing
        5ee3266a70bd: Preparing
        3f87f0a06073: Preparing
        1c9c1e42aafa: Waiting
        8d3ac3489996: Waiting
        denied: requested access to the resource is denied
        ubuntu@vm1-amd-1-1:~/nginx$ sudo docker login
        Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
        Username: bvmspb
        Password:
        WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
        Configure a credential helper to remove this warning. See
        https://docs.docker.com/engine/reference/commandline/login/#credentials-store
        
        Login Succeeded
        ubuntu@vm1-amd-1-1:~/nginx$ sudo docker push bvmspb/homeworks:simple-nginx
        The push refers to repository [docker.io/bvmspb/homeworks]
        74a87574ae61: Pushed
        419df8b60032: Mounted from library/nginx
        0e835d02c1b5: Mounted from library/nginx
        5ee3266a70bd: Mounted from library/nginx
        3f87f0a06073: Mounted from library/nginx
        1c9c1e42aafa: Mounted from library/nginx
        8d3ac3489996: Mounted from library/nginx
        simple-nginx: digest: sha256:7188c34b66c502846ca6dea2947c0941e84036d7599fb2b7769851b2d4305828 size: 1775
```
```answer1-5
Теперь этот образ доступен всем в публичном репозитории командой:
```
```bash
        ubuntu@vm1-amd-1-1:~$ sudo docker pull bvmspb/homeworks:simple-nginx
        simple-nginx: Pulling from bvmspb/homeworks
        Digest: sha256:7188c34b66c502846ca6dea2947c0941e84036d7599fb2b7769851b2d4305828
        Status: Image is up to date for bvmspb/homeworks:simple-nginx
        docker.io/bvmspb/homeworks:simple-nginx
```
## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

```answer2
Мои ответы по каждому сценарию представлены в таблице ниже, но прежде
всего хотел обрисовать свое понимание того, в каком случае нужно 
использовать "голое железо", ВМ или контейнер. Современные тенденции
довольно четко дают понять, что "тренд на виртуализацию" пришел прочно
и как минимуму надолго. Единственные варианты, когда нужно точно 
использовать именно аппаратные сервера - это когда нужен прямой доступ
к "железу" - специфическое устройство, которое не удается пробросить
внутрь ВМ (или нецелесообразно - те же Ардуино нет смысла 
виртуализировать, например). Даже производительность уже часто не 
является останавливающим фыактором в современных версиях гипервизоров,
т.к. накладные расходы на обслуживание ВМ минимальны и на современном
оборудовании просто незаметны, а узкое горлышко, например, для любой 
БД - работа с накопителем и количество IOPS - можно решить путем 
выделения для таких ВМ отдельной высокопроизводительной "полки" для 
хранения данных, например.
Далее остаются ВМ и контейнеры - контейнеры являются легковесной версией 
"большой ВМ" и позволяют запустить параллельно несколько сервисов с
минимальными потерями ресурсов, поэтому в большинстве случаев, если
"можно виртуализировать", то следует рассмотреть возможность 
реализовать работу сервиса именно в контейнере.
И остаются варианты, когда сервис является достаточно "тяжелым", то 
есть не может быть разбит на мелкие составляющие, которые можно 
разнести по контейнерам (например, это могут быть старые приложения, 
которые могут уже даже не поддерживаться разработчиками, но они нужны 
пока предприятию в его процессах).    
```
| Сценарий | Вариант деплоя/запуска |
| --- | --- |
| Высоконагруженное монолитное java веб-приложение; | Виртуальная машина, с ресурсами достаточными для стабильной и быстрой работы такого приложения. Запуск в контейнере может быть нецелесообразен, т.к. может "съесть" ресурсы сервера и не оставить возможности работать параллельно другим контейнерам/приложениям. Альтернативой является запуск на "голом железе" - если риски резервного копирования и обеспечения непрерывной работы каким-то образом решены |
| Nodejs веб-приложение;| Как и любой web-сервис - Идеальный претендент для запуска в контейнере - тестирование облегчается и передача на конечный стенд (заказчику) осуществляется в том же неизменном виде |
| Мобильное приложение c версиями для Android и iOS;| ТАк понимаю речь идет об отладке и тестировании приложения под различные мобильные платформы? К сожалению в контейнере не получится запустить приложение для другой платформы/архитектуры, т.ч. нужна "полноценная" виртуализация для работы таких эмуляторов, либо использовать непосредственно устройство, подключенное к компьютеру разработчика для отладки работы приложения |
| Шина данных на базе Apache Kafka;| Не знаю что это такое, но судя по описанию из википедии и того, что это "шина данных" - такой сервис должен нативно поддерживать работу в параллельном режиме - различными агентами выполняя свою определенную задачу и поддерживая масштабирование путем увеличения соответствующих агентов. Если все это так, то контейнеризация должна быть в основе архитектуры подобного сервиса/приложения, как мне кажется. Возможно некоторые элементы системы сами по себе должны быть запущены на базе "полноценной ВМ", но в целом подобные решения скорее всего работают именно в виртуальных машинах и контейнерах, но не на "голом железе"|
| Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;| У нас на работе подобная конфигурация работает на базе "полноценных ВМ", но в docker hub есть официальный контейнер для Эластика и, думаю, что сервисы этого стека также вполне можно запускать в контейнерах |
| Мониторинг-стек на базе Prometheus и Grafana;| Также как и в прошлом случае - есть готовые официальные контейнеры и пожалуй проще всего реализовать работу данной связки именно из контейнеров |
| MongoDB, как основное хранилище данных для java-приложения;| Ранее было принято считать, что для серверов БД виртуализация плохо подходит и они должны работать на своем высокопроизводительном железе - не нужны замедления из-за издержек на виртуализацию, а также самое главное - работа с подсистемой ввода-вывода может быть не максимально эффективной при работе через гипервизор (особенно, когда один накопитель/массив исполщуется не только для нужд сервера БД, но и для работы других ВМ). Но в последнее время уже стало нормой запускать такие сервера БД в "своих ВМ" с выделенным высокопроизводительным хранилищем и с получением всех выгод от виртуализации, т.ч. я "голосую" за "полноценную ВМ". |
| Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.| Технически, мне кажется, не должно быть проблем запустить и GitLab и собственный репозиторий в виде контейнеров - это не должны быть тяжеловесные приложения и наверняка уже есть готовые решения, которые можно достаточно просто и быстро начать использовать. Но, как запасной вариант, который "точно будет работать" - реализовать работу данных сервисов в "полноценных ВМ" и к ним, хотя бы частично добавить запуск агентов того же GitLab в контейнерах - при необходимости/выполнении того или иного задания, то есть как минимум - гибридный режим работы. |

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```answer3
Если запускать контейнер просто по имени, то он почти сразу 
завершает свою работу, т.к. такие базовые образы не содержат в 
себе команду на запуск интерпретатора, например. Поэтому к 
параметрам запуска добавил необходимость работы в интерактивном 
режиме и запуска команды /bin/bash с переходом к работе в фоне. 
```
```bash
ubuntu@vm1-amd-1-1:~$ sudo docker run -d -t -i -v /data:/data --name CentOSContainer centos /bin/bash
d0879f1210e7ff7c34958015992a7f08fe8e156198625b82387343c63cb066f4
ubuntu@vm1-amd-1-1:~$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
d0879f1210e7   centos    "/bin/bash"   7 seconds ago   Up 5 seconds             CentOSContainer
ubuntu@vm1-amd-1-1:~$ sudo docker run -d -t -i -v /data:/data --name DebianContainer debian /bin/bash
ac45a96e02b15227e50eec7947de37e663989752b75c89a9d6075f1445820cf0
ubuntu@vm1-amd-1-1:~$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
ac45a96e02b1   debian    "/bin/bash"   5 seconds ago    Up 3 seconds              DebianContainer
d0879f1210e7   centos    "/bin/bash"   46 seconds ago   Up 44 seconds             CentOSContainer
ubuntu@vm1-amd-1-1:~$
ubuntu@vm1-amd-1-1:~$ sudo docker exec -it CentOSContainer touch /data/FileCreatedInCentOSContainer.txt
ubuntu@vm1-amd-1-1:~$ touch /data/FileCreatedOnHostDirectly.txt
touch: cannot touch '/data/FileCreatedOnHostDirectly.txt': Permission denied
ubuntu@vm1-amd-1-1:~$ sudo touch /data/FileCreatedOnHostDirectly.txt
ubuntu@vm1-amd-1-1:~$
ubuntu@vm1-amd-1-1:~$ sudo docker exec -it DebianContainer /bin/bash
root@ac45a96e02b1:/# ls -la /data/
total 8
drwxr-xr-x 2 root root 4096 Jan 23 10:43 .
drwxr-xr-x 1 root root 4096 Jan 23 10:39 ..
-rw-r--r-- 1 root root    0 Jan 23 10:42 FileCreatedInCentOSContainer.txt
-rw-r--r-- 1 root root    0 Jan 23 10:43 FileCreatedOnHostDirectly.txt
root@ac45a96e02b1:/#
ubuntu@vm1-amd-1-1:~$ sudo docker stop CentOSContainer
CentOSContainer
ubuntu@vm1-amd-1-1:~$ sudo docker stop DebianContainer
DebianContainer
ubuntu@vm1-amd-1-1:~$ sudo docker ps -a
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS                       PORTS     NAMES
ac45a96e02b1   debian    "/bin/bash"   10 minutes ago   Exited (137) 7 seconds ago             DebianContainer
d0879f1210e7   centos    "/bin/bash"   10 minutes ago   Exited (0) 23 seconds ago              CentOSContainer
ubuntu@vm1-amd-1-1:~$ ls -la /data/
total 8
drwxr-xr-x  2 root root 4096 Jan 23 10:43 .
drwxr-xr-x 20 root root 4096 Jan 23 10:26 ..
-rw-r--r--  1 root root    0 Jan 23 10:42 FileCreatedInCentOSContainer.txt
-rw-r--r--  1 root root    0 Jan 23 10:43 FileCreatedOnHostDirectly.txt
ubuntu@vm1-amd-1-1:~$

```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

```answer4-1
        Используя предложенный Dockerfile запустил команду, которая 
        отработала за несколько минут и создала локальный образ на моем 
        сервере, после чего запушил его в свой публичный репозиторий.
        
        Данный образ доступен для всех по команде
        docker pull bvmspb/ansible:2.9.24
```
```bash
        ubuntu@vm1-amd-1-1:~/hwansible$ sudo docker build -t bvmspb/ansible:2.9.24 .
        ubuntu@vm1-amd-1-1:~/hwansible$ sudo docker push bvmspb/ansible:2.9.24
        The push refers to repository [docker.io/bvmspb/ansible]
        91db7e5fc738: Pushed
        4a13b2d92c5f: Pushed
        1a058d5342cc: Mounted from library/alpine
        2.9.24: digest: sha256:f45d884813130ce428020e8708871679060eedb0022631305d9d9e885affcb37 size: 947
```

---

