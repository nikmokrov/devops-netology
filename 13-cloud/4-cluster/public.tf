# Public subnet A
resource "yandex_vpc_subnet" "public-a" {
  v4_cidr_blocks = ["192.168.11.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  name           = "public subnet in ru-central1-a zone"
  route_table_id = yandex_vpc_route_table.nat-route-a.id
}

# Public subnet B
resource "yandex_vpc_subnet" "public-b" {
  v4_cidr_blocks = ["192.168.12.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  name           = "public subnet in ru-central1-b zone"
  route_table_id = yandex_vpc_route_table.nat-route-b.id
}

# Public subnet C
resource "yandex_vpc_subnet" "public-c" {
  v4_cidr_blocks = ["192.168.13.0/24"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.vpc.id
  name           = "public subnet in ru-central1-c zone"
  route_table_id = yandex_vpc_route_table.nat-route-c.id
}

# Gateway for public subnet A
resource "yandex_vpc_gateway" "nat-gw-a" {
  name = "nat-gw-a"
  shared_egress_gateway {}
}

# Gateway for public subnet B
resource "yandex_vpc_gateway" "nat-gw-b" {
  name = "nat-gw-b"
  shared_egress_gateway {}
}

# Gateway for public subnet C
resource "yandex_vpc_gateway" "nat-gw-c" {
  name = "nat-gw-c"
  shared_egress_gateway {}
}

# Route table for private subnet A
resource "yandex_vpc_route_table" "nat-route-a" {
  name       = "nat-route-a"
  network_id = yandex_vpc_network.vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gw-a.id
  }
}

# Route table for private subnet B
resource "yandex_vpc_route_table" "nat-route-b" {
  name       = "nat-route-b"
  network_id = yandex_vpc_network.vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gw-b.id
  }
}

# Route table for private subnet C
resource "yandex_vpc_route_table" "nat-route-c" {
  name       = "nat-route-c"
  network_id = yandex_vpc_network.vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gw-c.id
  }
}