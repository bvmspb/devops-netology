# devops-netology DEVSYS-PDC-2

##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir

###DEVSYS-PDC-2 sysadmin 03.05 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «3.5. Файловые системы»

# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

```answer
        Очень интересная информация. Создал файл и проверил как это отразится 
        на свободном доступном дисковом пространстве (никак):
            vagrant@vagrant:~$ dd if=/dev/zero of=./sparse-file bs=1 count=0 seek=1G
            0+0 records in
            0+0 records out
            0 bytes copied, 0.000321295 s, 0.0 kB/s
            vagrant@vagrant:~$ ls -l
            total 32
            -rw-rw-r-- 1 vagrant vagrant        545 Nov 14 16:53 env_1130
            -rw-rw-r-- 1 vagrant vagrant       1016 Nov 14 14:29 file1.txt
            -rw-rw-r-- 1 vagrant vagrant       1016 Nov 14 14:40 file2.txt
            -rw-rw-r-- 1 vagrant vagrant 1073741824 Nov 24 16:59 sparse-file
            ...
            vagrant@vagrant:~$ df -h
            Filesystem                  Size  Used Avail Use% Mounted on
            udev                        447M     0  447M   0% /dev
            tmpfs                        99M  1.4M   97M   2% /run
            /dev/mapper/vgvagrant-root   62G  1.9G   57G   4% /
            tmpfs                       491M     0  491M   0% /dev/shm
            tmpfs                       5.0M     0  5.0M   0% /run/lock
            tmpfs                       491M     0  491M   0% /sys/fs/cgroup
            /dev/sda1                   511M  4.0K  511M   1% /boot/efi
            vagrant                     233G  206G   28G  89% /vagrant
            tmpfs                        99M     0   99M   0% /run/user/1000
            vagrant@vagrant:~$ rm ./sparse-file
            vagrant@vagrant:~$ df -h
            Filesystem                  Size  Used Avail Use% Mounted on
            udev                        447M     0  447M   0% /dev
            tmpfs                        99M  1.4M   97M   2% /run
            /dev/mapper/vgvagrant-root   62G  1.9G   57G   4% /
            tmpfs                       491M     0  491M   0% /dev/shm
            tmpfs                       5.0M     0  5.0M   0% /run/lock
            tmpfs                       491M     0  491M   0% /sys/fs/cgroup
            /dev/sda1                   511M  4.0K  511M   1% /boot/efi
            vagrant                     233G  206G   28G  89% /vagrant
            tmpfs                        99M     0   99M   0% /run/user/1000
            vagrant@vagrant:~$ ls -l
            total 32
            -rw-rw-r-- 1 vagrant vagrant  545 Nov 14 16:53 env_1130
            -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:29 file1.txt
            -rw-rw-r-- 1 vagrant vagrant 1016 Nov 14 14:40 file2.txt
            ...
        
        Фактически в самой этой виртуальной машине виртуальный "жесткий диск" 
        более 63Гб, но на жестком диске хоста занимает только столько места, 
        сколько фактически на него было записано данных, что очень удобно и 
        эффективно позволяет использовать дисковое пространство.
```

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

