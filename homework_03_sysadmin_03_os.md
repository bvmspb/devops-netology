# devops-netology DEVSYS-PDC-2

##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir

###DEVSYS-PDC-2 sysadmin 03.03 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «3.3. Операционные системы, лекция 1»

# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.

```answer
        Изначально много информации выдается о запуске самого bash, но ближе к самому концу виден вызов системной команды
        chdir:
            chdir("/tmp") 
```

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

```answer
        В выводе strace видно попытки открыть следующие файлы (неуспешные, т.к. файлов по этим путям нет - видно стандартные
        места для хранения таких баз локально):
            stat("/home/vagrant/.magic.mgc", 0x7ffe0b696050) = -1 ENOENT (No such file or directory)
            stat("/home/vagrant/.magic", 0x7ffe0b696050) = -1 ENOENT (No such file or directory)
            openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
        Далее идет успешное открытие и считывание данных из /etc/magic 
            stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
        Судя по man file в этом файле возможно добавлять собственное текстовое описание для новых типов файлов.
        
        Далее уже происходит загрузка из стандартной базы знаний для утилиты file:
            openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
```

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

```answer
      Запустил перенаправление случайных данных из /dev/random в файл и оставил работать в фоне (амперсанд в конце команды).
      У него PID 1091:
         vagrant@vagrant:~$ cat /dev/random >./tmp_file_to_be_deleted &
         [1] 1091
      Файл пока пустой - проверю вывод на экран из него:
         vagrant@vagrant:~$ cat ./tmp_file_to_be_deleted
      В запущенных процессах я вижу указанный процесс с pid 1091: 
         vagrant@vagrant:~$ ps al
         F   UID     PID    PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
         4     0     661       1  20   0   8428  1864 -      Ss+  tty1       0:00 /sbin/agetty -o -p -- \u --noclear tt
         0  1000     868     867  20   0   9976  4400 do_wai Ss   pts/0      0:00 -bash
         0  1000     925     924  20   0   9836  4304 poll_s Ss+  pts/1      0:00 -bash
         0  1000    1091     868  20   0   8220   592 random S    pts/0      0:00 cat /dev/random
         0  1000    1094     868  20   0  11412  1164 -      R+   pts/0      0:00 ps al
      Проверим открытые данным процессом файлы и увидим файл /home/vagrant/tmp_file_to_be_deleted связанный с файловым
      дескриптором 1: 
         vagrant@vagrant:~$ lsof -p 1091
         COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
         cat     1091 vagrant  cwd    DIR  253,0     4096 131074 /home/vagrant
         cat     1091 vagrant  rtd    DIR  253,0     4096      2 /
         cat     1091 vagrant  txt    REG  253,0    43416 524324 /usr/bin/cat
         cat     1091 vagrant  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive
         cat     1091 vagrant  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
         cat     1091 vagrant  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
         cat     1091 vagrant    0u   CHR  136,0      0t0      3 /dev/pts/0
         cat     1091 vagrant    1w   REG  253,0        6 131095 /home/vagrant/tmp_file_to_be_deleted
         cat     1091 vagrant    2u   CHR  136,0      0t0      3 /dev/pts/0
         cat     1091 vagrant    3r   CHR    1,8      0t0     10 /dev/random
      К этому моменту в файле уже появились какие-то данные, которые можно вывести на экран:
         vagrant@vagrant:~$ cat ./tmp_file_to_be_deleted
         L□T□6evagrant@vagrant:~$
      Попробуем удалить файл стандартной командой rm:
         vagrant@vagrant:~$ rm -rf ./tmp_file_to_be_deleted
      В списке файлов текущей директории данный файл исчез:
         vagrant@vagrant:~$ ls -l
         total 32
         -rw-rw-r-- 1 vagrant vagrant  545 Nov 14 16:53 env_1130
         -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:29 file1.txt
         -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:40 file2.txt
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp1
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp2
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp3
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp4
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp5
      Но в списке открытых файлов для процесса с PID 1091 он остался (с пометкой deleted):
         vagrant@vagrant:~$ lsof -p 1091
         COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
         cat     1091 vagrant  cwd    DIR  253,0     4096 131074 /home/vagrant
         cat     1091 vagrant  rtd    DIR  253,0     4096      2 /
         cat     1091 vagrant  txt    REG  253,0    43416 524324 /usr/bin/cat
         cat     1091 vagrant  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive
         cat     1091 vagrant  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
         cat     1091 vagrant  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
         cat     1091 vagrant    0u   CHR  136,0      0t0      3 /dev/pts/0
         cat     1091 vagrant    1w   REG  253,0        6 131095 /home/vagrant/tmp_file_to_be_deleted (deleted)
         cat     1091 vagrant    2u   CHR  136,0      0t0      3 /dev/pts/0
         cat     1091 vagrant    3r   CHR    1,8      0t0     10 /dev/random
         vagrant@vagrant:~$ cat /proc/1091/fd/1
         L□T□6e¶\8↔k□vagrant@vagrant:~$
      Так как по заданию послать сигнал или как-то иначе взаимодействовать с процессом мы не можем - я освобождаю место путем перезаписывания содержимого файла из /dev/null:
         vagrant@vagrant:~$ cat /dev/null>/proc/1091/fd/1
      Размер файла можно по-прежнему посмотреть в списке открытых файлов процесса 1091 - было 6 байт, стал 0:
         vagrant@vagrant:~$ lsof -p 1091
         COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
         cat     1091 vagrant  cwd    DIR  253,0     4096 131074 /home/vagrant
         cat     1091 vagrant  rtd    DIR  253,0     4096      2 /
         cat     1091 vagrant  txt    REG  253,0    43416 524324 /usr/bin/cat
         cat     1091 vagrant  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive
         cat     1091 vagrant  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
         cat     1091 vagrant  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
         cat     1091 vagrant    0u   CHR  136,0      0t0      3 /dev/pts/0
         cat     1091 vagrant    1w   REG  253,0        0 131095 /home/vagrant/tmp_file_to_be_deleted (deleted)
         cat     1091 vagrant    2u   CHR  136,0      0t0      3 /dev/pts/0
         cat     1091 vagrant    3r   CHR    1,8      0t0     10 /dev/random
      После чего уже убиваем процесс и уюеждаемся, что ни процесса нет в списке запущенных, ни файла в текущей директории:
         vagrant@vagrant:~$ kill -9 1091
         [1]+  Killed                  cat /dev/random > ./tmp_file_to_be_deleted
         vagrant@vagrant:~$ ps -ux
         USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
         vagrant      838  0.0  0.9  18408  9552 ?        Ss   18:24   0:00 /lib/systemd/systemd --user
         vagrant      839  0.0  0.3 103024  3188 ?        S    18:24   0:00 (sd-pam)
         vagrant      867  0.1  0.6  13956  6400 ?        S    18:24   0:03 sshd: vagrant@pts/0
         vagrant      868  0.0  0.4   9976  4400 pts/0    Ss   18:24   0:00 -bash
         vagrant      924  0.0  0.6  13952  6404 ?        S    18:24   0:00 sshd: vagrant@pts/1
         vagrant      925  0.0  0.4   9836  4304 pts/1    Ss+  18:24   0:00 -bash
         vagrant     1113  0.0  0.3  11680  3560 pts/0    R+   19:01   0:00 ps -ux
         vagrant@vagrant:~$ ls -l
         total 32
         -rw-rw-r-- 1 vagrant vagrant  545 Nov 14 16:53 env_1130
         -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:29 file1.txt
         -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:40 file2.txt
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp1
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp2
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp3
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp4
         drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp5
         vagrant@vagrant:~$
```

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

