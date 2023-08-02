# Provider 
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "yandex" {
  cloud_id                 = var.yandex_cloud_id
  folder_id                = var.yandex_folder_id
  zone                     = var.zone
}


# Nodes
resource "yandex_compute_instance" "node" {
  for_each    = local.nodes
  name        = each.key
  zone        = var.zone
  hostname    = "${each.key}.nikmokrov.cloud"
  description = each.value["desc"]
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = each.value["cores"]
    core_fraction = 100
    memory        = each.value["memory"]
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      name     = "root-${each.key}"
      type     = "network-hdd"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = "e2loqdquk6b6btrpu62j" #default-ru-central1-b
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/yc_ubuntu.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

# Inventory file
resource "local_file" "inventory" {
  content = <<-DOC
all:
  hosts:
    ${yandex_compute_instance.node["master1"].name}:
      ansible_host: ${yandex_compute_instance.node["master1"].network_interface.0.nat_ip_address}
    ${yandex_compute_instance.node["worker1"].name}:
      ansible_host: ${yandex_compute_instance.node["worker1"].network_interface.0.nat_ip_address}
    ${yandex_compute_instance.node["worker2"].name}:
      ansible_host: ${yandex_compute_instance.node["worker2"].network_interface.0.nat_ip_address}
    ${yandex_compute_instance.node["worker3"].name}:
      ansible_host: ${yandex_compute_instance.node["worker3"].network_interface.0.nat_ip_address}
    ${yandex_compute_instance.node["worker4"].name}:
      ansible_host: ${yandex_compute_instance.node["worker4"].network_interface.0.nat_ip_address}                  
  children:
    k8s:
      children:  
        masters:
          hosts:
            ${yandex_compute_instance.node["master1"].name}:
        workers:
          hosts:
            ${yandex_compute_instance.node["worker1"].name}:
            ${yandex_compute_instance.node["worker2"].name}:
            ${yandex_compute_instance.node["worker3"].name}:
            ${yandex_compute_instance.node["worker4"].name}:                                    
  vars:
    ansible_connection_type: paramiko
    ansible_user: ${var.ssh_user}
    ansible_ssh_private_key_file: "~/.ssh/yc_ubuntu"
    DOC
  filename = "../playbook/inventory/prod.yml"

  depends_on = [
    yandex_compute_instance.node,
  ]
}

# Output
output "external_ip_address_node" {
  value = [ for n in yandex_compute_instance.node: format("%s - %s", n.hostname, n.network_interface.0.nat_ip_address) ]
}

# Variables
variable "yandex_cloud_id" {
  default = "b1gcn03m319mu8kiic9q"
}

variable "yandex_folder_id" {
  default = "b1ga7t052sv70padtm26"
}

variable "zone" {
  default = "ru-central1-b"
}

variable "image_id" {
  type = string
  # default = "fd8jvcoeij6u9se84dt5" # centos-7-base
  # default = "fd89dg1rq7uqslc6eigm" # debian-11
  # default = "fd8ps4vdhf5hhuj8obp2" # ubuntu-2204-lts
  default = "fd8s1rt9rlesqptbevhg" # ubuntu-2004-lts
}

variable "ssh_user" {
  # default = "centos"
  # default = "debian"
  default = "ubuntu"
}

locals {

  nodes = {
    master1 = {
      "cores" = 4
      "memory" = 16
      "desc" = "master node"
    }
    worker1 = {
      "cores" = 2
      "memory" = 8
      "desc" = "worker node"
    }
    worker2 = {
      "cores" = 2
      "memory" = 8
      "desc" = "worker node"
    }
    worker3 = {
      "cores" = 2
      "memory" = 8
      "desc" = "worker node"
    }
    worker4 = {
      "cores" = 2
      "memory" = 8
      "desc" = "worker node"
    }
  }
}