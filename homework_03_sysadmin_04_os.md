# devops-netology DEVSYS-PDC-2

##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir

###DEVSYS-PDC-2 sysadmin 03.04 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «3.4. Операционные системы, лекция 2»

# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

```answer2
Уточнение первого вопроса после доработки. Запрос на доработку звучит так:
   Задание 1
   Предлагаю уточнить как именно в службу будут передаваться дополнительные опции. Примеры можно посмотреть вот здесь:
   www.freedesktop.org...ExecStart=
   unix.stackexchange.com...unit-files
   stackoverflow.com...-unit-file
   
   С уважением,
   Алексей

Дополняю информацию здесь же, остальной ответ остается полностью валидным - оставляю его отдельно, как есть.

##Уточнение по возможности передать параметры процессу через внешний файл.

В конфигурационном файле юнита я прописал путь к файлу с переменными среды окружения:
   EnvironmentFile=/etc/default/node_exporter
В этом текстовом файле /etc/default/node_exporter можно задать любой набор переменных 
среды окружения, которые будут считаны systemd непосредственно перед запуском команды,
описанной в  ExecStart. Все эти переменные будут доступны процессу после запуска.
В том числе можно запускать не непосредственно исполнимую программу, а скрипт командной 
оболочки (через bash -c ...), в котором выстроить необходимую логику, опирающуюся на те 
или иные значения переменных окружения, например.
 
Более того, как я вычитал в советах из приведенных ссылок и еще в 
https://stackoverflow.com/questions/42835750/systemd-script-environment-file-updated-by-execstartpre/42841480#42841480
Что возможно уточнить-дополнить-сформировать данный файл /etc/default/node_exporter при
помощи отдельной команды из ExecStartPre= - которая отработает еще до запуска ExecStart и 
сможет наполнить файл нужными значениями переменных непосредственно перед запуском команды 
из ExecStart.
Альтернативой такому способу является настройка двух отдельных сервисов - второй поставить 
в зависимость от первого (то есть второй будет запускаться после успешного запуска/отработки
первого сервиса). При этом первый сервис будет отвечать за наполнение файла с переменными
окружения, который будет использоваться уже вторым (прописан в unit-файле в EnvironmentFile=)  

```

