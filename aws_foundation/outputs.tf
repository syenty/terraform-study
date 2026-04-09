output "devops_group_name" {
  description = "DevOps 그룹 이름"
  value       = aws_iam_group.devops.name
}

output "dev_group_name" {
  description = "Dev 그룹 이름"
  value       = aws_iam_group.dev.name
}

output "readonly_group_name" {
  description = "ReadOnly 그룹 이름"
  value       = aws_iam_group.readonly.name
}

output "devops_policy_arn" {
  description = "DevOps 정책 ARN"
  value       = aws_iam_policy.devops.arn
}

output "dev_policy_arn" {
  description = "Dev 정책 ARN"
  value       = aws_iam_policy.dev.arn
}

output "ec2_ssm_role_name" {
  description = "EC2 SSM Role 이름"
  value       = aws_iam_role.ec2_ssm.name
}

output "ec2_ssm_instance_profile_name" {
  description = "EC2 SSM Instance Profile 이름"
  value       = aws_iam_instance_profile.ec2_ssm.name
}

output "ec2_ssm_instance_profile_arn" {
  description = "EC2 SSM Instance Profile ARN"
  value       = aws_iam_instance_profile.ec2_ssm.arn
}

output "tag_keys" {
  description = "공통 태그 키 목록"
  value       = module.tags.tag_keys
}

output "valid_envs" {
  description = "유효한 Env 태그 값 목록"
  value       = module.tags.valid_envs
}

output "valid_owners" {
  description = "유효한 Owner 태그 값 목록"
  value       = module.tags.valid_owners
}