```answer
      Зомби процессы - процессы, которые завершили свою работу и отправили сигнал об этом своему родительскому
      процессу, который он не смог корректно прочитать/отработать. Таким образом от таких процессов остается только запись в
      таблице процессов, то есть они не используют никакие ресурсы в ОС.
      Такой процесс будет удален из списка процессов после вызова родительским процессом системного вызова wait() для
      корректной обработки/чтения его статуса. 
```

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

```answer
      Указанная утилита у меня не была установлена в ВМ, созданную с помощью vagrant:
         vagrant@vagrant:~$ dpkg -L bpfcc-tools
         dpkg-query: package 'bpfcc-tools' is not installed
      Установил при помощи команды sudo apt install bpfcc-tools
      Запуск утилиты из под обычного пользователя (vagrant) не увенчался успехом, т.к. не хватило прав доступа
         vagrant@vagrant:~$ opensnoop-bpfcc
         modprobe: ERROR: could not insert 'kheaders': Operation not permitted
      Помогло запустить через sudo:
         vagrant@vagrant:~$ sudo opensnoop-bpfcc
         PID    COMM               FD ERR PATH
         796    vminfo              6   0 /var/run/utmp
         572    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
         572    dbus-daemon        18   0 /usr/share/dbus-1/system-services
         572    dbus-daemon        -1   2 /lib/dbus-1/system-services
         572    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
```

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

