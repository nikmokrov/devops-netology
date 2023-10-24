# Node groups
resource "yandex_kubernetes_node_group" "k8s-ng-a" {
  cluster_id  = yandex_kubernetes_cluster.k8s.id
  name        = "k8s-ng-a"
  description = "Node group A for K8s cluster"
  version     = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
    #   nat      = true
      subnet_ids = [ yandex_vpc_subnet.subnet-a.id ]
    }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 50
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
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone       = yandex_vpc_subnet.subnet-a.zone
    }

  }

}


resource "yandex_kubernetes_node_group" "k8s-ng-b" {
  cluster_id  = yandex_kubernetes_cluster.k8s.id
  name        = "k8s-ng-b"
  description = "Node group B for K8s cluster"
  version     = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
    #   nat      = true
      subnet_ids = [ yandex_vpc_subnet.subnet-b.id ]
    }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 50
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
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone       = yandex_vpc_subnet.subnet-b.zone
    }

  }

}


resource "yandex_kubernetes_node_group" "k8s-ng-c" {
  cluster_id  = yandex_kubernetes_cluster.k8s.id
  name        = "k8s-ng-c"
  description = "Node group C for K8s cluster"
  version     = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
    #   nat      = true
      subnet_ids = [ yandex_vpc_subnet.subnet-c.id ]
    }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 50
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
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone       = yandex_vpc_subnet.subnet-c.zone
    }

  }

}

