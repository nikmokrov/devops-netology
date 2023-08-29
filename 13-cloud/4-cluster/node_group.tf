# Node group
resource "yandex_kubernetes_node_group" "k8s-ng-a" {
  cluster_id  = yandex_kubernetes_cluster.k8s.id
  name        = "k8s-ng-a"
  description = "Node group A for K8s cluster"
  version     = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
    #   nat      = true
      subnet_ids = [ yandex_vpc_subnet.public-a.id ]
    }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    metadata = {
      ssh-keys = "${var.ssh_user}:${file("~/.ssh/yc_ubuntu.pub")}"
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }  

  allocation_policy {
    location {
      zone       = yandex_vpc_subnet.public-a.zone
    }

  }

}