```answer1
      Согласно инструкции от автора:
      Скачал пакет со скомпилированным приложением под свою архитектуру:
         vagrant@vagrant:/opt$ sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.0/node_exporter-1.3.0.linux-amd64.tar.gz
      
      Распаковал в /opt (под sudo):
         vagrant@vagrant:/opt$ sudo tar xvfz node_exporter-*.*-amd64.tar.gz
      
      Создал симлинк на директорию с последней скачанной версией, 
      чтобы в сервисе для автозагрузки прописать статичный путь для запуска 
      и не обновлять его каждый раз после возможного обновления в будущем:
          vagrant@vagrant:~$ sudo ln -s /opt/node_exporter-1.3.0.linux-amd64/ /opt/node_exporter
      
      Подготовил пустой файл для передачи параметров сервису в будущем, 
      если потребуется изменить конфиг без перезапуска сервиса:
         echo "#default config file for node_exporter" | sudo tee /etc/default/node_exporter
      
      Создал конфигурационный файл для службы node_exporter:
         vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service
         [Unit]
         Description=Node Exporter
         
         [Service]
         ExecStart=/opt/node_exporter/node_exporter
         EnvironmentFile=/etc/default/node_exporter
         
         [Install]
         WantedBy=default.target
      
      Включил автозапуск новой службы:
         vagrant@vagrant:/opt/node_exporter$ sudo systemctl enable node_exporter
         Created symlink /etc/systemd/system/default.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
      
      Далее сам запустил службу и проверил статус ее выполнения:
         vagrant@vagrant:/opt/node_exporter$ sudo systemctl start node_exporter
         vagrant@vagrant:/opt/node_exporter$ sudo systemctl status node_exporter
         ● node_exporter.service - Node Exporter
              Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
              Active: active (running) since Sun 2021-11-21 14:22:08 UTC; 7s ago
            Main PID: 5894 (node_exporter)
               Tasks: 4 (limit: 1071)
              Memory: 2.4M
              CGroup: /system.slice/node_exporter.service
                      └─5894 /opt/node_exporter/node_exporter
      
      Удостоверился, что сервис работает и сама выгрузка доступна по адресу localhost:9100/metrics командой:
         vagrant@vagrant:~$ curl localhost:9100/metrics | grep -v '^#' | grep node_ 
      
      Также вижу процесс при помощи команды ps:
         vagrant@vagrant:~$ ps -aux | grep node_exporter
         root        5894  0.0  1.6 717372 16820 ?        Ssl  14:22   0:00 /opt/node_exporter/node_exporter
      
      Далее остановил сервис и также перепроверил в ps:
         vagrant@vagrant:~$ sudo systemctl stop node_exporter
         vagrant@vagrant:~$ sudo systemctl status node_exporter
         ● node_exporter.service - Node Exporter
              Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
              Active: inactive (dead) since Sun 2021-11-21 14:30:25 UTC; 8s ago
             Process: 5894 ExecStart=/opt/node_exporter/node_exporter (code=killed, signal=TERM)
            Main PID: 5894 (code=killed, signal=TERM)
         
         Nov 21 14:22:08 vagrant node_exporter[5894]: ts=2021-11-21T14:22:08.842Z caller=node_exporter.go:115 level=info collect>
         Nov 21 14:22:08 vagrant node_exporter[5894]: ts=2021-11-21T14:22:08.842Z caller=node_exporter.go:115 level=info collect>
         Nov 21 14:22:08 vagrant node_exporter[5894]: ts=2021-11-21T14:22:08.842Z caller=node_exporter.go:115 level=info collect>
         Nov 21 14:22:08 vagrant node_exporter[5894]: ts=2021-11-21T14:22:08.843Z caller=node_exporter.go:115 level=info collect>
         Nov 21 14:22:08 vagrant node_exporter[5894]: ts=2021-11-21T14:22:08.843Z caller=node_exporter.go:115 level=info collect>
         Nov 21 14:22:08 vagrant node_exporter[5894]: ts=2021-11-21T14:22:08.843Z caller=node_exporter.go:199 level=info msg="Li>
         Nov 21 14:22:08 vagrant node_exporter[5894]: ts=2021-11-21T14:22:08.844Z caller=tls_config.go:195 level=info msg="TLS i>
         Nov 21 14:30:25 vagrant systemd[1]: Stopping Node Exporter...
         Nov 21 14:30:25 vagrant systemd[1]: node_exporter.service: Succeeded.
         Nov 21 14:30:25 vagrant systemd[1]: Stopped Node Exporter.
      
      Последним шагом выключил VM полностью (vagrant halt) и перезапустил снова (vagrant up), 
      чтобы удостовериться, что служба будет запускаться автоматически при запуске системы. 
         vagrant@vagrant:~$ sudo systemctl status node_exporter
         ● node_exporter.service - Node Exporter
              Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
              Active: active (running) since Sun 2021-11-21 14:34:08 UTC; 45s ago
            Main PID: 586 (node_exporter)
               Tasks: 4 (limit: 1071)
              Memory: 14.5M
              CGroup: /system.slice/node_exporter.service
                      └─586 /opt/node_exporter/node_exporter
```

2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

