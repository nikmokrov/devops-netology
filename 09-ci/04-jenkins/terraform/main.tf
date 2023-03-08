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
  description = each.key
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
      type     = "network-ssd"
      size     = "32"
    }
  }

  network_interface {
    subnet_id = "e2loqdquk6b6btrpu62j" #default-ru-central1-b
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/id_yc_nodes.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

# Inventory file
resource "local_file" "inventory" {
  content = <<-DOC
---
all:
  hosts:
    ${yandex_compute_instance.node["jenkins-master-01"].name}:
      ansible_host: ${yandex_compute_instance.node["jenkins-master-01"].network_interface.0.nat_ip_address}
    ${yandex_compute_instance.node["jenkins-agent-01"].name}:
      ansible_host: ${yandex_compute_instance.node["jenkins-agent-01"].network_interface.0.nat_ip_address}
  children:
    jenkins:
      children:  
        jenkins_masters:
          hosts:
            ${yandex_compute_instance.node["jenkins-master-01"].name}:
        jenkins_agents:
          hosts:
            ${yandex_compute_instance.node["jenkins-agent-01"].name}:   
  vars:
    ansible_connection_type: paramiko
    ansible_user: ${var.ssh_user}
    ansible_ssh_private_key_file: "~/.ssh/id_yc_nodes"
    DOC
  filename = "../infrastructure/inventory/hosts.yml"

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
  default = "fd8jvcoeij6u9se84dt5" # centos-7-base
  # default = "fd86p048esjbfjnmpbs9" # debian-11-base
}

variable "ssh_user" {
  default = "centos"
  # default = "debian"
}

locals {

  nodes = {
    jenkins-master-01 = {
      "cores" = 2
      "memory" = 2
    }
    jenkins-agent-01 = {
      "cores" = 2
      "memory" = 2
    }
  }
}