```answer
        Хардлинк - это прямая (жесткая) ссылка на объект файловой системы по 
        inode - несколько разных хардлинков на один объект будут иметь один 
        и тот же inode - уникальный идентификатор объекта на данной файловой 
        системе. Так как права доступа и владелец задаются на уровне объекта 
        файловой системы (inode), то они будут идентичными у всех хардлинков.
        Симлинк же - является отдельным самостоятельным объектом файловой 
        системы - каждый симлинк имеет свой собственный номер inode.
        Протестировал это наглядно на существующем файле - создал к нему 
        хардлинк и симлинк и посмотрел как меняются права и владелец у каждого:
            vagrant@vagrant:~$ ln file1.txt hardlink.txt
            vagrant@vagrant:~$ ln -s file1.txt simlink.txt
            vagrant@vagrant:~$ ls -li
            total 36
            ...
            131089 -rw-rw-r-- 2 vagrant vagrant 1016 Nov 14 14:29 file1.txt
            131089 -rw-rw-r-- 2 vagrant vagrant 1016 Nov 14 14:29 hardlink.txt
            131106 lrwxrwxrwx 1 vagrant vagrant    9 Nov 24 17:14 simlink.txt -> file1.txt
            ...
            vagrant@vagrant:~$ chmod 777 ./file1.txt
            vagrant@vagrant:~$ ls -li
            total 36
            ...
            131089 -rwxrwxrwx 2 vagrant vagrant 1016 Nov 14 14:29 file1.txt
            131089 -rwxrwxrwx 2 vagrant vagrant 1016 Nov 14 14:29 hardlink.txt
            131106 lrwxrwxrwx 1 vagrant vagrant    9 Nov 24 17:14 simlink.txt -> file1.txt
            ...
            vagrant@vagrant:~$ sudo chown root file1.txt
            vagrant@vagrant:~$ ls -li
            total 36
            ...
            131089 -rwxrwxrwx 2 root    vagrant 1016 Nov 14 14:29 file1.txt
            131089 -rwxrwxrwx 2 root    vagrant 1016 Nov 14 14:29 hardlink.txt
            131106 lrwxrwxrwx 1 vagrant vagrant    9 Nov 24 17:14 simlink.txt -> file1.txt
            ...
```

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```
    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

```answer
        Все так и получилось:
            C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant destroy
                default: Are you sure you want to destroy the 'default' VM? [y/N] y
            ==> default: Forcing shutdown of VM...
            ==> default: Destroying VM and associated drives...
            
            C:\Users\vbaksheev\PycharmProjects\netology.devops\devops-netology\vagrant>vagrant up
            Bringing machine 'default' up with 'virtualbox' provider...
            ==> default: Importing base box 'bento/ubuntu-20.04'...
            ==> default: Matching MAC address for NAT networking...
            ==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
            ==> default: Setting the name of the VM: vagrant_default_1637774972747_53712
            ==> default: Clearing any previously set network interfaces...
            ==> default: Preparing network interfaces based on configuration...
                default: Adapter 1: nat
            ==> default: Forwarding ports...
                default: 22 (guest) => 2222 (host) (adapter 1)
            ==> default: Running 'pre-boot' VM customizations...
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
            
            vagrant@vagrant:~$ lsblk -l
            NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
            sda                8:0    0   64G  0 disk
            sda1               8:1    0  512M  0 part /boot/efi
            sda2               8:2    0    1K  0 part
            sda5               8:5    0 63.5G  0 part
            sdb                8:16   0  2.5G  0 disk
            sdc                8:32   0  2.5G  0 disk
            vgvagrant-root   253:0    0 62.6G  0 lvm  /
            vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
