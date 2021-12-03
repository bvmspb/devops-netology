# devops-netology DEVSYS-PDC-2

##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir

###DEVSYS-PDC-2 sysadmin 03.07 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «3.7. Компьютерные сети, лекция 2»

# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

```answer
        в WSL Ubuntu 20.04:
            bvm@RU1L0605:/mnt/c/Users/vbaksheev$ ip -br link show
            lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
            bond0            DOWN           12:44:34:06:34:54 <BROADCAST,MULTICAST,MASTER>
            dummy0           DOWN           7a:67:2b:f2:03:a5 <BROADCAST,NOARP>
            eth0             UP             00:15:5d:db:0a:e7 <BROADCAST,MULTICAST,UP,LOWER_UP>
            tunl0@NONE       DOWN           0.0.0.0 <NOARP>
            sit0@NONE        DOWN           0.0.0.0 <NOARP>
        
        В образе Vagrant Ubuntu 20.04:
        vagrant@vagrant:~$ ip -br link show
            lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
            eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP>

        Еще варианты из интернета для linux:
            cat /proc/net/dev
            ls -l /sys/class/net/
        
        Под windows есть ipconfig /all - показывает все доступные подключения и их 
        параметры.
```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

```answer
        Протокол LLDP - link layer discovery protocol, протокол канального 
        уровня для обмена информацией о сетевых устройствах. Нужна поддержка 
        на всех устройствах для успешного обмена такой информацией.
        Вот вывод команды lldpctl у меня в ВМ vagrant (соседей нет):
            vagrant@vagrant:~$ lldpctl
            -------------------------------------------------------------------------------
            LLDP neighbors:
            -------------------------------------------------------------------------------
            Interface:    eth0, via: LLDP, RID: 1, Time: 0 day, 00:05:30
              Chassis:
                ChassisID:    mac 3c:52:82:46:2e:46
              Port:
                PortID:       mac 3c:52:82:46:2e:46
                TTL:          3601
                PMD autoneg:  supported: yes, enabled: yes
                  Adv:          1000Base-T, HD: no, FD: yes
                  MAU oper type: unknown
              LLDP-MED:
                Device Type:  Generic Endpoint (Class I)
                Capability:   Capabilities, yes
            -------------------------------------------------------------------------------
        
        Протокол ARP, который позволяет узнать аппаратный (MAC) адрес по известному 
        ip-адресу.
        В Linux есть команда arp, которая умеет показывать список известных на 
        нашем хосте адресов - тоже, своего рода, соседей.
            vagrant@vagrant:~$ arp
            Address                  HWtype  HWaddress           Flags Mask            Iface
            172.16.0.114             ether   3c:52:82:46:2e:46   C                     eth0
            172.16.0.129             ether   40:3f:8c:b0:87:f4   C                     eth0
            COMFAST.bvm              ether   20:0d:b0:d0:50:73   C                     eth0
        Также схожий вывод дает команда ip с параметром neighbour.
            vagrant@vagrant:~$ ip neighbour
            172.16.0.114 dev eth0 lladdr 3c:52:82:46:2e:46 REACHABLE
            172.16.0.129 dev eth0 lladdr 40:3f:8c:b0:87:f4 REACHABLE
            172.16.0.1 dev eth0 lladdr 20:0d:b0:d0:50:73 STALE
```

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

