# Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.sa_id
  description        = "static access key for object storage"
}

# Bucket
resource "yandex_storage_bucket" "nikmokrov2108" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "nikmokrov2108"
  force_destroy = true
  acl           = "public-read"
  max_size      = 104857600
}

resource "yandex_storage_object" "clock-pic" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "nikmokrov2108"
  key    = "clock.jpg"
  source = "clock.jpg"
  acl    = "public-read"
}