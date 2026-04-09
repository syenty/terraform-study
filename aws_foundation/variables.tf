variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "org" {
  description = "조직/팀 약어 (리소스 네이밍에 사용)"
  type        = string
  default     = "sdt"
}
