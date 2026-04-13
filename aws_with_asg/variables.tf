variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "프로젝트 이름 (리소스 네이밍에 사용)"
  type        = string
}

variable "availability_zones" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
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

variable "asg_min_size" {
  description = "ASG 최소 인스턴스 수"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "ASG 최대 인스턴스 수"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "ASG 원하는 인스턴스 수"
  type        = number
  default     = 2
}

variable "scale_out_cpu_threshold" {
  description = "Scale Out CPU 임계값 (%)"
  type        = number
  default     = 70
}

variable "scale_in_cpu_threshold" {
  description = "Scale In CPU 임계값 (%)"
  type        = number
  default     = 30
}

variable "ec2_instance_profile_name" {
  description = "EC2에 부착할 Instance Profile 이름 (aws_foundation에서 생성)"
  type        = string
  default     = "sdt-ec2-ssm-profile"
}

variable "env" {
  description = "환경 (dev 또는 prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "소유 팀 (devops, dev, readonly)"
  type        = string
  default     = "devops"
}
