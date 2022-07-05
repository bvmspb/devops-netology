# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 terraform 07.01 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «7.1. Инфраструктура как код»

# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов. 
 
### Легенда
 
Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо 
будет уже сегодня. 
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам.
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.

Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.  
   
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры.
На данный момент в вашей компании уже используются следующие инструменты: 
- остатки Сloud Formation, 
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform, 
- разработчики привыкли использовать Docker, 
- уже есть большая база Kubernetes конфигураций, 
- для автоматизации процессов используется Teamcity, 
- также есть совсем немного Ansible скриптов, 
- и ряд bash скриптов для упрощения рутинных задач.  

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
1. Будет ли центральный сервер для управления инфраструктурой?
1. Будут ли агенты на серверах?
1. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 
 
В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.

### В результате задачи необходимо

1. Ответить на четыре вопроса представленных в разделе "Легенда".

| Вопрос | Ответ |
|-----|-----|
| Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый? | Неизменяемая инфраструктура - будем готовить образы под каждую новую версию кода, например.|
| Будет ли центральный сервер для управления инфраструктурой? | Центральный сервер не нужен, т.к. запускать Terrafrom и Ansible можем с любой машины/сервера |
| Будут ли агенты на серверах? | Также как и в прошлом вопросе - агенты не нужны/не будет агентов. |
| Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? | Да - Terrafrom, например, будет отвечать за инициализацию ресурсов |

2. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта?

```answer1.2
    Packer, Terrafrom, Docker, Kubernetes, Ansible - все перечисленные 
    инструменты способны в полной мере закрыть широкий круг задач любой 
    сложности.
```

3. Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта?

```answer1.3
    В силу личного опыта склонен отказаться от TeamCity в пользу Jenkins или GitLab CI/CD.
```

Если для ответа на эти вопросы недостаточно информации, то напишите какие моменты уточните на совещании.

```answer1.4
    Вообще, еще до начала всех работ - на этапе дизайна будущего решения и 
    его архитектуры - необходимо получить список так называемых 
    нефункциональных требований к будущему сервису/приложению. В него могут 
    входить такие параметры как:
    - Количество входящих запросов (в минуту/час/день/месяц)
    - Ожидаемая скорость предоставления ответа на запрос (min/max/avg)
    - Необходимость обеспечить территориальную близость серверов в различных географических зонах, например
    - Зависимость от внешних систем-источников данных. Доступность как нашего сервиса, так и внешних.
    - Требования по техническому обслуживанию сервиса - максимально допустимые технологические окна, когда сервис будет недоступен и их количество.
    - Мониторинг и отслеживание появления проблем - задержка обнаружения, срок исправления и т.п.
    - Объемы данных, сохраняемых на сервисе внешними пользователями/сервисами, глубина их хранения.
    и т.д.
```

## Задача 2. Установка терраформ. 

Официальный сайт: https://www.terraform.io/

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
В виде результата этой задачи приложите вывод команды `terraform --version`.

```bash
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ sudo apt install terraform
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  bridge-utils dns-root-data dnsmasq-base ubuntu-fan
Use 'sudo apt autoremove' to remove them.
The following NEW packages will be installed:
  terraform
0 upgraded, 1 newly installed, 0 to remove and 52 not upgraded.
Need to get 19.9 MB of archives.
After this operation, 62.9 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com focal/main amd64 terraform amd64 1.2.4 [19.9 MB]
Fetched 19.9 MB in 1s (32.6 MB/s)
Selecting previously unselected package terraform.
(Reading database ... 129915 files and directories currently installed.)
Preparing to unpack .../terraform_1.2.4_amd64.deb ...
Unpacking terraform (1.2.4) ...
Setting up terraform (1.2.4) ...
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ which terraform
/usr/bin/terraform
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ terraform --version
Terraform v1.2.4
on linux_amd64

```

## Задача 3. Поддержка легаси кода. 

В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. 
А код одного из проектов настолько устарел, что не может работать с версией 0.13. 
В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи
штатного менеджера пакетов и устаревшую версию 0.12. 

```answer3.1
    В числе прочих вариантов нашел наиболее удобную, на мой взгляд, утилиту 
    для одновременной работы с несколькими версиями terraform - позволяет 
    переключаться на произвольную версию в интерактивном режиме, а также 
    задавать требуемую прямо из командной строки, что необходимо при работе 
    в составе скриптов. Позволяет легко и быстро получить любую требуемую 
    версию.
    Утилита назывется tfswitch (https://tfswitch.warrensbox.com/Quick-Start/)
```
[tfswitch](https://tfswitch.warrensbox.com/Quick-Start/)

В виде результата этой задачи приложите вывод `--version` двух версий терраформа доступных на вашем компьютере 
или виртуальной машине.

```bash
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | sudo bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  9216  100  9216    0     0  61033      0 --:--:-- --:--:-- --:--:-- 60631
warrensbox/terraform-switcher info checking GitHub for latest tag
warrensbox/terraform-switcher info found version: 0.13.1288 for 0.13.1288/linux/amd64
warrensbox/terraform-switcher info installed /usr/local/bin/tfswitch
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ tfswitch --version

Version: 0.13.1288
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ tfswitch
Creating directory for terraform binary at: /home/ubuntu/.terraform.versions
✔ 1.2.4
Unable to write to: /usr/local/bin/terraform
Creating bin directory at: /home/ubuntu/bin
Creating directory for terraform binary at: /home/ubuntu/bin
RUN `export PATH=$PATH:/home/ubuntu/bin` to append bin to $PATH
Downloading to: /home/ubuntu/.terraform.versions
19895510 bytes downloaded
Switched terraform to version "1.2.4"
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ export PATH=$PATH:/home/ubuntu/bin
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ terraform --version
Terraform v1.2.4
on linux_amd64
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ tfswitch -s 0.12.0
Matched version: 0.12.31
Installing terraform at /home/ubuntu/bin
Downloading to: /home/ubuntu/.terraform.versions
28441056 bytes downloaded
Switched terraform to version "0.12.31"
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ terraform --version
Terraform v0.12.31

Your version of Terraform is out of date! The latest version
is 1.2.4. You can update by downloading from https://www.terraform.io/downloads.html
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ tfswitch
✔ 1.2.4 *recent
Installing terraform at /home/ubuntu/bin
Switched terraform to version "1.2.4"
ubuntu@vm1-amd-1-1:~/07_terraform_01_intro$ terraform --version
Terraform v1.2.4
on linux_amd64
```

---

