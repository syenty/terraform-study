output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = aws_lb.app.dns_name
}

output "app_url" {
  description = "애플리케이션 접속 URL (ALB DNS)"
  value       = "http://${aws_lb.app.dns_name}"
}

output "asg_name" {
  description = "Auto Scaling Group 이름"
  value       = aws_autoscaling_group.app.name
}
