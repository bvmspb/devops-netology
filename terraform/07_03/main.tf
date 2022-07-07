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
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1-${count.index}"

  resources {
    cores  = local.vm-1_cores[terraform.workspace]
    memory = local.vm-1_memory[terraform.workspace]
  }

  count = local.instance_count_map[terraform.workspace]

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
  for_each = var.project

  name = "terraform2-${each.value.name}"

  resources {
    cores  = each.value.instance_cores
    memory = each.value.instance_memory
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

  lifecycle {
    create_before_destroy = true
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

//output "internal_ip_address_vm_1" {
//  value = yandex_compute_instance.vm-1[count.index].network_interface.0.ip_address
//}

//output "internal_ip_address_vm_2" {
//  value = yandex_compute_instance.vm-2[each.key].network_interface.0.ip_address
//}


//output "external_ip_address_vm_1" {
//  value = yandex_compute_instance.vm-1[count.index].network_interface.0.nat_ip_address
//}

//output "external_ip_address_vm_2" {
//  value = yandex_compute_instance.vm-2[each.key].network_interface.0.nat_ip_address
//}

locals {
  vm-1_cores = {
    stage = 2
    prod  = 4
  }
  vm-1_memory = {
    stage = 2
    prod  = 4
  }
}

locals {
  instance_count_map = {
    stage = 1
    prod  = 2
  }
}

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