```answer
        VLAN - тегирование фреймов на канальном уровне для того, чтобы определеить их 
        принадлежность к определенной канальной среде, описан в стандарте 802.1q.
        Поддержка в Linux обеспечивается на уровне ядра - модулем 8021q, который должен 
        быть загружен:
            sudo modprobe 8021q
        В Ubuntu для работы с VLAN нужно установить пакет vlan: 
            sudo apt-get install vlan
        Ручная настройка VLAN осуществляется утилитой vconfig (называется устаревшей). Например:
            sudo vconfig add eth0 777
        Либо аналогичная операция при помощи утилиты ip, заодно назначим статичный 
        адрес и "поднимем" интерфейс:
            sudo ip link add link eth0 name eth0.777 type vlan id 777
            sudo ip addr add 10.0.0.100 dev eth0.777
            sudo ip link set eth0.777 up
        Теперь новый сетевой интерфейс видно в общем списке и можно "попинговать":
            vagrant@vagrant:~$ ip addr show
            1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
                link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
                inet 127.0.0.1/8 scope host lo
                   valid_lft forever preferred_lft forever
                inet6 ::1/128 scope host
                   valid_lft forever preferred_lft forever
            2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
                link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
                inet 172.16.0.150/16 brd 172.16.255.255 scope global dynamic eth0
                   valid_lft 3823sec preferred_lft 3823sec
                inet6 fe80::a00:27ff:fe73:60cf/64 scope link
                   valid_lft forever preferred_lft forever
            4: eth0.777@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
                link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
                inet 10.0.0.100/32 scope global eth0.777
                   valid_lft forever preferred_lft forever
                inet6 fe80::a00:27ff:fe73:60cf/64 scope link
                   valid_lft forever preferred_lft forever
            vagrant@vagrant:~$ ping 10.0.0.100
            PING 10.0.0.100 (10.0.0.100) 56(84) bytes of data.
            64 bytes from 10.0.0.100: icmp_seq=1 ttl=64 time=0.020 ms
            64 bytes from 10.0.0.100: icmp_seq=2 ttl=64 time=0.041 ms
            64 bytes from 10.0.0.100: icmp_seq=3 ttl=64 time=0.035 ms
            ^C
            --- 10.0.0.100 ping statistics ---
            3 packets transmitted, 3 received, 0% packet loss, time 2028ms
            rtt min/avg/max/mdev = 0.020/0.032/0.041/0.008 ms
        
        Все эти настройки после перезагрузки пропадут. Для того, чтобы при запуске 
        системы применялись нужные параметры используется специальный скрипт со всеми 
        сетевыми настройками: /etc/network/interfaces
        Например, такого содержания:
            # interfaces(5) file used by ifup(8) and ifdown(8)
            # Include files from /etc/network/interfaces.d:
            source-directory /etc/network/interfaces.d
            auto eth0.777
            iface eth0.777 inet static
                    address 10.0.0.100
                    netmask 255.255.255.0
                    vlan_raw_device eth0
        Далее, либо перезапустить службу:
            sudo systemctl restart networking
        
        Либо просто при загрузке применятся параметры прописанные в данном файле.
        
        Вот вывод как это будет выглядеть:
            vagrant@vagrant:~$ ip a
            1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
                link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
                inet 127.0.0.1/8 scope host lo
                   valid_lft forever preferred_lft forever
                inet6 ::1/128 scope host
                   valid_lft forever preferred_lft forever
            2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
                link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
                inet 172.16.0.150/16 brd 172.16.255.255 scope global dynamic eth0
                   valid_lft 7132sec preferred_lft 7132sec
                inet6 fe80::a00:27ff:fe73:60cf/64 scope link
                   valid_lft forever preferred_lft forever
            3: eth0.777@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
                link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
                inet 10.0.0.100/24 brd 10.0.0.255 scope global eth0.777
                   valid_lft forever preferred_lft forever
                inet6 fe80::a00:27ff:fe73:60cf/64 scope link
                   valid_lft forever preferred_lft forever
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

```answer
        В Linux агрегация нескольких каналов называется bonding, в современных версиях 
        реализована поддержка модулем ядра. Также есть альтернативный вариант, который 
        называется Network Teaming, который из себя представляет мини драйвер уровня 
        ядра, взаимодействуя с которым через API приложения могут реализовать свою 
        логику работы с несколькими агрегированными интерфейсами.
        Агрегация используется для повышения пропускной спосбоности и/или улучшения 
        отказоустойчивости сети.
        Типы агрегации (иначе говоря режимы, mode, объединения нескольких каналов):
            Mode-0(balance-rr) – Данный режим используется по умолчанию. Balance-rr 
        обеспечивается балансировку нагрузки и отказоустойчивость. В данном режиме 
        сетевые пакеты отправляются “по кругу” (round robin - карусель), по очереди 
        перебирая все агрегированные интерфейсы. Если выходят из строя интерфейсы,
        пакеты отправляются на остальные оставшиеся.
            Mode-1(active-backup) – Один из интерфейсов работает в активном режиме, 
        остальные в простаивают в резерве. При обнаружении проблемы на активном 
        интерфейсе производится переключение на ожидающий интерфейс.
            Mode-2(balance-xor) – Передача пакетов распределяется по аппаратному адресу 
        получателя по формуле ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим 
        дает балансировку нагрузки и отказоустойчивость. Так как привязан к 
        MAC-адресу - чаще всего используется в одной локальной сети.
            Mode-3(broadcast) – Происходит передача во все объединенные интерфейсы, тем 
        самым обеспечивая отказоустойчивость. Рекомендуется только для использования 
        MULTICAST трафика.
            Mode-4(802.3ad) – динамическое объединение одинаковых портов. В данном режиме 
        можно значительно увеличить пропускную способность входящего так и исходящего 
        трафика. Для данного режима необходима поддержка и настройка 
        коммутатора/коммутаторов. Этот режим используется когда необходимо настроить 
        работу через LACP протокол.
            Mode-5(balance-tlb) – Адаптивная балансировки нагрузки трафика. Входящий трафик 
        получается только активным интерфейсом, исходящий распределяется в зависимости 
        от текущей загрузки канала каждого интерфейса.
            Mode-6(balance-alb) – Продвинутая адаптивная балансировка нагрузки. Отличается 
        более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается 
        балансировку нагрузки как исходящего так и входящего трафика.
        
        Помимо режима работы, основные параметры (опции) конфигурации следующие:
            bond_miimon 100 - частота мониторинга в мс, с которой отслеживать интерфейсы 
            bond_downdelay 200 - в мс, должно быть кратно miimon. Устанавливает время 
                    ожидания до отключения интерфейса в случае невозможности установить 
                    соединение
            bond_updelay 200 - в мс, должно быть кратно miimon. Устанавливает время 
                    ожидания до включения интерфейса после восстановления подключения
        
        В простейшем случае начать работу с бондингом можно следующим образом:
            modprobe bonding miimon=100 downdelay=200 updelay=200
            ifconfig bond0 192.168.0.1 netmask 255.255.0.0
            ifenslave bond0 eth0 eth1
            
        Можно просписать все параметры в стартовом скрипте, например:
            iface bond0 inet static
            address 192.168.0.1
            netmask 255.255.255.0
            network 192.168.0.0
            gateway 192.168.0.254
            bond_mode balance-tlb
            bond_miimon 100
            bond_downdelay 200
            bond_updelay 200
            slaves eth0 eth1
        
        После чего выполнить:
            sudo ifdown eth0 eth1
            sudo ifup bond0
            sudo systemctl restart networking
