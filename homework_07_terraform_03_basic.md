# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 terraform 07.03 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «7.3. Основы и принцип работы Терраформ»

# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

```answer1
    Я пропускаю все, что касается AWS, т.к. данные сервисы нам в России сейчас 
    "не очень" доступны.
    
    Также я не стал пока делать хранилище в бакете в YC - опасаюсь за расход 
    средств на хранилище и думаю вернуться к этому уже в ходе работы над 
    дипломом.
```

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.

```answer2-1
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ mkdir 07_03
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ cp *.tf ./07_03/
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform$ cd 07_03/
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform init
   
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
```

2. Создайте два воркспейса `stage` и `prod`.

```answer2-2
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform workspace new stage
   Created and switched to workspace "stage"!
   
   You're now on a new, empty workspace. Workspaces isolate their state,
   so if you run "terraform plan" Terraform will not see any existing state
   for this configuration.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform workspace new prod
   Created and switched to workspace "prod"!
   
   You're now on a new, empty workspace. Workspaces isolate their state,
   so if you run "terraform plan" Terraform will not see any existing state
   for this configuration.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform workspace list
     default
   * prod
     stage
```

3. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.

```answer2-3
   Здесь я не сразу понял про instance_type, но из лекции понял, что это тип 
   создаваемой ВМ в терминологии AWS - tiny, mini, micro, large и т.п. 
   То есть ресурс, который мы создаем, насколько большим он нужен.
   А aws_instance - это просто ресурс, в терминологии terraform.
   
   В нашем случае, с YC, это должны быть cores и memory для vm-1 и/или vm-2.
   (Реально пришлось потратить время, чтобы пересмотреть видео, где в 
   презентации есть примеры, чтобы разобраться с заданием)
   Переделаю ресурс vm-1 для этого таким образом, чтобы stage требовал меньше 
   ресурсов, чем prod:
```
```answer2-3.code
[...]

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = local.vm-1_cores[terraform.workspace]
    memory = local.vm-1_memory[terraform.workspace]
  }
[...]
locals {
  vm-1_cores = {
    stage = 2
    prod = 3
  }
  vm-1_memory = {
    stage = 2
    prod = 3
  }
}
```

4. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два.

```answer2-4
   Снова не сразу понял что такое ec2, но в итоге выяснил, что это, по сути, 
   экземпляр виртуальной машины, которую мы создаем и запускаем в YC.
   
   Таким образом нужно добавить параметр счетчика, который будет определять 
   количество одинаковых (однотипных) ВМ, которые нужно запустить в рамках 
   ресурса vm-1 terraform.
   
   Попутно выяснилось, что в output нельзя использовать count и потому 
   просто убрал эти блоки для vm-1 (из стандартного примера от Яндекс, 
   который изначально использовал), чтобы сохранить работоспособность плана:
```
```answer2-4.code
   resource "yandex_compute_instance" "vm-1" {
     name = "terraform1-${count.index}"
   
     resources {
       cores  = local.vm-1_cores[terraform.workspace]
       memory = local.vm-1_memory[terraform.workspace]
     }
   
     count = local.instance_count_map[terraform.workspace]
   [...]
   locals {
     instance_count_map = {
       stage = 1
       prod = 2
     }
   }
```

5. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.

```answer2-5
   У меня уже есть второй ресурс vm-2 - попробую переделать его. Использую 
   документацию:
   https://www.terraform.io/language/meta-arguments/for_each
   https://learn.hashicorp.com/tutorials/terraform/for-each?in=terraform/0-13
   
   Вынесено в отдельной секции variables описание каждого требуемого 
   отдельного инстанса для vm-2 ресурса. В учебники из ссылки выше так
   даже подсети задавались для каждого инстанса - не только 
   индивидуальная настройка имени и количества ядер cpu с памятью.
   
   Интересное наблюдение: столкнулся с проблемой того, что нельзя пытаться 
   создать ВМ с числом ядер, например, не кратным 2.
```
```answer2-5.code
   resource "yandex_compute_instance" "vm-2" {
     for_each = var.project
   
     name = "terraform2-${each.value.name}"
   
     resources {
       cores  = each.value.instance_cores
       memory = each.value.instance_memory
     }
   
   [....]
   
   variable "project" {
     description = "Map of project names to configuration."
     type        = map(any)
     default = {
       instance-1 = {
         instance_cores  = 2,
         instance_memory = 2,
         name            = "instance-1"
       },
       instance-2 = {
         instance_cores  = 4,
         instance_memory = 4,
         name            = "instance-2"
       }
     }
   }
```

6. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.

```answer2-6
   Добавил в ресурс vm-2 следующий фрагмент:
     lifecycle {
       create_before_destroy = true
     }
```

7. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.

```bash
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform workspace list
     default
     prod
   * stage
```

* Вывод команды `terraform plan` для воркспейса `prod`.  

```bash
bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform workspace select prod
Switched to workspace "prod".
bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform plan 

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1[0] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AzzzzxxxxSecretKeyWasHereiuIPE= bvm@RU1L0605
            EOT
        }
      + name                      = "terraform1-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81u2vhv3mc49l1ccbb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1[1] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AzzzzxxxxSecretKeyWasHereiuIPE= bvm@RU1L0605
            EOT
        }
      + name                      = "terraform1-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81u2vhv3mc49l1ccbb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-2["instance-1"] will be created
  + resource "yandex_compute_instance" "vm-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AzzzzxxxxSecretKeyWasHereiuIPE= bvm@RU1L0605
            EOT
        }
      + name                      = "terraform2-instance-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81u2vhv3mc49l1ccbb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-2["instance-2"] will be created
  + resource "yandex_compute_instance" "vm-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AzzzzxxxxSecretKeyWasHereiuIPE= bvm@RU1L0605
            EOT
        }
      + name                      = "terraform2-instance-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81u2vhv3mc49l1ccbb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptanswer2-final1ible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.
```

