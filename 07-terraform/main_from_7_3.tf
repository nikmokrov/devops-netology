# provider
provider "yandex" {
  cloud_id                 = var.yandex_cloud_id
  folder_id                = var.yandex_folder_id
  zone                     = var.zone
}

# test node
resource "yandex_compute_instance" "test" {
  name        = "test-${count.index + 1}"
  zone        = var.zone
  hostname    = "test-${count.index + 1}.nikmokrov.cloud"
  description = "test-${count.index + 1}"
  platform_id = "standard-v2"
  count       = local.test_instance_count_map[terraform.workspace]


  allow_stopping_for_update = true

  resources {
    cores         = local.test_instance_cores_map[terraform.workspace]
    core_fraction = 100
    memory        = local.test_instance_memory_map[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      name     = "root-test-${count.index + 1}"
      type     = "network-ssd"
      size     = "32"
    }
  }

  network_interface {
    subnet_id = "e2loqdquk6b6btrpu62j"
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

}


# another test node
resource "yandex_compute_instance" "another-test" {
  for_each    = local.workspace[terraform.workspace]
  name        = "another-test-${each.value}"
  zone        = var.zone
  hostname    = "another-test-${each.value}.nikmokrov.cloud"
  description = "another-test-${each.value}"
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores         = local.test_instance_cores_map[terraform.workspace]
    core_fraction = 100
    memory        = local.test_instance_memory_map[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      name     = "root-another-test-${each.value}"
      type     = "network-ssd"
      size     = "32"
    }
  }

  network_interface {
    subnet_id = "e2loqdquk6b6btrpu62j"
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

}

# output
output "external_ip_address_test_yandex_cloud" {
  value = [ for test in yandex_compute_instance.test: format("%s - %s", test.hostname, test.network_interface.0.nat_ip_address) ]
}

output "external_ip_address_another_test_yandex_cloud" {
  value = [ for atest in yandex_compute_instance.another-test: format("%s - %s", atest.hostname, atest.network_interface.0.nat_ip_address) ]
}

# variables
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
  default = "fd864gbboths76r8gm5f" # ubuntu-2204-lts
}

locals {
  test_instance_cores_map = {
    default = 2
    stage = 2
    prod = 4
  }
  test_instance_memory_map = {
    default = 4
    stage = 4
    prod = 8
  }
  test_instance_count_map = {
    default = 1
    stage = 1
    prod = 2
  }

  workspace = {
    default = {
      "1" = "1"
    }
    stage = {
      "1" = "1"
    }
    prod = {
      "1" = "1"
      "2" = "2"
    }

  }
}