```

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

```answer
        6 адресов для хостов в сети с маской /29 (+broadcast и сетевой):
            vagrant@vagrant:~$ ipcalc 0.0.0.0/29 | grep Hosts
            Hosts/Net: 6                     Class A
        
        29 подсеть использует 3 бита из доступных 8 бит в 24 подсети, то есть 
        остается 5 бит или иначе говоря 2^5=32 
        32 подсети по 6 хостов в каждой, можно проверить командой:
            ipcalc 0.0.0.0/24 -s 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
        
        10.10.10.0/29, 10.10.10.8/29, 10.10.10.16/29
            vagrant@vagrant:~$ ipcalc 10.10.10.0/24 -s 6 6 6
            Address:   10.10.10.0           00001010.00001010.00001010. 00000000
            Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
            Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
            =>
            Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
            HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
            HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
            Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
            Hosts/Net: 254                   Class A, Private Internet
            
            1. Requested size: 6 hosts
            Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
            Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
            HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
            HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
            Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
            Hosts/Net: 6                     Class A, Private Internet
            
            2. Requested size: 6 hosts
            Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
            Network:   10.10.10.8/29        00001010.00001010.00001010.00001 000
            HostMin:   10.10.10.9           00001010.00001010.00001010.00001 001
            HostMax:   10.10.10.14          00001010.00001010.00001010.00001 110
            Broadcast: 10.10.10.15          00001010.00001010.00001010.00001 111
            Hosts/Net: 6                     Class A, Private Internet
            
            3. Requested size: 6 hosts
            Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
            Network:   10.10.10.16/29       00001010.00001010.00001010.00010 000
            HostMin:   10.10.10.17          00001010.00001010.00001010.00010 001
            HostMax:   10.10.10.22          00001010.00001010.00001010.00010 110
            Broadcast: 10.10.10.23          00001010.00001010.00001010.00010 111
            Hosts/Net: 6                     Class A, Private Internet
            
            Needed size:  24 addresses.
            Used network: 10.10.10.0/27
            Unused:
            10.10.10.24/29
            10.10.10.32/27
            10.10.10.64/26
            10.10.10.128/25
```

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

```answer
        Например, подсеть 100.64.0.0/26
            vagrant@vagrant:~$ ipcalc 100.64.0.0/10 -s 50
            Address:   100.64.0.0           01100100.01 000000.00000000.00000000
            Netmask:   255.192.0.0 = 10     11111111.11 000000.00000000.00000000
            Wildcard:  0.63.255.255         00000000.00 111111.11111111.11111111
            =>
            Network:   100.64.0.0/10        01100100.01 000000.00000000.00000000
            HostMin:   100.64.0.1           01100100.01 000000.00000000.00000001
            HostMax:   100.127.255.254      01100100.01 111111.11111111.11111110
            Broadcast: 100.127.255.255      01100100.01 111111.11111111.11111111
            Hosts/Net: 4194302               Class A
            
            1. Requested size: 50 hosts
            Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
            Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
            HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
            HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
            Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
            Hosts/Net: 62                    Class A
```

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

```answer
        Вывести таблицу с текущими значениями и на Windows и на Linux можно одинаковой 
        командой:
            arp -a 
        
        Удалить конкретный адрес из таблицы также можно схожей командой и там и там%
            arp -d 239.0.0.250
            
        Если же указать в качестве адреса *, то удалятся все сохраненные ранеее адреса:
            arp -d *
        
        В Windows также есть возможность очистить все адреса другой командой:
            netsh interface ip delete arpcache
        
        В Linux также есть альтернатива в виде:
            sudo ip neigh flush all

```

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
 ---