```

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

```answer
        Приложение работает в интерактивном режиме и само предлагает по умолчанию 
        варианты, которые зачастую самые подходящие, что удобно:
            Command (m for help): F
            Unpartitioned space /dev/sdb: 2.51 GiB, 2683305984 bytes, 5240832 sectors
            Units: sectors of 1 * 512 = 512 bytes
            Sector size (logical/physical): 512 bytes / 512 bytes
            
            Start     End Sectors  Size
             2048 5242879 5240832  2.5G
            
            Command (m for help): n
            Partition type
               p   primary (0 primary, 0 extended, 4 free)
               e   extended (container for logical partitions)
            Select (default p):
            
            Using default response p.
            Partition number (1-4, default 1):
            First sector (2048-5242879, default 2048):
            Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
            
            Created a new partition 1 of type 'Linux' and of size 2 GiB.
            
            Command (m for help): F
            Unpartitioned space /dev/sdb: 511 MiB, 535822336 bytes, 1046528 sectors
            Units: sectors of 1 * 512 = 512 bytes
            Sector size (logical/physical): 512 bytes / 512 bytes
            
              Start     End Sectors  Size
            4196352 5242879 1046528  511M
            
            Command (m for help): n
            Partition type
               p   primary (1 primary, 0 extended, 3 free)
               e   extended (container for logical partitions)
            Select (default p): p
            Partition number (2-4, default 2):
            First sector (4196352-5242879, default 4196352):
            Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):
            
            Created a new partition 2 of type 'Linux' and of size 511 MiB.
            
            Command (m for help): F
            Unpartitioned space /dev/sdb: 0 B, 0 bytes, 0 sectors
            Units: sectors of 1 * 512 = 512 bytes
            Sector size (logical/physical): 512 bytes / 512 bytes
            
            Command (m for help): w
            The partition table has been altered.
            Calling ioctl() to re-read partition table.
            Syncing disks.
        
            vagrant@vagrant:~$ lsblk -l
            NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
            sda                8:0    0   64G  0 disk
            sda1               8:1    0  512M  0 part /boot/efi
            sda2               8:2    0    1K  0 part
            sda5               8:5    0 63.5G  0 part
            sdb                8:16   0  2.5G  0 disk
            sdb1               8:17   0    2G  0 part
            sdb2               8:18   0  511M  0 part
            sdc                8:32   0  2.5G  0 disk
            vgvagrant-root   253:0    0 62.6G  0 lvm  /
            vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
```

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

```answer
        Есть опция dump - сохранить таблицы разделов с диска в файл, чтобы позднее 
        можно было передать его на стандартный поток ввода для sfdisk в качестве 
        скрипта - воспользовался конвеером и сразу склонировал разделы 
        с sdb на sdc:
            vagrant@vagrant:~$ sfdisk --dump /dev/sdb | sfdisk /dev/sdc
            sfdisk: sfdisk: cannot open /dev/sdb: Permission denied
            cannot open /dev/sdc: Permission denied
            vagrant@vagrant:~$ sudo sfdisk --dump /dev/sdb | sudo sfdisk /dev/sdc
            Checking that no-one is using this disk right now ... OK
            
            Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
            Disk model: VBOX HARDDISK
            Units: sectors of 1 * 512 = 512 bytes
            Sector size (logical/physical): 512 bytes / 512 bytes
            I/O size (minimum/optimal): 512 bytes / 512 bytes
            
            >>> Script header accepted.
            >>> Script header accepted.
            >>> Script header accepted.
            >>> Script header accepted.
            >>> Created a new DOS disklabel with disk identifier 0xb8cf6060.
            /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
            /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
            /dev/sdc3: Done.
            
            New situation:
            Disklabel type: dos
            Disk identifier: 0xb8cf6060
            
            Device     Boot   Start     End Sectors  Size Id Type
            /dev/sdc1          2048 4196351 4194304    2G 83 Linux
            /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
            
            The partition table has been altered.
            Calling ioctl() to re-read partition table.
            Syncing disks.
            vagrant@vagrant:~$ lsblk -l
            NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
            sda                8:0    0   64G  0 disk
            sda1               8:1    0  512M  0 part /boot/efi
            sda2               8:2    0    1K  0 part
            sda5               8:5    0 63.5G  0 part
            sdb                8:16   0  2.5G  0 disk
            sdb1               8:17   0    2G  0 part
            sdb2               8:18   0  511M  0 part
            sdc                8:32   0  2.5G  0 disk
            sdc1               8:33   0    2G  0 part
            sdc2               8:34   0  511M  0 part
            vgvagrant-root   253:0    0 62.6G  0 lvm  /
            vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
```

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```answer
        Сделал:
            vagrant@vagrant:~$ sudo mdadm -C -v /dev/md1 -l1 --raid-devices=2 /dev/sd[bc]1
            mdadm: Note: this array has metadata at the start and
                may not be suitable as a boot device.  If you plan to
                store '/boot' on this device please ensure that
                your boot-loader understands md/v1.x metadata, or use
                --metadata=0.90
            mdadm: size set to 2094080K
            Continue creating array? yes
            mdadm: Defaulting to version 1.2 metadata
            mdadm: array /dev/md1 started.
