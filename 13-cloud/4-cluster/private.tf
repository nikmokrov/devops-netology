# Private subnet A
resource "yandex_vpc_subnet" "private-a" {
  v4_cidr_blocks = ["192.168.21.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.vpc.id}"
  name           = "private subnet in ru-central1-a zone"
}

# Private subnet B
resource "yandex_vpc_subnet" "private-b" {
  v4_cidr_blocks = ["192.168.22.0/24"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.vpc.id}"
  name           = "private subnet in ru-central1-b zone"
}
