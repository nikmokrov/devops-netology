# KMS
resource "yandex_kms_symmetric_key" "key1" {
  name              = "key1"
  description       = "key for k8s cluster encryption"
  default_algorithm = "AES_256"
}