output "opensearch_endpoint" {
  description = "OpenSearch 도메인 엔드포인트"
  value       = aws_opensearch_domain.main.endpoint
}

output "opensearch_dashboard_url" {
  description = "OpenSearch 대시보드 URL"
  value       = "https://${aws_opensearch_domain.main.endpoint}/_dashboards"
}

output "opensearch_domain_name" {
  description = "OpenSearch 도메인 이름"
  value       = aws_opensearch_domain.main.domain_name
}

output "tunnel_instance_id" {
  description = "SSM 포트포워딩용 EC2 인스턴스 ID"
  value       = aws_instance.tunnel.id
}

output "ssm_port_forward_command" {
  description = "OpenSearch 대시보드 접속을 위한 SSM 포트포워딩 명령어"
  value       = "aws ssm start-session --target ${aws_instance.tunnel.id} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"host\":[\"${aws_opensearch_domain.main.endpoint}\"],\"portNumber\":[\"443\"],\"localPortNumber\":[\"9200\"]}' --profile terraform-study --region ${var.aws_region}"
}
