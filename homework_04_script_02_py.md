# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 sysadmin 04.02 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «4.2. Использование Python для решения типовых DevOps задач»

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Никакое - получим ошибку "TypeError: unsupported operand type(s) for +: 'int' and 'str'". Нельзя складывать разные типы переменных - нужно использовать приведение (например, сделать из числа строку, чтобы склеить две строки) |
| Как получить для переменной `c` значение 12?  | Используем приведение к строковому типу для переменной a: c = str(a) + b Либо непосредственно задать значение переменной как строку (a= '1'), тогда c = a + b сработает успешно (12) |
| Как получить для переменной `c` значение 3?  | Использовать приведение типа к числовому для строковой переменной b: c = a + int(b) Либо задать значение переменной числом, а не строкой (b = 2), тогда c = a + b даст ожидаемый результат (3)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

path = '~/netology/sysadm-homeworks'
bash_command = ["cd "+path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        # break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

path = '~/netology/sysadm-homeworks/'
bash_command = ["cd "+path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path+prepare_result)
#        break
```

### Вывод скрипта при запуске при тестировании:
```bash
        bvm@RU1L0605:~/netology/sysadm-homeworks$ ~/04_script_02_py/04_01_02.py
        ~/netology/sysadm-homeworks/1file.txt
        ~/netology/sysadm-homeworks/2file.txt
        bvm@RU1L0605:~/netology/sysadm-homeworks$
```

| Дополнительный комментарий к ответу |
| ---------- |
| Предварительно я проинициализировал новый локальный репозиторий в указанной папке и создал, а затем модифицировал там два файла, чтобы они отслеживались и отображались в текущем статусе git'а |
| Затем я исправил сам скрипт - увидел переменную is_change, которая определена как булева, но не используется - закомментировал. Также закомментировал выход из цикла (break) - иначе показывало только первый из модифицированных файлов в выводе программы. Последнее, что добавил - новая строковая переменная path, в которую перенес путь для команды cd, а также добавил в итоговый вывод с именами модифицированных файлов ее значение, чтобы получился полный путь, а не только имя файла |

```bash
        bvm@RU1L0605:~/netology/sysadm-homeworks$ git log --oneline
        2dde4dc (HEAD -> master) Second file created. First modified
        8a7f2ee First file created
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

if ( len(sys.argv) == 1 ):
    print("Use full directory path as an argument.\n Example:")
    print(sys.argv[0],"/home/user/git/repository/")
    exit()

path = sys.argv[1]

#print( 'Number of arguments',len(sys.argv) )
#print( 'Is directory', os.path.isdir(sys.argv[1]) )
if os.path.isdir(sys.argv[1]):
    bash_command = ["cd "+path, "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    #is_change = False
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(path+prepare_result)
    #        break
else:
    print("Use full directory path as an argument.\n Example:")
    print(sys.argv[0],"/home/user/git/repository/")
    exit()
```

### Вывод скрипта при запуске при тестировании:
```bash
bvm@RU1L0605:~/netology/sysadm-homeworks$ ~/04_script_02_py/04_02_03.py ~/netology/sysadm-homeworks/
/home/bvm/netology/sysadm-homeworks/1file.txt
/home/bvm/netology/sysadm-homeworks/2file.txt
bvm@RU1L0605:~/netology/sysadm-homeworks$ ~/04_script_02_py/04_02_03.py ~/netology/sysadm-homeworks2/
Use full directory path as an argument.
 Example:
/home/bvm/04_script_02_py/04_02_03.py /home/user/git/repository/
bvm@RU1L0605:~/netology/sysadm-homeworks$ ~/04_script_02_py/04_02_03.py
Use full directory path as an argument.
 Example:
/home/bvm/04_script_02_py/04_02_03.py /home/user/git/repository/
bvm@RU1L0605:~/netology/sysadm-homeworks$ ~/04_script_02_py/04_02_03.py ./
./1file.txt
./2file.txt
bvm@RU1L0605:~/netology/sysadm-homeworks$ ~/04_script_02_py/04_02_03.py /mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/.gitignore
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/README.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/branching/merge.sh
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/has_been_moved.txt
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_01_terminal.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_02_terminal.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_03_os.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_04_os.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_05_fs.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_06_net.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_07_net.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_08_net.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_03_sysadmin_09_security.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_04_script_01_bash.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_04_script_02_py.md
/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/homework_git_04.md
bvm@RU1L0605:~/netology/sysadm-homeworks$
```

| # | Комментарий к ответу |
| --- | ---- |
| 1 | Заменил использование переменной с заданным значением непосредственно в коде на работу с аргументом командной строки |
| 2 | Сначала разобрался как определить количество аргументов при запуске скрипта, затем с дополнительной проверкой является ли директорией то, что нам передали в качестве первого параметра |
| 3 | В ходе проверки выяснил, что скрипт корректно отрабатывает при передаче ему пути без завершающей косой черты, но вывод имен измененных файлов становится не таким красивым - оставил как есть, т.к. либо менять формат выводимых строк нужно, либо добавлять в вывод заключительную косую черту, если ее нет в строке - все это это усложнит и без того уже сильно выросший скрипт, а реальной пользы от этого будет не так много. Описал в выводимом примере путь с заключительной косой чертой и на этом остановился |
| 4 | Одна из возникших сложностей была - как поймать запуск скрипта вообще без параметров - в итоге сделал еще одну проверку в самом начале и скопировал в нее вывод справки с примером запуска |

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import socket
import time

ServerList = { "drive.google.com":'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0' }
wait = 2
counter=0

while 1==1:
    print('-=== Round #',counter,' ===-')
    for ServerName, ServerOldIp in ServerList.items():
        ServerNewIp = socket.gethostbyname(ServerName)
        if ServerNewIp != ServerOldIp:
            print('[ERROR]', ServerName, 'IP mismatch:',ServerOldIp, ServerNewIp )
            ServerList[ServerName] = ServerNewIp
        else:
            print(ServerName, '-', ServerOldIp)
        time.sleep(wait)
    counter+=1
```

### Вывод скрипта при запуске при тестировании:
```
bvm@RU1L0605:~$ 04_script_02_py/04_02_04.py
-=== Round # 0  ===-
[ERROR] drive.google.com IP mismatch: 0.0.0.0 108.177.14.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 173.194.222.17
[ERROR] google.com IP mismatch: 0.0.0.0 142.251.1.139
-=== Round # 1  ===-
[ERROR] drive.google.com IP mismatch: 108.177.14.194 74.125.205.194
[ERROR] mail.google.com IP mismatch: 173.194.222.17 64.233.165.17
[ERROR] google.com IP mismatch: 142.251.1.139 64.233.163.102
-=== Round # 2  ===-
[ERROR] drive.google.com IP mismatch: 74.125.205.194 142.251.1.194
[ERROR] mail.google.com IP mismatch: 64.233.165.17 173.194.222.17
[ERROR] google.com IP mismatch: 64.233.163.102 142.251.1.113
-=== Round # 3  ===-
drive.google.com - 142.251.1.194
[ERROR] mail.google.com IP mismatch: 173.194.222.17 209.85.233.18
google.com - 142.251.1.113
-=== Round # 4  ===-
[ERROR] drive.google.com IP mismatch: 142.251.1.194 74.125.205.194
[ERROR] mail.google.com IP mismatch: 209.85.233.18 108.177.14.18
[ERROR] google.com IP mismatch: 142.251.1.113 173.194.222.101
-=== Round # 5  ===-
drive.google.com - 74.125.205.194
mail.google.com - 108.177.14.18
[ERROR] google.com IP mismatch: 173.194.222.101 142.251.1.113
-=== Round # 6  ===-
drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 108.177.14.18 142.251.1.18
[ERROR] google.com IP mismatch: 142.251.1.113 142.251.1.101
^CTraceback (most recent call last):
  File "04_script_02_py/04_02_04.py", line 18, in <module>
    time.sleep(wait)
KeyboardInterrupt

bvm@RU1L0605:~$
```

