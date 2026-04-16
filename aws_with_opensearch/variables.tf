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

variable "opensearch_engine_version" {
  description = "OpenSearch 엔진 버전"
  type        = string
  default     = "OpenSearch_2.13"
}

variable "opensearch_instance_type" {
  description = "OpenSearch 인스턴스 타입"
  type        = string
  default     = "t3.small.search"
}

variable "opensearch_instance_count" {
  description = "OpenSearch 데이터 노드 수"
  type        = number
  default     = 2
}

variable "opensearch_volume_size" {
  description = "OpenSearch EBS 볼륨 크기 (GB)"
  type        = number
  default     = 10
}

variable "opensearch_master_user" {
  description = "OpenSearch 대시보드 마스터 사용자 이름"
  type        = string
  default     = "admin"
}

variable "opensearch_master_password" {
  description = "OpenSearch 대시보드 마스터 비밀번호"
  type        = string
  sensitive   = true
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
