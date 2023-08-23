# Self-signed certificate
resource "yandex_cm_certificate" "cert1" {
  name    = "cert1"

  self_managed {
    certificate = "${file("cert.pem")}"
    private_key = "${file("key.pem")}"
  }
}

# Bucket
resource "yandex_storage_bucket" "nikmokrov2308-site" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "nikmokrov2308-site.ru"
  force_destroy = true
  acl           = "public-read"
  max_size      = 104857600
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  https {
    certificate_id = yandex_cm_certificate.cert1.id
  }
  depends_on    = [
    yandex_iam_service_account_static_access_key.sa-static-key,
  ]
}

# index.html
resource "yandex_storage_object" "index-html" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "nikmokrov2308-site.ru"
  key        = "index.html"
  source     = "index.html"
  # acl        = "public-read"
  depends_on = [
    yandex_iam_service_account_static_access_key.sa-static-key,  
  ]
}

# error.html
resource "yandex_storage_object" "error-html" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "nikmokrov2308-site.ru"
  key        = "error.html"
  source     = "error.html"
  # acl        = "public-read"
  depends_on = [
    yandex_iam_service_account_static_access_key.sa-static-key,
  ]
}
