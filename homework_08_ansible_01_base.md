# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 ansible 08.01 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «08.01 Введение в Ansible»

# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.

```answer0-1
    bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1$ ansible --version
    ansible [core 2.13.1]
      config file = None
      configured module search path = ['/home/bvm/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/local/lib/python3.8/dist-packages/ansible
      ansible collection location = /home/bvm/.ansible/collections:/usr/share/ansible/collections
      executable location = /usr/local/bin/ansible
      python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]
      jinja version = 3.1.2
      libyaml = True
```

2. Создайте свой собственный публичный репозиторий на github с произвольным именем.

```answer0-2
    https://github.com/bvmspb/ansible_8_1
```
[bvmspb/ansible_8_1](https://github.com/bvmspb/ansible_8_1)

3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

```answer0-3
    https://github.com/bvmspb/ansible_8_1/tree/master/playbook
```
[playbook](https://github.com/bvmspb/ansible_8_1/tree/master/playbook)


## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

```answer1-1
    Ответ: 12
```
```bash
bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ ansible-playbook -i ./inventory/test.yml site.yml 

PLAY [Print os facts] ***********************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.8, but future installation of another Python
interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] *****************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Linux Mint"
}

TASK [Print fact] ***************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP **********************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

```answer1-2
Файл в котором определяется значение указанной переменной "для всех":
group_vars/all/examp.yml
После исправления значения вывод поменялся соответственно:
```
```bash
bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ ansible-playbook -i ./inventory/test.yml site.yml 

PLAY [Print os facts] ***********************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.8, but future installation of another Python
interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] *****************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Linux Mint"
}

TASK [Print fact] ***************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP **********************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

```answer1-3
    bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ sudo docker run --rm --name "centos7" -d pycontribs/centos:7 sleep 10000000
    87b4238c9c3d92f3eb3641788a4f0fd8fba5759df7167b7e201bf0be498f2e1b
    bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ sudo docker run --rm --name "ubuntu" -d pycontribs/ubuntu:latest sleep 10000000
    Unable to find image 'pycontribs/ubuntu:latest' locally
    latest: Pulling from pycontribs/ubuntu
    423ae2b273f4: Pull complete 
    de83a2304fa1: Pull complete 
    f9a83bce3af0: Pull complete 
    b6b53be908de: Pull complete 
    7378af08dad3: Pull complete 
    Digest: sha256:dcb590e80d10d1b55bd3d00aadf32de8c413531d5cc4d72d0849d43f45cb7ec4
    Status: Downloaded newer image for pycontribs/ubuntu:latest
    c7fbb48f87a9cb6caa670a890e232a0ba9a96da43b279ee8dd315bc38a95da3e
```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```ab=nswer1-4
    TASK [Print fact] ***************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el"
    }
    ok: [ubuntu] => {
        "msg": "deb"
    }
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

```answer1-5
    Отредактировал файлы examp.yml в дирректориях group_vars/deb 
    и group_vars/el, соответственно. 
```

6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```bash
TASK [Print fact] ***************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```answer1-7
    bvm@bvm-HP-EliteBook-8470p:~$ cd netology/ansible_8_1/playbook/
    bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ ansible-vault encrypt group_vars/deb/examp.yml 
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful
    bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ ansible-vault encrypt group_vars/el/examp.yml 
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful
    bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ cat group_vars/deb/examp.yml 
    $ANSIBLE_VAULT;1.1;AES256
    64323137316465343034393638623363356230643263646662313033343032323531613437633136
    3835633336663263303566636661646563653565316538320a666331613832366531663762653235
    39356533346234393561623439376266393130323634346131626261383533346233336435323637
    6532313431656634390a306139653561346666646564633365303932313066646133313337303430
    37303965366234353063303532653430346232373562616564313035363035656131633036376332
    3163663365663561323139616130366662653638643331653638
    bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ cat group_vars/el/examp.yml 
    $ANSIBLE_VAULT;1.1;AES256
    31306363303036383832313532663335323235303637303665306364386665666630313337386236
    3562386162393965343862373563343264613261303636380a323033313533343339653431346534
    62623933386538303036343466363963366464383739376364306635303736343863323338386233
    6561643533636533340a653164646631346439616564356261646634363639306335316662326562
    64656661616135346462376338343838306633316134643232633035373562333763316434616639
    3963653434363165623830393534663266633537663236343135

```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```answer1-7
    Нужно добавить параметр при запуске ansible-playbook, чтобы запрашивал 
    пароль после апуска, либо считывал его из фйла.
    Ниже результаты запуска без параметра и с запросом пароля после запуска:
```
```bash
bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ sudo ansible-playbook -i ./inventory/prod.yml site.yml 

PLAY [Print os facts] *************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ sudo ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-password
Vault password: 

PLAY [Print os facts] *************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```answer1-9
    Список всех connection в выводе команды ниже.
    Полагаю, что "для работы на control node", то есть непосредственно на 
    компьюетере, где размещаются все inventory и т.п. - нужен local:
    local                          execute on controller