```

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

```answer
        Сделал:
            vagrant@vagrant:~$ sudo mdadm -C -v /dev/md0 -l0 --raid-devices=2 /dev/sd[bc]2
            mdadm: chunk size defaults to 512K
            mdadm: Defaulting to version 1.2 metadata
            mdadm: array /dev/md0 started.
            vagrant@vagrant:~$ cat /proc/mdstat
            Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
            md0 : active raid0 sdc2[1] sdb2[0]
                  1042432 blocks super 1.2 512k chunks
            
            md1 : active raid1 sdc1[1] sdb1[0]
                  2094080 blocks super 1.2 [2/2] [UU]
            
            unused devices: <none>
```

8. Создайте 2 независимых PV на получившихся md-устройствах.

```answer
        Сделал:
            vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
              Physical volume "/dev/md0" successfully created.
              Physical volume "/dev/md1" successfully created.
```

9. Создайте общую volume-group на этих двух PV.

```answer
        Сделал:
            vagrant@vagrant:~$ sudo vgcreate vg00 /dev/md0 /dev/md1
              Volume group "vg00" successfully created
```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```answer
        Сделал:
            vagrant@vagrant:~$ sudo lvcreate -L 100M -n lv100 vg00 /dev/md0
              Logical volume "lv100" created.
```

11. Создайте `mkfs.ext4` ФС на получившемся LV.

```answer
        Сделал:
            vagrant@vagrant:~$ sudo mkfs.ext4 -L ext4Volume /dev/vg00/lv100
            mke2fs 1.45.5 (07-Jan-2020)
            Creating filesystem with 25600 4k blocks and 25600 inodes
            
            Allocating group tables: done
            Writing inode tables: done
            Creating journal (1024 blocks): done
            Writing superblocks and filesystem accounting information: done
```

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

```answer
        Сделал:
            vagrant@vagrant:~$ mkdir -p /tmp/new
            vagrant@vagrant:~$ mount /dev/vg00/lv100 /tmp/new/
            mount: only root can do that
            vagrant@vagrant:~$ sudo mount /dev/vg00/lv100 /tmp/new/
            vagrant@vagrant:~$ ls -la /tmp/new/
            total 24
            drwxr-xr-x  3 root root  4096 Nov 24 18:57 .
            drwxrwxrwt 10 root root  4096 Nov 24 18:59 ..
            drwx------  2 root root 16384 Nov 24 18:57 lost+found
            vagrant@vagrant:~$ lsblk
            NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
            sda                    8:0    0   64G  0 disk
            ├─sda1                 8:1    0  512M  0 part  /boot/efi
            ├─sda2                 8:2    0    1K  0 part
            └─sda5                 8:5    0 63.5G  0 part
              ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
              └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
            sdb                    8:16   0  2.5G  0 disk
            ├─sdb1                 8:17   0    2G  0 part
            │ └─md1                9:1    0    2G  0 raid1
            └─sdb2                 8:18   0  511M  0 part
              └─md0                9:0    0 1018M  0 raid0
                └─vg00-lv100     253:2    0  100M  0 lvm   /tmp/new
            sdc                    8:32   0  2.5G  0 disk
            ├─sdc1                 8:33   0    2G  0 part
            │ └─md1                9:1    0    2G  0 raid1
            └─sdc2                 8:34   0  511M  0 part
              └─md0                9:0    0 1018M  0 raid0
                └─vg00-lv100     253:2    0  100M  0 lvm   /tmp/new
```

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

```answer
        Сделал:
            vagrant@vagrant:~$ wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
            /tmp/new/test.gz: Permission denied
            vagrant@vagrant:~$ sudo chmod 777 /tmp/new/
            vagrant@vagrant:~$ wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
            --2021-11-24 19:02:31--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
            Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
            Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
            HTTP request sent, awaiting response... 200 OK
            Length: 22565143 (22M) [application/octet-stream]
            Saving to: ‘/tmp/new/test.gz’
            
            /tmp/new/test.gz              100%[=================================================>]  21.52M  12.0MB/s    in 1.8s
            
            2021-11-24 19:02:33 (12.0 MB/s) - ‘/tmp/new/test.gz’ saved [22565143/22565143]
