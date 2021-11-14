# devops-netology DEVSYS-PDC-2

##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir

###DEVSYS-PDC-2 sysadmin 03.02 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «3.2. Работа в терминале, лекция 2»


# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.  

```answer
    Согласно "type -a cd" это встроенная команда shell:  
        vagrant@vagrant:~$ type -a cd
        cd is a shell builtin
    
    Так как вызываем эту команду мы для смены текущей директории именно работая в shell - сделать ее встроенной командой
    кажется наиболее оптимальным подходом. Иначе, если бы это была внешняя команда/утилита, то ее запуск порождал бы 
    (создавал) новый процесс со своим окружением и смена дирректории происходила бы уже в нем, а значит из него нужно было 
    бы запускать новый экземпляр shell в новой рабочей директории, что совсем неэффективно с точки зрения расходования 
    системных ресурсов на каждый такой процесс. 
```

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

```answer
   Согласно man wc - данная команда с параметром -l используется для подсчета количества строк ("print the newline 
   counts"). Аналогичный результат можно получить напрямую от команды grep, используя параметр -c (--count), то есть 
   итоговая команда выглядела бы следующим образом:
        grep --count <some_string> <some_file>
   
   Таким образом будет создан только один процесс для утилиты grep, который не только выполнит поиск по заданному 
   шаблону, но и выведет в итоге количество найденных строк без необходимости дополнительного вызова другой утилиты 
   (и создания процесса под нее тоже).
   Общий вывод такой, что необходимо эффективно использовать ресурсы системы и по возможности умело использовать 
   доступный функционал, без вызова "лишних" дополнительных внешних утилит. 
```

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

```answer
    согласно ps -aux процесс с pid 1 запускается командой /sbin/init:
        vagrant@vagrant:~$ ps -aux
        USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
        root           1  0.1  1.1 101816 11140 ?        Ss   13:19   0:04 /sbin/init
    pstree -ap говорит нам, что это процесс systemd:
        vagrant@vagrant:~$ pstree -ap
        systemd,1
        ├─VBoxService,795 --pidfile /var/run/vboxadd-service.sh
        │   ├─{VBoxService},797
    
    В WSL (тоже Ubuntu 20.04), кстати, вывод pstree выглядит несколько иначе, но сути это не меняет:
        root@RU1L0605:/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology# pstree -pa
        init,1
          ├─init,8
          │   └─init,9
          │       └─bash,10
          │           └─bash,100
          │               └─sudo,116 bash
          │                   └─bash,117
          │                       └─bash,124
          │                           └─pstree,177 -pa
          └─{init},6
      
    Процесс с идентификтором 1 запускается первым после загрузки/инициализции ядра системы и в целом отвечает за запуск 
    и выключение системы. Все процессы в системе будут запускаться после этого первого процесса.
```

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

```answer
    Сначала кратко ответ - сама команда с перенаправлением вывода stderr:
        ls -la /dev/pts/unknownpath 2>/dev/pts/1
        
    Далее объяснение:
    До тех пор пока я был подключен через ssh в единственной сессии - мой терминал был 0 и единственный:
        vagrant@vagrant:~$ tty
        /dev/pts/0
        vagrant@vagrant:~$ ls -la /dev/pts/
        total 0
        drwxr-xr-x  2 root    root      0 Nov 14 13:19 .
        drwxr-xr-x 18 root    root   3980 Nov 14 13:22 ..
        crw--w----  1 vagrant tty  136, 0 Nov 14 14:14 0
        c---------  1 root    root   5, 2 Nov 14 13:19 ptmx

    Как только я параллельно подключился в соседнем окне еще одной сессией (командой vagrant ssh), то там у меня 
    терминал уже стал 1 и общий список выглядит так:
        vagrant@vagrant:~$ ls -la /dev/pts/
        total 0
        drwxr-xr-x  2 root    root      0 Nov 14 13:19 .
        drwxr-xr-x 18 root    root   3980 Nov 14 13:22 ..
        crw--w----  1 vagrant tty  136, 0 Nov 14 14:15 0
        crw--w----  1 vagrant tty  136, 1 Nov 14 14:14 1
        c---------  1 root    root   5, 2 Nov 14 13:19 ptmx
    
    Далее я на терминале 0 вызываю команду, которая заведомо вернет ошибку (так как такого пути нет), а ее stderr вывод
    перенаправляю на /dev/pts/1, то есть терминал 1:
         vagrant@vagrant:~$ ls -la /dev/pts/unknownpath 2>/dev/pts/1
    При этом на экране 0 терминала после запуска ничего не выводится, а прямо на 1 терминале появляется сообщение об
    ошибке от данной команды:
        vagrant@vagrant:~$ ls: cannot access '/dev/pts/unknownpath': No such file or directory
        
```

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

