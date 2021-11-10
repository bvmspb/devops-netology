# devops-netology DEVSYS-PDC-2
##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir
###DEVSYS-PDC-2 sysadmin 03.01 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «3.1. Работа в терминале, лекция 1»

# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

1. Установите средство виртуализации [Oracle VirtualBox](https://www.virtualbox.org/).  


      Работаю на ноутбуке с Windows - скачал версию с сайта 6.1 (Version 6.1.26 r145957 (Qt5.6.2))  
* Есть более новая версия, но у нее были проблемы совместимости с установленной у меня Windows 10 - на форуме поддержки уже нашел подтверждение наличия проблемы и заведенный тикет на исправление, но мне было проще откатиться на предыдущую работающую версию, т.к. про нее написали там же на форуме.

2. Установите средство автоматизации [Hashicorp Vagrant](https://www.vagrantup.com/).


      Скачал и установил версию 2.2.18:
      C:\Users\vbaksheev>vagrant -v
      Vagrant 2.2.18

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:

* iTerm2 в Mac OS X
* Windows Terminal в Windows
* выбрать цветовую схему, размер окна, шрифтов и т.д.
* почитать о кастомизации PS1/применить при желании.


      Установил Windows Terminal, добавил в него оснастку для запуска Ubuntu через WSL - удобно 
      для параллельной работы в командной строке windows (с тем же vagrant) и shell linux 
      "для нативного опыта", когда это нужно.

Несколько популярных проблем:
 * Добавьте Vagrant в правила исключения перехватывающих трафик для анализа антивирусов, таких как Kaspersky, если у вас возникают связанные с SSL/TLS ошибки,
 * MobaXterm может конфликтовать с Vagrant в Windows,
 * Vagrant плохо работает с директориями с кириллицей (может быть вашей домашней директорией), тогда можно либо изменить [VAGRANT_HOME](https://www.vagrantup.com/docs/other/environmental-variables#vagrant_home), либо создать в системе профиль пользователя с английским именем,
 * VirtualBox конфликтует с Windows Hyper-V и его необходимо [отключить](https://www.vagrantup.com/docs/installation#windows-virtualbox-and-hyper-v),
 * [WSL2](https://docs.microsoft.com/ru-ru/windows/wsl/wsl2-faq#does-wsl-2-use-hyper-v-will-it-be-available-on-windows-10-home) использует Hyper-V, поэтому с ним VirtualBox также несовместим,
 * аппаратная виртуализация (Intel VT-x, AMD-V) должна быть активна в BIOS,
 * в Linux при установке [VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads) может дополнительно потребоваться пакет `linux-headers-generic` (debian-based) / `kernel-devel` (rhel-based).


      Пришлось включить виртуализацию в UEFI ноутбука, также "на всякий случай" выключил Hyper-V 
      в компонентах Windows

4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

  * Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните `vagrant init`. Замените содержимое Vagrantfile по умолчанию следующим:

        ```bash
        Vagrant.configure("2") do |config|
            config.vm.box = "bento/ubuntu-20.04"
        end
        ```


[файл конфигурации vagrant](./homework_03_sysadmin_01_terminal.md)

    Создал директорию vagrant в папке с проектом devops-netology и отредактировал [файл конфигурации](https://github.com/bvmspb/devops-netology/blob/main/homework_03_sysadmin_01_terminal.md), полученный после init'а:
    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology>mkdir vagrant
    
    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology>cd vagrant
    
    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant init
    ==> vagrant: A new version of Vagrant is available: 2.2.19 (installed version: 2.2.18)!
    ==> vagrant: To upgrade visit: https://www.vagrantup.com/downloads.html
    
    A `Vagrantfile` has been placed in this directory. You are now
    ready to `vagrant up` your first virtual environment! Please read
    the comments in the Vagrantfile as well as documentation on
    `vagrantup.com` for more information on using Vagrant.


   * Выполнение в этой директории `vagrant up` установит провайдер VirtualBox для Vagrant, скачает необходимый образ и запустит виртуальную машину.


    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Importing base box 'bento/ubuntu-20.04'...
    ==> default: Matching MAC address for NAT networking...
    ==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
    ==> default: Setting the name of the VM: vagrant_default_1636568580178_53818
    ==> default: Clearing any previously set network interfaces...
    ==> default: Preparing network interfaces based on configuration...
        default: Adapter 1: nat
    ==> default: Forwarding ports...
        default: 22 (guest) => 2222 (host) (adapter 1)
    ==> default: Booting VM...
    ==> default: Waiting for machine to boot. This may take a few minutes...
        default: SSH address: 127.0.0.1:2222
        default: SSH username: vagrant
        default: SSH auth method: private key
        default: Warning: Connection reset. Retrying...
        default: Warning: Connection aborted. Retrying...
        default:
        default: Vagrant insecure key detected. Vagrant will automatically replace
        default: this with a newly generated keypair for better security.
        default:
        default: Inserting generated public key within guest...
        default: Removing insecure key from the guest if it's present...
        default: Key inserted! Disconnecting and reconnecting using new SSH key...
    ==> default: Machine booted and ready!
    ==> default: Checking for guest additions in VM...
    ==> default: Mounting shared folders...
        default: /vagrant => C:/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/vagrant

   * `vagrant suspend` выключит виртуальную машину с сохранением ее состояния (т.е., при следующем `vagrant up` будут запущены все процессы внутри, которые работали на момент вызова suspend), `vagrant halt` выключит виртуальную машину штатным образом.


    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant suspend
    ==> default: Saving VM state and suspending execution...
    
    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
    ==> default: Resuming suspended VM...
    ==> default: Booting VM...
    ==> default: Waiting for machine to boot. This may take a few minutes...
        default: SSH address: 127.0.0.1:2222
        default: SSH username: vagrant
        default: SSH auth method: private key
    ==> default: Machine booted and ready!
    ==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
    ==> default: flag to force provisioning. Provisioners marked to run always will still run.

5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?


    Видно, что выделен 1Гб ОЗУ, 2 ядра процессора, 4Мб видеопамяти (что ниже значения по умолчанию в самом Virtual Box,
    о чем он и предупреждает) Подключен виртуальный жесткий диск объемом 64Гб, стандартная гигабитная сетевая карта:
    System: 
        Base memory:    1024 MB
        Processors:     2
        Acceleration:   VT-x/AMD-V, Nested Paging, PAE/NX, KVM Paravirtualization
    Display:
        Video Memory:   4 MB
        Graphics Controller:    VBoxVGA
        Remote Desktop Server Port: 5996
        Recording:      Disabled
    Storage:
        SATA Port 0:    ubuntu-20.04-amd64-disk001.vmdk (Normal, 64,00 GB)
    Audio:              Disabled
    Network:
        Adapter 1:      Intel PRO/1000 MT Desktop (NAT)



6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?


    В файле, создаваемом по умолчанию после init'а есть закомментированные примеры популярных параметров VM.
    В документации по приведенной ссылке есть конкретный пример для конфигурирования памяти и количества ядер CPU:
        config.vm.provider "virtualbox" do |v|
          v.memory = 1024
          v.cpus = 2
        end


7. Команда `vagrant ssh` из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.



    Получилось удобно и быстро подключиться shell'у запущенной ранее командой up виртуальной машине:

    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant ssh
    Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    
      System information as of Wed 10 Nov 2021 06:51:49 PM UTC
    
      System load:  0.0               Processes:             109
      Usage of /:   2.3% of 61.31GB   Users logged in:       0
      Memory usage: 14%               IPv4 address for eth0: 10.0.2.15
      Swap usage:   0%
    
    
    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento
    vagrant@vagrant:~$



8. Ознакомиться с разделами `man bash`, почитать о настройках самого bash:
   * какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?


    Поиск (через /) по history помог найти переменную HISTCMD, описанную на строке 718 man'а     

   * что делает директива `ignoreboth` в bash?


    Позволяет задать правило сохранения команд в истории (~/.history) bash таким образом, чтобы игнорировались команды,
    начинающиеся с пробела, а также повторяющиеся (подряд) команды, то есть один такой параметр заменяет собой сразу два
    других: ignorespace и ignoredups

9. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?


    Поиск по /\{ позволяет найти секцию Brace Expansion (строка 1091 из 4548), где приводятся описание и примеры такого
    иинструмента, как {} - который позволяет перечисленные в нем через запятую аргументы последовательно подставить в
    выполняемую команду, например:
    mkdir /usr/local/src/bash/{old,new,dist,bugs} раскроется последовательно в три отдельные команды
    mkdir /usr/local/src/bash/old
    mkdir /usr/local/src/bash/new
    mkdir /usr/local/src/bash/dist
    mkdir /usr/local/src/bash/bugs
    Также возможно указать числовые параметры не через запятую, а диапазоном, используя {x..y} 
    Например mkdir ~/temp{1..5}
        vagrant@vagrant:~$ mkdir ~/temp{1..5}
        vagrant@vagrant:~$ ls -ls ~
        total 20
        4 drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp1
        4 drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp2
        4 drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp3
        4 drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp4
        4 drwxrwxr-x 2 vagrant vagrant 4096 Nov 10 19:22 temp5


10. Основываясь на предыдущем вопросе, как создать однократным вызовом `touch` 100000 файлов? А получилось ли создать 300000? Если нет, то почему?


    Команда должна выглядеть примерно так:
    touch {1..100000)
    Но я бы поостерегся запускать подобную команду, т.к. у каждой файловой системы есть свои ограничения на количество 
    файлов (вообще - элементов файловой системы) и даже если лимиты не исчерпать, но создать огромное количество файлов,
    то это может привести к замедлению работы в данном каталоге (если попробовать получить листинг файлов в ней, 
    например), либо даже вовсе заблокировать возможность работать с этим томом.
    Также могут быть проблемы с ограничениями количества аргументов и их длины в shell


11. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`


    269 строка man'аговорит нам о [[ expression ]], где описывается что возвращается статус логического выражения 
    внутри двойных квадратных скобок 0 или 1, в зависимости от того истинно оно или ложь.
    Само же выражение -d /tmp в контексте использования совместно с [[ описывается начиная со строки 1843 (сам раздел
    CONDITIONAL EXPRESSIONS начинается со строки 1818), где говорится, что возвращает ИСТИНА, в случае если /tmp 
    существует и является директорией.

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

     ```bash
     bash is /tmp/new_path_directory/bash
     bash is /usr/local/bin/bash
     bash is /bin/bash
     ```

     (прочие строки могут отличаться содержимым и порядком)
     В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.


    vagrant@vagrant:~$ type -a bash
    bash is /usr/bin/bash
    bash is /bin/bash
    vagrant@vagrant:~$ mkdir -p /tmp/new_path_directory
    vagrant@vagrant:~$ cp /usr/bin/bash /tmp/new_path_directory/bash
    vagrant@vagrant:~$ export PATH=/tmp/new_path_directory:$PATH
    vagrant@vagrant:~$ type -a bash
    bash is /tmp/new_path_directory/bash
    bash is /usr/bin/bash
    bash is /bin/bash


13. Чем отличается планирование команд с помощью `batch` и `at`?


    at используется для запуска команды в определенное время, которое указывается непосредственно при запуске/использовании at
    batch используется для запуска команд в период, когда загрузка CPU будет минимальной (по умолчанию ниже 1.5) - например, для выполнения задач обслуживания/резервного копирования сервера и т.п., когда он практически не используется

14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.


    vagrant@vagrant:~$ exit
    logout
    Connection to 127.0.0.1 closed.
    
    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant halt
    ==> default: Attempting graceful shutdown of VM...
    
    C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>

 
