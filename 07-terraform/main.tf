# provider
provider "yandex" {
  cloud_id                 = var.yandex_cloud_id
  folder_id                = var.yandex_folder_id
  zone                     = var.zone
}

# test node
module "test" {
  source  = "github.com/glavk/terraform-yandex-compute"
  platform_id = "standard-v2"

  for_each = local.workspace[terraform.workspace]

  folder_id    = var.yandex_folder_id
  zones        = [var.zone]

  image_family = "ubuntu-2204-lts"

  name     = "test-${each.key}"
  hostname = "test-${each.key}.nikmokrov.cloud"

  subnet       = "default-ru-central1-b"
  is_nat   = true

  cores  = local.test_instance_cores_map[terraform.workspace]
  core_fraction = 100
  memory = local.test_instance_memory_map[terraform.workspace]
  size   = "32"

  preemptible = true

}

# output
output "external_ip_address_test_yandex_cloud" {
  value = {
    for k, v in module.test : k => v.external_ip
  }

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