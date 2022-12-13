# provider
provider "yandex" {
  cloud_id                 = "b1gcn03m319mu8kiic9q"
  folder_id                = "b1ga7t052sv70padtm26"
  zone                     = "ru-central1-b"
}

resource "yandex_compute_image" "ubuntu-2204-lts" {
  name       = "ubuntu-2204-lts"
  source_image = "fd8smb7fj0o91i68s15v"
}

# test-node
resource "yandex_compute_instance" "test-node" {
  name        = "test-node"
  zone        = "ru-central1-b"
  hostname    = "test-node.nikmokrov.cloud"
  description = "test-node"
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = 2
    core_fraction = 100
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu-2204-lts.id
      name     = "root-test-node"
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
output "external_ip_address_test-node_yandex_cloud" {
  value = yandex_compute_instance.test-node.network_interface.0.nat_ip_address
}