```answer
      Судя по strace uname -a - используется системный вызов uname():
         uname({sysname="Linux", nodename="vagrant", ...}) = 0
      Далее, чтобы посмотреть man для uname из второй секции мне потребовалось доустановить man pages for posix:
         sudo apt-get install manpages-posix manpages-posix-dev
      После чего уже man uname 2 подсказал, что:
         Part of the utsname information is also accessible  via  /proc/sys/kernel/{ostype,  hostname,  osrelease, 
         version, domainname}.
```

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

```answer
      Символ ; - простой разделитель команд и если его использовать для разделения, например, двух команд, то каждая из них
      будет безусловно запущена по очереди - сначала первая слева, затем вторая.
      Например:
         ls -l ; ps x
      Последовательно выведет список файлов в текущем каталоге, а затем таблицу запущенных процессов.
      
      && - это логический оператор И - то есть вторая команда будет запущена только при условии, что первая завершилась
      успешно - с нулевым кодом завершения.
      Например, в случае, если директория /tmp/unknown не существует, то вторя команда echo не будет выполнена из-за ошибки в
      ходе выполнения cd:
         vagrant@vagrant:~$ cd /tmp/unknown && echo "Hello /tmp/unknown!"
         -bash: cd: /tmp/unknown: No such file or directory
      А вот как будет выглядеть вывод если в первой команде все отработает без ошибок:
         vagrant@vagrant:~$ cd /tmp/ && echo "Hello /tmp/unknown!"
         Hello /tmp/unknown! 
      
      set -e, судя по man set (88 строка), заставляет моментально завершаться выполнение процесса, завершается выполнение
      всех команд из командной строки.
      Таким образом одновременное использование set -e и && кажется избыточным/не имеющим смысла. 
```

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

```answer
      Последовательность параметров, которая, судя по всему, позволяет избежать любых попыток продолжать выполнения скрипта,
      при неуспешном завершении хоть одной команды из тех, что были переданы конвеером в командной строке, а также призвано
      выводить дополнительную отладочную информацию в ходе получения таких ошибок. 
      Вот подробнее о каждом из параметров:
      -e останавливает выполнение команд, если получен код завершения отличный от нулевого в ходе исполнения любой из команд
      в конвеере.
      -u останавливает выполнение и пишет в stderr сообщение об ошибке при попытке сослаться/использовать переменную
      окружения не определенную/заданную ранее в этом же скрипте. ОЧень полезно, чтобы избежать опечаток в имени переменных
      окружения, от которых может зависеть вся логика выполнения скрипта.
      -x предписывает shell'у записывать в stderr каждую команду, которую подошла очередь выполнить. Полезно для отслеживания
      в каком именно виде запускаются команды на выполнение и на каком моесте возникает ошибка, например.
      -o pipefail позволяет передать ненулевой код завершения любой из команд в конвеере в качестве конечного результата
      завершения всей команды, а не только последней команды. По сути, в сочетании с -e не так и важно, т.к. все равно в
      момент возникновения ошибки все последующие команды прерываются и работа завершается.
```

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

```answer
Вывод предложенной команды дает не так много значений:
   vagrant@vagrant:~$ ps -ao stat
   STAT
   S+
   S+
   R+
Таким образом, больше всего процессов в статусе S - interruptible sleep (waiting for an event to complete)
Но, если нужно посмотреть информацию обо всех процессах в системе, то можно попробовать:
   ps -eo stat --sort stat
Который выдаст длинный список из 102 элементов, где:
S,Ss,SN,S<s,SLsl,Ssl,Ss+ занимают 53 строки (больше половины) - процессы, которые хоть и выполняются/запущены, но
ожидают системного события до своего завершения.
I,I< заняли 47 строк - это процессы ядра, которые "простаивают" в режиме ожидания и не нагружают систему в ожидании
своего часа.
```