```answer
    Использую 0< для перенаправления stdin (читаю из файла file1.txt) и 1> для перенаправления stdout в файл file2.txt.
    Предварительно создал файл file1.txt путем перенаправления в него вывода команды ls:
        vagrant@vagrant:~$ ls -al >file1.txt
        vagrant@vagrant:~$ cat file1.txt
        total 64
        drwxr-xr-x 9 vagrant vagrant 4096 Nov 14 14:29 .
        drwxr-xr-x 3 root    root    4096 Jul 28 17:50 ..
        -rw------- 1 vagrant vagrant  249 Nov 10 19:51 .bash_history
        -rw-r--r-- 1 vagrant vagrant  220 Jul 28 17:50 .bash_logout
        -rw-r--r-- 1 vagrant vagrant 3771 Jul 28 17:50 .bashrc
        drwx------ 2 vagrant vagrant 4096 Jul 28 17:51 .cache
        -rw-rw-r-- 1 vagrant vagrant    0 Nov 14 14:29 file1.txt
        -rw------- 1 vagrant vagrant  109 Nov 14 13:45 .lesshst
        -rw-r--r-- 1 vagrant vagrant  807 Jul 28 17:50 .profile
        drwx------ 2 vagrant root    4096 Nov 10 18:23 .ssh
        -rw-r--r-- 1 vagrant vagrant    0 Jul 28 17:51 .sudo_as_admin_successful
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp1
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp2
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp3
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp4
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp5
        -rw-r--r-- 1 vagrant vagrant    6 Jul 28 17:51 .vbox_version
        -rw-r--r-- 1 root    root     180 Jul 28 17:55 .wget-hsts
        vagrant@vagrant:~$ cat 0<file1.txt 1>file2.txt
        vagrant@vagrant:~$ ls -l
        total 28
        -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:29 file1.txt
        -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:30 file2.txt
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp1
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp2
        
        total 64
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp3
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp4
        drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp5
        
        Вот содержимое file2.txt (оно аналот=гично file1.txt, как и задумывалось):
            vagrant@vagrant:~$ cat file2.txt
            total 64
            drwxr-xr-x 9 vagrant vagrant 4096 Nov 14 14:29 .
            drwxr-xr-x 3 root    root    4096 Jul 28 17:50 ..
            -rw------- 1 vagrant vagrant  249 Nov 10 19:51 .bash_history
            -rw-r--r-- 1 vagrant vagrant  220 Jul 28 17:50 .bash_logout
            -rw-r--r-- 1 vagrant vagrant 3771 Jul 28 17:50 .bashrc
            drwx------ 2 vagrant vagrant 4096 Jul 28 17:51 .cache
            -rw-rw-r-- 1 vagrant vagrant    0 Nov 14 14:29 file1.txt
            -rw------- 1 vagrant vagrant  109 Nov 14 13:45 .lesshst
            -rw-r--r-- 1 vagrant vagrant  807 Jul 28 17:50 .profile
            drwx------ 2 vagrant root    4096 Nov 10 18:23 .ssh
            -rw-r--r-- 1 vagrant vagrant    0 Jul 28 17:51 .sudo_as_admin_successful
            drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp1
            drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp2
            drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp3
            drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp4
            drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp5
            -rw-r--r-- 1 vagrant vagrant    6 Jul 28 17:51 .vbox_version
            -rw-r--r-- 1 root    root     180 Jul 28 17:55 .wget-hsts
```

6. Получится ли вывести находясь в графическом режиме данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

```answer
    Технически псевдотерминалы (pts) не отличаются от "обычных" терминалов (tty), так что попробовать перенаправить 
    вывод команды на любой из них возможно, но во-первых, это требует наличия прав (так как терминал TTY не связан с 
    нашим пользователем и это требует поднятия привилегий до уровня root'а, а во-вторых, чтобы увидеть перенаправленный
    вывод - необходимо физическое подключение к машине и выбор соответствующего терминала комбинацией клавиш 
    Ctrl+Alt+F3 (для tty3), либо запустив гипервизор (в нашем случае в vagrant и VB - VirtualBox) через него получить 
    доступ к консоли, где и выбрать требуемый терминал.
      
    Вот как будет выглядеть вывод из под обычного пользователя и из под root'а, соответственно:
        vagrant@vagrant:~$ echo "Hello from /dev/pts/0" >/dev/tty3
        -bash: /dev/tty3: Permission denied
        vagrant@vagrant:~$ sudo su
        root@vagrant:/home/vagrant# echo "Hello from pts/0" >/dev/tty3

    Сам же вывод на /dev/tty3 можно увидеть непосредственно в VirtualBox, подключившись к консоли и переключившись с помощью Ctrl+Alt+F3
```

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

