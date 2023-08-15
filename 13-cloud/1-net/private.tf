# Private subnet
resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.zone
  network_id     = "${yandex_vpc_network.vpc.id}"
  name           = "private subnet"
  route_table_id = yandex_vpc_route_table.nat-route.id
}

# Route table for private subnet
resource "yandex_vpc_route_table" "nat-route" {
  name       = "nat-route"
  network_id = "${yandex_vpc_network.vpc.id}"
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-inst.network_interface.0.ip_address
  }
}

# Node in private subnet
resource "yandex_compute_instance" "private-node" {
  name        = "private-node"
  zone        = var.zone
  hostname    = "private-node.nikmokrov.cloud"
  description = "private node instance"
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
      name     = "root-private"
      type     = "network-hdd"
      size     = "30"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private.id}"
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/yc_ubuntu.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

