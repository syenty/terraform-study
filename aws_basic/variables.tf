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

variable "my_ip" {
  description = "SSH 허용할 IP (예: 1.2.3.4/32). 기본값은 전체 허용"
  type        = string
  default     = "0.0.0.0/0"
}
