output "tag_keys" {
  description = "태그 키 목록"
  value       = local.tag_keys
}

output "common_tags" {
  description = "공통 태그 (모든 리소스에 적용)"
  value       = local.common_tags
}

output "valid_envs" {
  description = "유효한 Env 태그 값 목록"
  value       = ["dev", "prod"]
}

output "valid_owners" {
  description = "유효한 Owner 태그 값 목록"
  value       = ["devops", "dev", "readonly"]
}
