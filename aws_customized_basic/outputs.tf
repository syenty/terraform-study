output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = aws_lb.app.dns_name
}

output "app_url" {
  description = "애플리케이션 접속 URL (ALB DNS)"
  value       = "http://${aws_lb.app.dns_name}"
}

output "bastion_public_ip" {
  description = "Bastion 인스턴스 퍼블릭 IP (SSH 접속용)"
  value       = aws_eip.bastion.public_ip
}

output "instance_id" {
  description = "App EC2 인스턴스 ID"
  value       = aws_instance.app.id
}

output "instance_private_ip" {
  description = "App EC2 프라이빗 IP"
  value       = aws_instance.app.private_ip
}