```answer
      Через grep искал соответствующую информацию в выводе curl, например:
         curl localhost:9100/metrics | grep cpu
      
      CPU (два ядра в виртуальной машине - для каждого свои счетчики):
         node_cpu_seconds_total{cpu="0",mode="idle"} 562.33
         node_cpu_seconds_total{cpu="0",mode="iowait"} 1.01
         node_cpu_seconds_total{cpu="0",mode="irq"} 0
         node_cpu_seconds_total{cpu="0",mode="nice"} 0
         node_cpu_seconds_total{cpu="0",mode="softirq"} 1.06
         node_cpu_seconds_total{cpu="0",mode="steal"} 0
         node_cpu_seconds_total{cpu="0",mode="system"} 9.51
         node_cpu_seconds_total{cpu="0",mode="user"} 5.14
         node_cpu_seconds_total{cpu="1",mode="idle"} 486.4
         node_cpu_seconds_total{cpu="1",mode="iowait"} 0.55
         node_cpu_seconds_total{cpu="1",mode="irq"} 0
         node_cpu_seconds_total{cpu="1",mode="nice"} 0
         node_cpu_seconds_total{cpu="1",mode="softirq"} 3.45
         node_cpu_seconds_total{cpu="1",mode="steal"} 0
         node_cpu_seconds_total{cpu="1",mode="system"} 12.13
         node_cpu_seconds_total{cpu="1",mode="user"} 2.32
      
      Самый добный "обощенный" счетчик для User и System счетчиков:
         process_cpu_seconds_total 0.44
      
      MEMORY:
         # HELP node_memory_MemTotal_bytes Memory information field MemTotal_bytes.
         # TYPE node_memory_MemTotal_bytes gauge
         node_memory_MemTotal_bytes 1.028694016e+09
         # HELP node_memory_MemAvailable_bytes Memory information field MemAvailable_bytes.
         # TYPE node_memory_MemAvailable_bytes gauge
         node_memory_MemAvailable_bytes 7.61135104e+08
         # HELP node_memory_MemFree_bytes Memory information field MemFree_bytes.
         # TYPE node_memory_MemFree_bytes gauge
         node_memory_MemFree_bytes 6.43039232e+08
         # HELP node_memory_SwapFree_bytes Memory information field SwapFree_bytes.
         # TYPE node_memory_SwapFree_bytes gauge
         node_memory_SwapFree_bytes 1.027600384e+09
         # HELP node_memory_SwapTotal_bytes Memory information field SwapTotal_bytes.
         # TYPE node_memory_SwapTotal_bytes gauge
         node_memory_SwapTotal_bytes 1.027600384e+09
      
      DISK:
         # HELP node_disk_io_time_seconds_total Total seconds spent doing I/Os.
         # TYPE node_disk_io_time_seconds_total counter
         node_disk_io_time_seconds_total{device="dm-0"} 12.252
         node_disk_io_time_seconds_total{device="dm-1"} 0.248
         node_disk_io_time_seconds_total{device="sda"} 12.732000000000001
         # HELP node_disk_read_bytes_total The total number of bytes read successfully.
         # TYPE node_disk_read_bytes_total counter
         node_disk_read_bytes_total{device="dm-0"} 2.39379456e+08
         node_disk_read_bytes_total{device="dm-1"} 3.342336e+06
         node_disk_read_bytes_total{device="sda"} 2.53146112e+08
         # HELP node_disk_read_time_seconds_total The total number of seconds spent by all reads.
         # TYPE node_disk_read_time_seconds_total counter
         node_disk_read_time_seconds_total{device="dm-0"} 20.68
         node_disk_read_time_seconds_total{device="dm-1"} 0.244
         node_disk_read_time_seconds_total{device="sda"} 10.673
         # HELP node_disk_reads_completed_total The total number of reads completed successfully.
         # TYPE node_disk_reads_completed_total counter
         node_disk_reads_completed_total{device="dm-0"} 8020
         node_disk_reads_completed_total{device="dm-1"} 146
         node_disk_reads_completed_total{device="sda"} 5198
         # HELP node_disk_write_time_seconds_total This is the total number of seconds spent by all writes.
         # TYPE node_disk_write_time_seconds_total counter
         node_disk_write_time_seconds_total{device="dm-0"} 6.28
         node_disk_write_time_seconds_total{device="dm-1"} 0
         node_disk_write_time_seconds_total{device="sda"} 4.225
         # HELP node_disk_writes_completed_total The total number of writes completed successfully.
         # TYPE node_disk_writes_completed_total counter
         node_disk_writes_completed_total{device="dm-0"} 2206
         node_disk_writes_completed_total{device="dm-1"} 0
         node_disk_writes_completed_total{device="sda"} 1529
         # HELP node_disk_written_bytes_total The total number of bytes written successfully.
         # TYPE node_disk_written_bytes_total counter
         node_disk_written_bytes_total{device="dm-0"} 1.6515072e+07
         node_disk_written_bytes_total{device="dm-1"} 0
         node_disk_written_bytes_total{device="sda"} 1.6319488e+07
      
      NETWORK:
         # HELP node_network_receive_bytes_total Network device statistic receive_bytes.
         # TYPE node_network_receive_bytes_total counter
         node_network_receive_bytes_total{device="eth0"} 1.042562e+06
         # HELP node_network_receive_errs_total Network device statistic receive_errs.
         # TYPE node_network_receive_errs_total counter
         node_network_receive_errs_total{device="eth0"} 0
         # HELP node_network_receive_packets_total Network device statistic receive_packets.
         # TYPE node_network_receive_packets_total counter
         node_network_receive_packets_total{device="eth0"} 2071
         # HELP node_network_transmit_bytes_total Network device statistic transmit_bytes.
         # TYPE node_network_transmit_bytes_total counter
         node_network_transmit_bytes_total{device="eth0"} 150941
         # HELP node_network_transmit_errs_total Network device statistic transmit_errs.
         # TYPE node_network_transmit_errs_total counter
         node_network_transmit_errs_total{device="eth0"} 0
         # HELP node_network_transmit_packets_total Network device statistic transmit_packets.
         # TYPE node_network_transmit_packets_total counter
         node_network_transmit_packets_total{device="eth0"} 1019
```

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

```answer
      Открылась красивая графическая панель с информацией об использовании/нагрузке:
      Used swap, Disk read, Disk Write, CPU%, Net inbound, Net Outbound, Used RAM
      
      Есть возможность посмотреть графики показывающие динамику изменения того или иного 
      отслеживаемого параметра во времени - при наведении мыши на любом из графиков на 
      определенное интересующее время - одновременно подсвечивается тот же временной 
      промежуток на всех графиках и в заголовке страницы отображаются значения 
      для всех отслеживаемых параметров в выбранное время.
      
      Также я добавил в пробрасываемые порты vagrant и 9100 порт - есть доступ 
      и к выводу от node_exporter'а.  
```

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

