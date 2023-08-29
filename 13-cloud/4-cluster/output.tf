# Output
output "k8s_id" {
  description = "K8s cluster ID"
  value       = yandex_kubernetes_cluster.k8s.id
}

resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s.id} --external"
    }
}