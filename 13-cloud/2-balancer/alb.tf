# Backend group
resource "yandex_alb_backend_group" "alb-backend-group" {
  name                     = "alb-backend-group"
  http_backend {
    name                   = "backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = [ yandex_compute_instance_group.ig-alb.application_load_balancer.0.target_group_id ]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      http_healthcheck {
        path               = "/index.php"
      }
    }
  }
}

# HTTP router
resource "yandex_alb_http_router" "alb-router" {
  name   = "alb-router"
}

# Virtual host
resource "yandex_alb_virtual_host" "alb-vh" {
  name           = "alb-virtual-host"
  http_router_id = yandex_alb_http_router.alb-router.id
  route {
    name = "http-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.alb-backend-group.id
        timeout          = "60s"
      }
    }
  }
}  


# Application Load Balancer
resource "yandex_alb_load_balancer" "alb-lamp" {
  name        = "application-load-balancer-lamp"
  description = "Application load balancer for lamp group"

  network_id  = yandex_vpc_network.vpc.id

  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = yandex_vpc_subnet.public.id 
    }
  }

  listener {
    name = "application-load-balancer-lamp-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb-router.id
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent = 75
    }
  }
}

