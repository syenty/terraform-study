output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = aws_lb.app.dns_name
}

output "app_url" {
  description = "애플리케이션 접속 URL"
  value       = "https://${var.subdomain}.${var.domain_name}"
}

output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.app.id
}

output "instance_private_ip" {
  description = "EC2 프라이빗 IP"
  value       = aws_instance.app.private_ip
}
