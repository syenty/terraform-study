variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "프로젝트 이름 (리소스 네이밍에 사용)"
  type        = string
}


variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 키페어 이름"
  type        = string
}

variable "domain_name" {
  description = "Route53에 등록된 도메인 이름 (예: example.com)"
  type        = string
}

variable "subdomain" {
  description = "사용할 서브도메인 (예: app → app.example.com)"
  type        = string
  default     = "app"
}
