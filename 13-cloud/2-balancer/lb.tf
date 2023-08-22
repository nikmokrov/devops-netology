# Network Load Balancer
resource "yandex_lb_network_load_balancer" "lb-lamp" {
  name        = "network-load-balancer-lamp"
  description = "Load balancer for lamp group"
  folder_id   = var.yandex_folder_id

  listener {
    name = "network-load-balancer-lamp-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-lb.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.php"
      }
    }
  }

}
