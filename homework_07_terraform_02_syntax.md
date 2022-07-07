# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 terraform 07.02 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «7.2. Облачные провайдеры и синтаксис Terraform.»

# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются. 

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

```answer1.0
    Пропускаю все, что касается AWS в задании, т.к. с ним сейчас работать 
    нормально не получается.
    
    OAuth token и cloud id хранятся в переменных окружения.
    
    SSH ключ не стал прописывать (как написано в обучающей статье Яндекс) 
    в .txt файле, чтобы не добавлять его потом в исключения для git'а - 
    использую ссылку на защищенный ключ в ~./ssh каталоге.
    
    Init прошел успешно - провайдер скачался без проблем. Стенд 
    развернулся и стал доступен примерно за 1-2 минуты, после чего успешно 
    отработал destroy.
```

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов. 

AWS предоставляет достаточно много бесплатных ресурсов в первый год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
1. Создайте аккаут aws.
1. Установите c aws-cli https://aws.amazon.com/cli/.
1. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
1. Создайте IAM политику для терраформа c правами
    * AmazonEC2FullAccess
    * AmazonS3FullAccess
    * AmazonDynamoDBFullAccess
    * AmazonRDSFullAccess
    * CloudWatchFullAccess
    * IAMFullAccess
1. Добавьте переменные окружения 
    ```
    export AWS_ACCESS_KEY_ID=(your access key id)
    export AWS_SECRET_ACCESS_KEY=(your secret access key)
    ```
1. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. 

В виде результата задания приложите вывод команды `aws configure list`.

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.


## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
   внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?

```answer1-1
   Packer is a free and open source tool for creating golden images for 
   multiple platforms from a single source configuration.
```

2. Ссылку на репозиторий с исходной конфигурацией терраформа.  

