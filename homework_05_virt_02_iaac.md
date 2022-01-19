# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 sysadmin 05.02 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «5.2. Применение принципов IaaC в работе с виртуальными машинами»


# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"


---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

```answer

```

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```answer3
Для возможности запуска виртуальной машины мне пришлось достать свой 
старый ноутбук, на котором и загрузился в Linux из под которого и 
продолжил работу (основной ноутбук у меня рабочий у меня с Windows и 
установить даже в dualboot linux туда у меня возможности нет, к 
сожалению).
Привожу выводы всех команд:
```
```bash
    bvm@bvm-HP-EliteBook-8470p:~$ virtualbox --help
    Oracle VM VirtualBox VM Selector v6.1.26_Ubuntu
    (C) 2005-2021 Oracle Corporation
    All rights reserved.
    
    No special options.
    
    If you are looking for --startvm and related options, you need to use VirtualBoxVM.
    bvm@bvm-HP-EliteBook-8470p:~$ vagrant --version
    Vagrant 2.2.6
    bvm@bvm-HP-EliteBook-8470p:~$ ansible --version
    ansible 2.9.6
      config file = /etc/ansible/ansible.cfg
      configured module search path = ['/home/bvm/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python3/dist-packages/ansible
      executable location = /usr/bin/ansible
      python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
    bvm@bvm-HP-EliteBook-8470p:~$ git --version
    git version 2.25.1
    bvm@bvm-HP-EliteBook-8470p:~$ 
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

```answer4
Привожу "хвост" вывода после выполнения команды vagrant up и следом за ней вошел при помощи vagrant ssh в новую созданную VM, чтобы удостовериться в том, что docker установлен в ней.
Также, справедливости ради, следует заметить, что при выполнении скриптов ansible шаг, на котором должны были скопироваться ssh ключи внутрь созданной VM - провалился у меня, т.к. никакие ключи на этом компьютере я еще не создавал, но это не приостановилу выполнения всего сценария и только добавило к "ignored" единичку в итоге.
Вывод команд: 
```
```bash
    PLAY RECAP *********************************************************************
    server1.netology           : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1   
    
    bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/05_02/vagrant$ vagrant ssh
    Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    
     System information disabled due to load higher than 1.0
    
    
    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento
    Last login: Wed Jan 19 18:57:53 2022 from 10.0.2.2
    vagrant@server1:~$ docker ps
    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
    vagrant@server1:~$ docker --version
    Docker version 20.10.12, build e91ed57
    vagrant@server1:~$ 
```
