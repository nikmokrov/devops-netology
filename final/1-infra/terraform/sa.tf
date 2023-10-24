# Service account
resource "yandex_iam_service_account" "infra-sa" {
  name        = "infra-sa"
  description = "Infrastructure service account"
}

# Static key
resource "yandex_iam_service_account_static_access_key" "infra-sa-key" {
  service_account_id = yandex_iam_service_account.infra-sa.id
  description        = "static access key for infra sa"
}

# Roles
resource "yandex_resourcemanager_folder_iam_member" "storage-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "container-registry-editor" {
  folder_id = var.folder_id
  role      = "container-registry.editor"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-editor" {
  folder_id = var.folder_id
  role      = "k8s.editor"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "kms-admin" {
  folder_id = var.folder_id
  role      = "kms.admin"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "dns-editor" {
  folder_id = var.folder_id
  role      = "dns.editor"
  member    = "serviceAccount:${yandex_iam_service_account.infra-sa.id}"
}
