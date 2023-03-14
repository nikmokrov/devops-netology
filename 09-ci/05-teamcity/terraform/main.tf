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

data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

# Nodes
resource "yandex_compute_instance" "teamcity-server" {
  name        = "teamcity-server"
  zone        = var.zone
  hostname    = "teamcity-server.nikmokrov.cloud"
  description = "teamcity-server"
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = 4
    core_fraction = 100
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      name     = "root-teamcity-server"
      type     = "network-ssd"
      size     = "32"
    }
  }

  network_interface {
    subnet_id = "e2loqdquk6b6btrpu62j" #default-ru-central1-b
    nat       = true
  }

  metadata = {
    docker-container-declaration = file("${path.module}/teamcity-server.yaml")
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/id_yc_nodes.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

resource "yandex_compute_instance" "teamcity-agent" {
  name        = "teamcity-agent"
  zone        = var.zone
  hostname    = "teamcity-agent.nikmokrov.cloud"
  description = "teamcity-agent"
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = 2
    core_fraction = 100
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      name     = "root-teamcity-agent"
      type     = "network-ssd"
      size     = "32"
    }
  }

  network_interface {
    subnet_id = "e2loqdquk6b6btrpu62j" #default-ru-central1-b
    nat       = true
  }

  metadata = {
    docker-container-declaration = file("${path.module}/teamcity-agent.yaml")
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/id_yc_nodes.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

  depends_on = [ local_file.agent-declaration ]

}

resource "yandex_compute_instance" "nexus-01" {
  name        = "nexus-01"
  zone        = var.zone
  hostname    = "nexus-01.nikmokrov.cloud"
  description = "nexus-01"
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = 2
    core_fraction = 100
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      name     = "root-nexus-01"
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
    ${yandex_compute_instance.nexus-01.name}:
      ansible_host: ${yandex_compute_instance.nexus-01.network_interface.0.nat_ip_address}
  children:
    nexus:
      hosts:
        ${yandex_compute_instance.nexus-01.name}:
  vars:
    ansible_connection_type: paramiko
    ansible_user: ${var.ssh_user}
    ansible_ssh_private_key_file: "~/.ssh/id_yc_nodes"
    DOC
  filename = "../infrastructure/inventory/cicd/hosts.yml"

  depends_on = [
    yandex_compute_instance.nexus-01,
  ]
}

resource "local_file" "agent-declaration" {
  content = <<-DOC
spec:
  containers:
  - image: jetbrains/teamcity-agent
    env:
    - name: SERVER_URL
      value: http://${yandex_compute_instance.teamcity-server.network_interface.0.nat_ip_address}:8111
    securityContext:
      privileged: false
    stdin: false
    tty: false
    DOC
  filename = "./teamcity-agent.yaml"

  depends_on = [
    yandex_compute_instance.teamcity-server,
  ]
  
  lifecycle {
      create_before_destroy = true
  }

}

# Output
output "teamcity_server_external_ip_address" {
  value = yandex_compute_instance.teamcity-server.network_interface.0.nat_ip_address
}
output "teamcity_agent_external_ip_address" {
  value = yandex_compute_instance.teamcity-agent.network_interface.0.nat_ip_address
}
output "nexus_external_ip_address" {
  value = yandex_compute_instance.nexus-01.network_interface.0.nat_ip_address
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