```

14. Прикрепите вывод `lsblk`.

```answer
        Сделал:
            vagrant@vagrant:~$ lsblk
            NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
            sda                    8:0    0   64G  0 disk
            ├─sda1                 8:1    0  512M  0 part  /boot/efi
            ├─sda2                 8:2    0    1K  0 part
            └─sda5                 8:5    0 63.5G  0 part
              ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
              └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
            sdb                    8:16   0  2.5G  0 disk
            ├─sdb1                 8:17   0    2G  0 part
            │ └─md1                9:1    0    2G  0 raid1
            └─sdb2                 8:18   0  511M  0 part
              └─md0                9:0    0 1018M  0 raid0
                └─vg00-lv100     253:2    0  100M  0 lvm   /tmp/new
            sdc                    8:32   0  2.5G  0 disk
            ├─sdc1                 8:33   0    2G  0 part
            │ └─md1                9:1    0    2G  0 raid1
            └─sdc2                 8:34   0  511M  0 part
              └─md0                9:0    0 1018M  0 raid0
                └─vg00-lv100     253:2    0  100M  0 lvm   /tmp/new
```

15. Протестируйте целостность файла:
     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

```answer
        Сделал:
            vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
            vagrant@vagrant:~$ echo $0
            -bash
            vagrant@vagrant:~$ echo $?
            0
```    

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

```answer
        Сделал (заняло некоторое время):
            vagrant@vagrant:~$ sudo pvmove /dev/md0 /dev/md1
              /dev/md0: Moved: 28.00%
              /dev/md0: Moved: 100.00%
```

17. Сделайте `--fail` на устройство в вашем RAID1 md.

```answer
        Сделал:
            vagrant@vagrant:~$ sudo mdadm --fail /dev/md1 /dev/sdb1
            mdadm: set /dev/sdb1 faulty in /dev/md1
            vagrant@vagrant:~$ sudo cat /proc/mdstat
            Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
            md0 : active raid0 sdc2[1] sdb2[0]
                  1042432 blocks super 1.2 512k chunks
            
            md1 : active raid1 sdc1[1] sdb1[0](F)
                  2094080 blocks super 1.2 [2/1] [_U]
            
            unused devices: <none>
```

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

```answer
        Сделал - md/raid1:md1: Disk failure on sdb1, disabling device.
            vagrant@vagrant:~$ dmesg |grep md1
            [ 2943.490690] md/raid1:md1: not clean -- starting background reconstruction
            [ 2943.490692] md/raid1:md1: active with 2 out of 2 mirrors
            [ 2943.490712] md1: detected capacity change from 0 to 2144337920
            [ 2943.505366] md: resync of RAID array md1
            [ 2957.547612] md: md1: resync done.
            [ 6423.431841] md/raid1:md1: Disk failure on sdb1, disabling device.
                           md/raid1:md1: Operation continuing on 1 devices.
```

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
    
```answer
        Так и есть:
            vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
            vagrant@vagrant:~$ echo $?
            0
```

20. Погасите тестовый хост, `vagrant destroy`.

```answer
Сделаю как только получу зачет за эту ДЗ :) 
```
 ---

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Название файла Google Docs должно содержать номер лекции и фамилию студента. Пример названия: "1.1. Введение в DevOps — Сусанна Алиева".

Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. Чтобы это проверить, откройте ссылку в браузере в режиме инкогнито.

[Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)

[Как запустить chrome в режиме инкогнито ](https://support.google.com/chrome/answer/95464?co=GENIE.Platform%3DDesktop&hl=ru)

[Как запустить  Safari в режиме инкогнито ](https://support.apple.com/ru-ru/guide/safari/ibrw1069/mac)

Любые вопросы по решению задач задавайте в чате Slack.

---
