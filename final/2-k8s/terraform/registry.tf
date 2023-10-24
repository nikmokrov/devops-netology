# Container registry
resource "yandex_container_registry" "nikmokrov-devops-22-reg" {
  name = "nikmokrov-devops-22-reg"
  folder_id = var.folder_id
}