```answer
      Да, видно, что ядро "понимает" в какой среде оно загружается.
      Вот вывод в VM, запущенной при помощи vagrant на VirtualBox:
         vagrant@vagrant:~$ dmesg | grep virtual
         [    0.007822] CPU MTRRs all blank - virtualized system.
         [    0.065611] Booting paravirtualized kernel on KVM
         [   27.119929] systemd[1]: Detected virtualization oracle.
      
      А вот вывод в wsl2 с такой же Ubuntu 20.04:
         bvm@RU1L0605:/mnt/c/Users/vbaksheev$ dmesg | grep virtual
         [    0.000057] CPU MTRRs all blank - virtualized system.
         [    0.057256] Booting paravirtualized kernel on Hyper-V
```

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

```answer
      nr_open - жесткий лимит на открытые дескрипторы - настройка на уровне ядра:
         vagrant@vagrant:~$ sudo sysctl -a | grep fs.nr_open
         fs.nr_open = 1048576
      
      При этом в ulimit видно, что для каждого процесса утсановлено ограничение на 
      количество открытых файлов по умолчанию 1024:
         vagrant@vagrant:~$ ulimit --help | grep file
         ...
               -n        the maximum number of open file descriptors
         vagrant@vagrant:~$ ulimit -a | grep files
         open files                      (-n) 1024
      
      То есть один процесс не сможет исчерпать общий системный лимит 
      открытых файловых дескрипторов.
      Пользовательские лимиты не могут быть заданы значением больше системных.
```

6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

```answer
      Запускаю команду "спать/ждать один час" в новом изолированном нэймспейсе:
         root@vagrant:~# unshare -f -p --mount-proc /usr/bin/sleep 1h
      После чего этот запущенный процесс остается запущенным (на один час).
      
      В другой сессии могу найти этот процесс, запущенный под root'ом, который выполняется в фоне:
         vagrant@vagrant:~$ ps -aux |grep sleep
         root        1638  0.0  0.0   8080   528 pts/0    S+   15:47   0:00 unshare -f -p --mount-proc /usr/bin/sleep 1h
         root        1639  0.0  0.0   8076   596 pts/0    S+   15:47   0:00 /usr/bin/sleep 1h
      
      При этом можно загрузить контекст этого работающего/спящего процесса (1639) 
      и увидеть, что для него первым процессом (PID 1) была собственно его команда запуска (а не init):
         vagrant@vagrant:~$ sudo nsenter -a -t 1639 ps aux
         USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
         root           1  0.0  0.0   8076   596 pts/0    S+   15:47   0:00 /usr/bin/sleep 1h
         root           3  0.0  0.3  11492  3444 pts/1    R+   15:54   0:00 ps aux
```

7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

```answer
Поиск в Интернет дает название для этой команды - fork_bomb. 
После чего становится понятно, что это записана функция с именем ":", которая 
запускает саму себя и конвеером снова себя, после чего уходит в фон и вызывает себя 
(далее по рекурсии будет снова и снова вызывать себя). По всей видимости будут 
созданы новые и новые процессы при каждом запуске такой функции, что должно привести к исчерпанию системных ресурсов, если не иметь лимитов-ограничений на допустимое количество создаваемых пользователем процессов. У ulimit есть параметр -г, который как раз за это должен отвечать. Вот значение на VM vagrant у меня:
   vagrant@vagrant:~$ ulimit --help | grep \\-u
         -u        the maximum number of user processes
   vagrant@vagrant:~$ ulimit -u
   3571

Вот как можно ее отформатировать и заменить название на более привычное 
(вместо двоеточия запишу funcname), чтобы легче читалось:
funcname()
   { funcname|funcname& };
funcname 

После запуска обе активные сессии перестали реагировать на попытки что-либо запустить в них что-нибудь. На экране в сессии, где запустил эту "бомбу" выдаелось что-то вроде:
   -bash: fork: Resource temporarily unavailable
   -bash: fork: retry: Resource temporarily unavailable
   -bash: fork: Resource temporarily unavailable

Когда смог подключиться непосредственно на терминальную консоль tty1 через сам Virtual Box, 
то смог залогиться и выполнить команду dmesg -T, где нашел следующую запись, 
которая и связана с исчерпанием доступных лимитов, судя по всему:
   [Sun Nov 21 16:15:39 2021] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-10.scope
   [Sun Nov 21 16:23:01 2021] watchdog: BUG: soft lockup - CPU#1 stuck for 409s! [bash:4101]``` 
 
 ---
