# Bucket
resource "yandex_storage_bucket" "infra-bucket" {
  access_key    = yandex_iam_service_account_static_access_key.infra-sa-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.infra-sa-key.secret_key
  bucket        = "nikmokrov1023-infra"
  force_destroy = true
  max_size      = 10485760
}