```
```bash
bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ ansible-doc -t connection --list
ansible.netcommon.httpapi      Use httpapi to run command on network appliances                                                                       
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection                                                               
ansible.netcommon.napalm       Provides persistent connection using NAPALM                                                                            
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol                                                            
ansible.netcommon.network_cli  Use network_cli to run command on network appliances                                                                   
ansible.netcommon.persistent   Use a persistent unix socket for connection                                                                            
community.aws.aws_ssm          execute via AWS Systems Manager                                                                                        
community.docker.docker        Run tasks in docker containers                                                                                         
community.docker.docker_api    Run tasks in docker containers                                                                                         
community.docker.nsenter       execute on host running controller container                                                                           
community.general.chroot       Interact with local chroot                                                                                             
community.general.funcd        Use funcd to connect to target                                                                                         
community.general.iocage       Run tasks in iocage jails                                                                                              
community.general.jail         Run tasks in jails                                                                                                     
community.general.lxc          Run tasks in lxc containers via lxc python library                                                                     
community.general.lxd          Run tasks in lxc containers via lxc CLI                                                                                
community.general.qubes        Interact with an existing QubesOS AppVM                                                                                
community.general.saltstack    Allow ansible to piggyback on salt minions                                                                             
community.general.zone         Run tasks in a zone instance                                                                                           
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt                                                                                
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines                                                                             
community.okd.oc               Execute tasks in pods running on OpenShift                                                                             
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools                                                                             
community.zabbix.httpapi       Use httpapi to run command on network appliances                                                                       
containers.podman.buildah      Interact with an existing buildah container                                                                            
containers.podman.podman       Interact with an existing podman container                                                                             
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes                                                                            
local                          execute on controller                                                                                                  
paramiko_ssh                   Run tasks via python ssh (paramiko)                                                                                    
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol                                                                  
ssh                            connect via SSH client binary                                                                                          
winrm                          Run tasks over Microsoft's WinRM                               
```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```answer1-10
    Добавил еще одну группу по аналогии с двумя имеющимися:
        bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ cat inventory/prod.yml 
        ---
          el:
            hosts:
              centos7:
                ansible_connection: docker
          deb:
            hosts:
              ubuntu:
                ansible_connection: docker
          local:
            hosts:
              localhost:
                ansible_connection: local
    Ниже результат работы playbook'а
```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```answer1-11
    Все переменные определились верно:
        TASK [Print fact] *****************************************************************************************************************************************
        ok: [centos7] => {
            "msg": "el default fact"
        }
        ok: [ubuntu] => {
            "msg": "deb default fact"
        }
        ok: [localhost] => {
            "msg": "all default fact"
        }
```
```bash
bvm@bvm-HP-EliteBook-8470p:~/netology/ansible_8_1/playbook$ sudo ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-password
Vault password: 

PLAY [Print os facts] *************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.8, but future installation of another Python
interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more
information.
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Linux Mint"
}

TASK [Print fact] *****************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

[Repository](https://github.com/bvmspb/ansible_8_1)

[Playbook](https://github.com/bvmspb/ansible_8_1/tree/master/playbook)

[README.md](https://github.com/bvmspb/ansible_8_1/blob/master/README.md)

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```answer2-1
Для расшифровки файла используется следующая команда:
    ansible-vault decrypt group_vars/deb/examp.yml
```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

```answer2-2
Следующая команда позволяет зашифровать отдельные строки для 
конфигурационных файлов ansible:
    ansible-vault encrypt_string
```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

