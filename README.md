# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"
## Задача 1
[versions.tf](07-terraform/versions.tf)</br>

![Bucket](07-terraform/pics/bucket.png "Bucket")

## Задача 2
[main.tf](07-terraform/main.tf)</br>
_Примечание:_ У Яндекса в Compute Cloud не нашел _instance_type_, поэтому просто задаю
разное количество ядер и памяти для stage и prod.
```console
user@host:~$ terraform workspace list
  default
* prod
  stage


user@host:~$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.another-test["1"] will be created
  + resource "yandex_compute_instance" "another-test" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "another-test-1"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "another-test-1.nikmokrov.cloud"
      + id                        = (known after apply)
      + name                      = "another-test-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-b"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd864gbboths76r8gm5f"
              + name        = "root-another-test-1"
              + size        = 32
              + snapshot_id = (known after apply)
              + type        = "network-ssd"
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
          + subnet_id          = "e2loqdquk6b6btrpu62j"
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.another-test["2"] will be created
  + resource "yandex_compute_instance" "another-test" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "another-test-2"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "another-test-2.nikmokrov.cloud"
      + id                        = (known after apply)
      + name                      = "another-test-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-b"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd864gbboths76r8gm5f"
              + name        = "root-another-test-2"
              + size        = 32
              + snapshot_id = (known after apply)
              + type        = "network-ssd"
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
          + subnet_id          = "e2loqdquk6b6btrpu62j"
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.test[0] will be created
  + resource "yandex_compute_instance" "test" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "test-1"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "test-1.nikmokrov.cloud"
      + id                        = (known after apply)
      + name                      = "test-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-b"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd864gbboths76r8gm5f"
              + name        = "root-test-1"
              + size        = 32
              + snapshot_id = (known after apply)
              + type        = "network-ssd"
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
          + subnet_id          = "e2loqdquk6b6btrpu62j"
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.test[1] will be created
  + resource "yandex_compute_instance" "test" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "test-2"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "test-2.nikmokrov.cloud"
      + id                        = (known after apply)
      + name                      = "test-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-b"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd864gbboths76r8gm5f"
              + name        = "root-test-2"
              + size        = 32
              + snapshot_id = (known after apply)
              + type        = "network-ssd"
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
          + subnet_id          = "e2loqdquk6b6btrpu62j"
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_another_test_yandex_cloud = [
      + (known after apply),
      + (known after apply),
    ]
  + external_ip_address_test_yandex_cloud         = [
      + (known after apply),
      + (known after apply),
    ]
  
```