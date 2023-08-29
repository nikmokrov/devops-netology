# MySQL cluster
resource "yandex_mdb_mysql_cluster" "mysql" {
  name                = "mysql"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.vpc.id
  version             = "8.0"
#   security_group_ids  = [ ]
  deletion_protection = true

  resources {
    resource_preset_id = "b1.medium" # Intel Broadwell, CPU-50%, 4 GB RAM
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.private-a.id
    name             = "mysql-host-a"
    backup_priority  = 5
    assign_public_ip = true
  }

  host {
    zone            = "ru-central1-b"
    subnet_id       = yandex_vpc_subnet.private-b.id
    name            = "mysql-host-b"
    backup_priority = 10

  }

}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "db_user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "db_user"
  password   = "dbpass123"
  permission {
    database_name = "netology_db"
    roles         = ["ALL"]
  }
}