```answer1-2
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology$ mkdir terraform
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology$ cd terraform/
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ touch main.tf versions.tf
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ ls -l
   итого 0
   -rw-rw-r-- 1 bvm bvm 0 июл  7 11:06 main.tf
   -rw-rw-r-- 1 bvm bvm 0 июл  7 11:06 versions.tf
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ source "/home/bvm/.bashrc"
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ yc --version
   Yandex Cloud CLI 0.92.0 linux/amd64packer
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ source "/home/bvm/.profile"
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ terraform --version
   Terraform v1.1.9
   on linux_amd64
   
   Your version of Terraform is out of date! The latest version
   is 1.2.4. You can update by downloading from https://www.terraform.io/downloads.html
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology$ export TF_VAR_yc_token=AQxxx_MySecretOAuthToken_here
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology$ export TF_VAR_yc_cloud_id=b1gfdt5clqpa6a2m5qrh
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ cat ~/.terraformrc 
   provider_installation {
     network_mirror {
       url = "https://terraform-mirror.yandexcloud.net/"
       include = ["registry.terraform.io/*/*"]
     }
     direct {
       exclude = ["registry.terraform.io/*/*"]
     }
   }
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ yc compute image list --folder-id standard-images | grep ubuntu-20-04-lts-v2022
   | fd81u2vhv3mc49l1ccbb | ubuntu-20-04-lts-v20220704                                     | ubuntu-2004-lts                                 | f2e92qu6f879vvpe8jad           | READY  |
[.....]
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ cat main.tf 
   terraform {
     required_providers {
       yandex = {
         source = "yandex-cloud/yandex"
       }
     }
     required_version = ">= 0.13"
   }
   
   # Provider
   provider "yandex" {
     token     = "${var.yc_token}"
     cloud_id  = "${var.yc_cloud_id}"
     folder_id = "${var.yc_folder_id}"
     zone      = "${var.yc_region}"
   }
   
   resource "yandex_compute_instance" "vm-1" {
     name = "terraform1"
   
     resources {
       cores  = 2
       memory = 2
     }
   
     boot_disk {
       initialize_params {
         image_id = "fd81u2vhv3mc49l1ccbb"
       }
     }
   
     network_interface {
       subnet_id = yandex_vpc_subnet.subnet-1.id
       nat       = true
     }
   
     metadata = {
       ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
     }
   }
   
   resource "yandex_compute_instance" "vm-2" {
     name = "terraform2"
   
     resources {
       cores  = 4
       memory = 4
     }
   
     boot_disk {
       initialize_params {
         image_id = "fd81u2vhv3mc49l1ccbb"
       }
     }
   
     network_interface {
       subnet_id = yandex_vpc_subnet.subnet-1.id
       nat       = true
     }
   
     metadata = {
       ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
     }
   }
   
   resource "yandex_vpc_network" "network-1" {
     name = "network1"
   }
   
   resource "yandex_vpc_subnet" "subnet-1" {
     name           = "subnet1"
     zone           = "ru-central1-a"
     network_id     = yandex_vpc_network.network-1.id
     v4_cidr_blocks = ["192.168.10.0/24"]
   }
   
   output "internal_ip_address_vm_1" {
     value = yandex_compute_instance.vm-1.network_interface.0.ip_address
   }
   
   output "internal_ip_address_vm_2" {
     value = yandex_compute_instance.vm-2.network_interface.0.ip_address
   }
   
   
   output "external_ip_address_vm_1" {
     value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
   }
   
   output "external_ip_address_vm_2" {
     value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
   }
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ cat variables.tf 
   variable "yc_token" {
      default = ""
   }
   
   variable "yc_cloud_id" {
     default = ""
   }
   
   variable "yc_folder_id" {
     default = "b1gd865fdlfab6ioe3j8"
   }
   
   variable "yc_region" {
     default = "ru-central1-a"
   }
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ terraform init
   
   Initializing the backend...
   
   Initializing provider plugins...
   - Finding latest version of yandex-cloud/yandex...
   - Installing yandex-cloud/yandex v0.76.0...
   - Installed yandex-cloud/yandex v0.76.0 (unauthenticated)
   
   Terraform has created a lock file .terraform.lock.hcl to record the provider
   selections it made above. Include this file in your version control repository
   so that Terraform can guarantee to make the same selections by default when
   you run "terraform init" in the future.
   
   Terraform has been successfully initialized!
   
   You may now begin working with Terraform. Try running "terraform plan" to see
   any changes that are required for your infrastructure. All Terraform commands
   should now work.
   
   If you ever set or change modules or backend configuration for Terraform,
   rerun this command to reinitialize your working directory. If you forget, other
   commands will detect it and remind you to do so if necessary.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ terraform validate
   Success! The configuration is valid.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ terraform plan
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
   following symbols:
     + create
   
   Terraform will perform the following actions:
   
     # yandex_compute_instance.vm-1 will be created
     + resource "yandex_compute_instance" "vm-1" {
         + created_at                = (known after apply)
         + folder_id                 = (known after apply)
         + fqdn                      = (known after apply)
         + hostname                  = (known after apply)
         + id                        = (known after apply)
         + metadata                  = {
             + "ssh-keys" = <<-EOT
                   ubuntu:ssh-rsa 
   
   [.....]
   
   Plan: 4 to add, 0 to change, 0 to destroy.
   
   Changes to Outputs:
     + external_ip_address_vm_1 = (known after apply)
     + external_ip_address_vm_2 = (known after apply)
     + internal_ip_address_vm_1 = (known after apply)
     + internal_ip_address_vm_2 = (known after apply)
   
   ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   
   Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
   "terraform apply" now.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ terraform apply
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
   following symbols:
     + create
   
   Terraform will perform the following actions:
   
   [.......]
   
   Plan: 4 to add, 0 to change, 0 to destroy.
   
   Changes to Outputs:
     + external_ip_address_vm_1 = (known after apply)
     + external_ip_address_vm_2 = (known after apply)
     + internal_ip_address_vm_1 = (known after apply)
     + internal_ip_address_vm_2 = (known after apply)
   
   Do you want to perform these actions?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.
   
     Enter a value: yes
   
   yandex_vpc_network.network-1: Creating...
   yandex_vpc_network.network-1: Creation complete after 1s [id=enpjcc1s8k1hm2n87ef2]
   yandex_vpc_subnet.subnet-1: Creating...
   yandex_vpc_subnet.subnet-1: Creation complete after 1s [id=e9b9csklja2lb535utqu]
   yandex_compute_instance.vm-2: Creating...
   yandex_compute_instance.vm-1: Creating...
   yandex_compute_instance.vm-1: Still creating... [10s elapsed]
   yandex_compute_instance.vm-2: Still creating... [10s elapsed]
   yandex_compute_instance.vm-2: Still creating... [20s elapsed]
   yandex_compute_instance.vm-1: Still creating... [20s elapsed]
   yandex_compute_instance.vm-2: Creation complete after 25s [id=fhm1k91mjervdn51p652]
   yandex_compute_instance.vm-1: Creation complete after 26s [id=fhmrvinfi3kj5s3r55rd]
   
   Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
   
   Outputs:
   
   external_ip_address_vm_1 = "51.250.70.239"
   external_ip_address_vm_2 = "51.250.66.231"
   internal_ip_address_vm_1 = "192.168.10.20"
   internal_ip_address_vm_2 = "192.168.10.6"
   
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ ssh ubuntu@51.250.70.239
   ssh: connect to host 51.250.70.239 port 22: Connection refused
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ ssh ubuntu@51.250.70.239
   The authenticity of host '51.250.70.239 (51.250.70.239)' can't be established.
   ECDSA key fingerprint is SHA256:+wOEchrWRWRcOOQyYTynZ3UWvMsJ24aHJr0G8L5EAsc.
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   Warning: Permanently added '51.250.70.239' (ECDSA) to the list of known hosts.
   Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-121-generic x86_64)
   
    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage
   
   The programs included with the Ubuntu system are free software;
   the exact distribution terms for each program are described in the
   individual files in /usr/share/doc/*/copyright.
   
   Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
   applicable law.
   
   To run a command as administrator (user "root"), use "sudo <command>".
   See "man sudo_root" for details.
   
   ubuntu@fhmrvinfi3kj5s3r55rd:~$ exit
   logout
   Connection to 51.250.70.239 closed.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ ssh ubuntu@51.250.66.231
   The authenticity of host '51.250.66.231 (51.250.66.231)' can't be established.
   ECDSA key fingerprint is SHA256:i53pmqxefnljFAcMnHN/woUO56GXZvSWn0MhBVMSVhI.
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   Warning: Permanently added '51.250.66.231' (ECDSA) to the list of known hosts.
   Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-121-generic x86_64)
   
    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage
   
   The programs included with the Ubuntu system are free software;
   the exact distribution terms for each program are described in the
   individual files in /usr/share/doc/*/copyright.
   
   Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
   applicable law.
   
   To run a command as administrator (user "root"), use "sudo <command>".
   See "man sudo_root" for details.
   
   ubuntu@fhm1k91mjervdn51p652:~$ exit
   logout
   Connection to 51.250.66.231 closed.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ terraform destroy
   yandex_vpc_network.network-1: Refreshing state... [id=enpjcc1s8k1hm2n87ef2]
   yandex_vpc_subnet.subnet-1: Refreshing state... [id=e9b9csklja2lb535utqu]
   yandex_compute_instance.vm-2: Refreshing state... [id=fhm1k91mjervdn51p652]
   yandex_compute_instance.vm-1: Refreshing state... [id=fhmrvinfi3kj5s3r55rd]
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
   following symbols:
     - destroy
   
   Terraform will perform the following actions:
   
   [.......]
   
   Plan: 0 to add, 0 to change, 4 to destroy.
   
   Changes to Outputs:
     - external_ip_address_vm_1 = "51.250.70.239" -> null
     - external_ip_address_vm_2 = "51.250.66.231" -> null
     - internal_ip_address_vm_1 = "192.168.10.20" -> null
     - internal_ip_address_vm_2 = "192.168.10.6" -> null
   
   Do you really want to destroy all resources?
     Terraform will destroy all your managed infrastructure, as shown above.
     There is no undo. Only 'yes' will be accepted to confirm.
   
     Enter a value: yes
   
   yandex_compute_instance.vm-1: Destroying... [id=fhmrvinfi3kj5s3r55rd]
   yandex_compute_instance.vm-2: Destroying... [id=fhm1k91mjervdn51p652]
   yandex_compute_instance.vm-1: Still destroying... [id=fhmrvinfi3kj5s3r55rd, 10s elapsed]
   yandex_compute_instance.vm-2: Still destroying... [id=fhm1k91mjervdn51p652, 10s elapsed]
   yandex_compute_instance.vm-1: Still destroying... [id=fhmrvinfi3kj5s3r55rd, 20s elapsed]
   yandex_compute_instance.vm-2: Still destroying... [id=fhm1k91mjervdn51p652, 20s elapsed]
   yandex_compute_instance.vm-1: Destruction complete after 23s
   yandex_compute_instance.vm-2: Destruction complete after 23s
   yandex_vpc_subnet.subnet-1: Destroying... [id=e9b9csklja2lb535utqu]
   yandex_vpc_subnet.subnet-1: Destruction complete after 6s
   yandex_vpc_network.network-1: Destroying... [id=enpjcc1s8k1hm2n87ef2]
   yandex_vpc_network.network-1: Destruction complete after 1s
   
   Destroy complete! Resources: 4 destroyed.
```

 
---