```answer
    Первой командой мы запустили еще один процесс с bash shell для которого создали еще один файловый дескриптор, 
    доступный по номеру 5, который перенаправляет в stdout все, что на него попадает.
    Второй командой мы перенаправляем в файловый дескриптор (5) стандартный вывод команды echo, который попадает на 
    stdout процесса shell, т.к. ранее он был создан с таким перенаправлением.
    
    Вот результаты вывода команд:
        vagrant@vagrant:~$ bash 5>&1
        vagrant@vagrant:~$ echo netology > /proc/$$/fd/5
        netology

    А вот какие есть файловые дескрипторы у текущего процесса:
        vagrant@vagrant:~$ ls /proc/$$/fd/ -la
        total 0
        dr-x------ 2 vagrant vagrant  0 Nov 14 15:01 .
        dr-xr-xr-x 9 vagrant vagrant  0 Nov 14 15:01 ..
        lrwx------ 1 vagrant vagrant 64 Nov 14 15:08 0 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 14 15:08 1 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 14 15:08 2 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 14 15:08 255 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 14 15:01 5 -> /dev/pts/0 
```

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

```answer
    Команда, с последовательным перенаправлением использующая промежуточный дополнительный файловый дескриптор, которая
    передает поток stderr через pipe (вместо стандартного stdout):
        vagrant@vagrant:~$ ls -l /proc/dddd 22>&2 2>&1 1>&22 | grep "l"
        ls: cannot access '/proc/dddd': No such file or directory        

    22>&2 - Создали дополнительный файловый дескриптор для данного процесса ls (и всех его дочерних процессов), который
    перенаправляет все, что на него поступает в stderr
    2>&1 - Перенаправляет stderr в stdout
    1>&22 - Перенаправляет вывод stdout в новый файловый дескриптор, связанный с stderr 
        
    Так как результатом работы ls стала ошибка - ее вывод в stderr был перенапрвлен через pipe на вход для grep.
    Если в аргументе команды ls -l указать реальный существующий путь, а не ошибочный, то результат ее выдачи не попадет
    через pipe в grep на вход, но будет выведен на экран.   
```

9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

```answer
    Команда выводит переменные окружения текущего процесса shell с их значениями.
    Альтернативным вариантом является использование команды:
        env
    
    Еще можно попробовать посмотреть значение переменных окружения для конкретного PID при помощи команды (с 
    перенаправлением вывода в файл):
        ps e -p $$ >env_$$
    В таком виде инормация также будет выдана для текущего процесса shell (из под которого зупущена команда)
```

10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

```answer
    /proc/[pid]/cmdline - содержит полный путь командной строки запуска данного процесса (задается в [PID]). Строка 210
    /proc/[pid]/exe - является символической ссылкой на исполнимый файл данного процесса. Возможно даже запустить ту же
    самую команду просто набрав ее как команду, например, "/proc/$$/exe" запустит еще один bash у меня.
```

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

```answer
    Судя по:
        cat /proc/cpuinfo | grep sse
    самая старшая версия у моего процессора sse4_2
```

12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

     ```bash
     vagrant@netology1:~$ ssh localhost 'tty'
     not a tty
     ```

     Почитайте, почему так происходит, и как изменить поведение.

```answer
    По умолчанию, когда ssh подключается не в интерактивном режиме (удаленная консоль), а для запуска команды на удаленном сервере, то она не связывает сессию с каким-либо tty - работает в таком называемом бинарном режиме, который упрощает передачу данных, например. Если же нужно именно создать связанный с этой сессией терминал, то нужно указать аргумент -t для ssh:
        vagrant@vagrant:/vagrant$ ssh localhost 'tty'
        vagrant@localhost's password:
        not a tty
        vagrant@vagrant:/vagrant$ ssh -t localhost 'tty'
        vagrant@localhost's password:
        /dev/pts/2
        Connection to localhost closed.
        vagrant@vagrant:/vagrant$ tty
        /dev/pts/0
        vagrant@vagrant:/vagrant$ ls /dev/pts/
        0  1  ptmx
```

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.

```answer
    Для начала мне потребовалось установить программу reptyr, т.к. ее не было в моей ВМ с Ubuntu 20.04 LTS:
        sudo apt install reptyr

    Далее, при попытке запустить reptyr PID (с указанием требуемого PID, к которому нужно подключиться), получал ошибку
    из-за настроек безопасности по умолчанию в /etc/sysctl.d/10-ptrace.conf - пришлось отредактировать его и установить: 
        kernel.yama.ptrace_scope = 0
    
    После чего удалось перехватывать работу с процессом из различных терминалов (подключился параллельно в разных окнах для проверки). 
```

14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

```answer
    Перенаправление вывода делает shell, а он у нас запущен не из под sudo - поэтому проблема с доступом.
    
    Команда tee используется для чтения из стандартного потока ввода для одновременного вывода в stdout и в файл,
    указанный параметром при запуске. Так как эту команду мы запускаем из под sudo - у этого процесса есть все
    необходиые права на запись в /root/
```

 
 ---
