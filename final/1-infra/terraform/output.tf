# Output
output "sa_id" {
  description = "infra sa id"
  value       = yandex_iam_service_account.infra-sa.id
}
