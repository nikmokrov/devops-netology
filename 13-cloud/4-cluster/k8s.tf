# K8s cluster
resource "yandex_kubernetes_cluster" "k8s" {
  network_id = yandex_vpc_network.vpc.id
  master {
    version   = var.k8s_version
    public_ip = true
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.public-a.zone
        subnet_id = yandex_vpc_subnet.public-a.id
      }
      location {
        zone      = yandex_vpc_subnet.public-b.zone
        subnet_id = yandex_vpc_subnet.public-b.id
      }
      location {
        zone      = yandex_vpc_subnet.public-c.zone
        subnet_id = yandex_vpc_subnet.public-c.id
      }
    }
    # security_group_ids = [yandex_vpc_security_group.k8s-sg.id]
  }

  service_account_id      = yandex_iam_service_account.k8s-sa.id
  node_service_account_id = yandex_iam_service_account.k8s-sa.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller
  ]
  
  network_policy_provider = "CALICO"  
  release_channel = "STABLE"
  
  kms_provider {
    key_id = yandex_kms_symmetric_key.key1.id
  }

}
