# KMS
resource "yandex_kms_symmetric_key" "k8s-key" {
  name              = "k8s_key"
  description       = "key for k8s cluster encryption"
  default_algorithm = "AES_256"
}