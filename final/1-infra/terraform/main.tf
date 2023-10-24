terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

# Provider
provider "yandex" {
  cloud_id   = var.cloud_id
  folder_id  = var.folder_id
  zone       = var.zone
}
