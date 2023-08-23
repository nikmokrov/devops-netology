# KMS
resource "yandex_kms_symmetric_key" "key1" {
  name              = "key1"
  description       = "key for bucket object encryption"
  default_algorithm = "AES_256"
}

# Bucket
resource "yandex_storage_bucket" "nikmokrov2308" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "nikmokrov2308"
  force_destroy = true
  acl           = "public-read"
  max_size      = 104857600
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key1.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on    = [
    yandex_iam_service_account_static_access_key.sa-static-key,
    yandex_kms_symmetric_key.key1,
  ]
}

# Picture
resource "yandex_storage_object" "clock-pic" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "nikmokrov2308"
  key        = "clock.jpg"
  source     = "clock.jpg"
  # acl        = "public-read"
  depends_on = [
    yandex_iam_service_account_static_access_key.sa-static-key,
    yandex_storage_bucket.nikmokrov2308,   
  ]
}
