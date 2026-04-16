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
