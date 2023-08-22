# Instance group for Network Load Balancer
resource "yandex_compute_instance_group" "ig-lb" {
  name                = "ig-lb"
  description         = "instance group for network load balancer"
  folder_id           = var.yandex_folder_id
  service_account_id  = var.sa_id
  deletion_protection = false
  instance_template {
    platform_id = "standard-v2"
    resources {
      memory = 4
      core_fraction = 50
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd89bnqscrmdr57ts7re" # LAMP
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.vpc.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      # nat        = true
    }

    metadata = {
      ssh-keys = "${var.ssh_user}:${file("~/.ssh/yc_ubuntu.pub")}"
      user-data = "${file("lamp-content.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  # health_check {
  #   http_options {
  #     port = 80
  #     path = "/index.php"
  #   }
  # }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }

}


# Instance group for Application Load Balancer
resource "yandex_compute_instance_group" "ig-alb" {
  name                = "ig-alb"
  description         = "instance group for application load balancer"
  folder_id           = var.yandex_folder_id
  service_account_id  = var.sa_id
  deletion_protection = false
  instance_template {
    platform_id = "standard-v2"
    resources {
      memory = 4
      core_fraction = 50
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd89bnqscrmdr57ts7re" # LAMP
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.vpc.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      # nat        = true
    }

    metadata = {
      ssh-keys = "${var.ssh_user}:${file("~/.ssh/yc_ubuntu.pub")}"
      user-data = "${file("lamp-content.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  # health_check {
  #   http_options {
  #     port = 80
  #     path = "/index.php"
  #   }
  # }

  application_load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }

}
