terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "nikmokrov1023-infra"
    region     = "ru-central1"
    key        = "terraform/infra.tfstate"
    # access_key = var.YC_ACCESS_KEY
    # secret_key = var.YC_SECRET_KEY

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

# Provider
provider "yandex" {
  # token     = var.YC_SA_KEY
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  service_account_key_file = var.YC_SA_KEY
}
