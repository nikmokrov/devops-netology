# Output
output "k8s_ip" {
  description = "K8s external ip"
  value       = yandex_kubernetes_cluster.k8s.master[0].external_v4_address
}

output "reg_id" {
  description = "Container Registry ID"
  value       = yandex_container_registry.nikmokrov-devops-22-reg.id
}

resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s.id} --external"
    }
}