```answer-final-demo
   Запустил на stage apply (чтобы меньше ресурсов выделилось и 
   израсходовалось у меня со счета, соответственно).
   Прикладываю логи apply, проверки возможности подключиться к 
   одной из созданных машин и затем destroy:
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform apply
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
     + create
   
   Terraform will perform the following actions:
   
     # yandex_compute_instance.vm-1[0] will be created
   [.......]
   
   Plan: 5 to add, 0 to change, 0 to destroy.
   
   Do you want to perform these actions in workspace "stage"?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.
   
     Enter a value: yes 
   
   yandex_vpc_network.network-1: Creating...
   yandex_vpc_network.network-1: Creation complete after 1s [id=enpfhp0k77c91as3h3v0]
   yandex_vpc_subnet.subnet-1: Creating...
   yandex_vpc_subnet.subnet-1: Creation complete after 1s [id=e9b6md91ishpd1ehnbm8]
   yandex_compute_instance.vm-2["instance-2"]: Creating...
   yandex_compute_instance.vm-1[0]: Creating...
   yandex_compute_instance.vm-2["instance-1"]: Creating...
   yandex_compute_instance.vm-1[0]: Still creating... [10s elapsed]
   yandex_compute_instance.vm-2["instance-2"]: Still creating... [10s elapsed]
   yandex_compute_instance.vm-2["instance-1"]: Still creating... [10s elapsed]
   yandex_compute_instance.vm-2["instance-2"]: Still creating... [20s elapsed]
   yandex_compute_instance.vm-1[0]: Still creating... [20s elapsed]
   yandex_compute_instance.vm-2["instance-1"]: Still creating... [20s elapsed]
   yandex_compute_instance.vm-2["instance-2"]: Creation complete after 27s [id=fhmrh35snsme6leodaih]
   yandex_compute_instance.vm-1[0]: Creation complete after 27s [id=fhm8rfepn2cpi1bfb0j1]
   yandex_compute_instance.vm-2["instance-1"]: Creation complete after 28s [id=fhmem820521b4vtlifat]
   
   Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ ssh ubuntu@51.250.3.176
   The authenticity of host '51.250.3.176 (51.250.3.176)' can't be established.
   ECDSA key fingerprint is SHA256:MB1b1jxcC7BToAVxrLpo7ulaTNvilN5T2/Pqkp8bnpo.
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   Warning: Permanently added '51.250.3.176' (ECDSA) to the list of known hosts.
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
   
   ubuntu@fhm8rfepn2cpi1bfb0j1:~$ exit
   logout
   Connection to 51.250.3.176 closed.
   bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/terraform/07_03$ terraform destroy
   yandex_vpc_network.network-1: Refreshing state... [id=enpfhp0k77c91as3h3v0]
   yandex_vpc_subnet.subnet-1: Refreshing state... [id=e9b6md91ishpd1ehnbm8]
   yandex_compute_instance.vm-2["instance-1"]: Refreshing state... [id=fhmem820521b4vtlifat]
   yandex_compute_instance.vm-1[0]: Refreshing state... [id=fhm8rfepn2cpi1bfb0j1]
   yandex_compute_instance.vm-2["instance-2"]: Refreshing state... [id=fhmrh35snsme6leodaih]
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
     - destroy
   
   Terraform will perform the following actions:
   
     # yandex_compute_instance.vm-1[0] will be destroyed
   [.......]
   
   Plan: 0 to add, 0 to change, 5 to destroy.
   
   Do you really want to destroy all resources in workspace "stage"?
     Terraform will destroy all your managed infrastructure, as shown above.
     There is no undo. Only 'yes' will be accepted to confirm.
   
     Enter a value: yes
   
   yandex_compute_instance.vm-2["instance-1"]: Destroying... [id=fhmem820521b4vtlifat]
   yandex_compute_instance.vm-1[0]: Destroying... [id=fhm8rfepn2cpi1bfb0j1]
   yandex_compute_instance.vm-2["instance-2"]: Destroying... [id=fhmrh35snsme6leodaih]
   yandex_compute_instance.vm-2["instance-1"]: Still destroying... [id=fhmem820521b4vtlifat, 10s elapsed]
   yandex_compute_instance.vm-1[0]: Still destroying... [id=fhm8rfepn2cpi1bfb0j1, 10s elapsed]
   yandex_compute_instance.vm-2["instance-2"]: Still destroying... [id=fhmrh35snsme6leodaih, 10s elapsed]
   yandex_compute_instance.vm-2["instance-1"]: Destruction complete after 12s
   yandex_compute_instance.vm-1[0]: Destruction complete after 13s
   yandex_compute_instance.vm-2["instance-2"]: Destruction complete after 17s
   yandex_vpc_subnet.subnet-1: Destroying... [id=e9b6md91ishpd1ehnbm8]
   yandex_vpc_subnet.subnet-1: Destruction complete after 6s
   yandex_vpc_network.network-1: Destroying... [id=enpfhp0k77c91as3h3v0]
   yandex_vpc_network.network-1: Destruction complete after 0s
   
   Destroy complete! Resources: 5 destroyed.
```

---
