# Public subnet
resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.zone
  network_id     = "${yandex_vpc_network.vpc.id}"
  name           = "public subnet"
}

# NAT instance
resource "yandex_compute_instance" "nat-inst" {
  name        = "nat-inst"
  zone        = var.zone
  hostname    = "nat-inst.nikmokrov.cloud"
  description = "NAT Instance"
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = 2
    core_fraction = 50
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8qmbqk94q6rhb4m94t"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}"
    ip_address = "192.168.10.254"
    nat = true
  }

  scheduling_policy {
    preemptible = true
  }

}

# Node in public subnet
resource "yandex_compute_instance" "public-node" {
  name        = "public-node"
  zone        = var.zone
  hostname    = "public-node.nikmokrov.cloud"
  description = "public node instance"
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = 2
    core_fraction = 50
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      name     = "root-public"
      type     = "network-hdd"
      size     = "30"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/yc_ubuntu.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

