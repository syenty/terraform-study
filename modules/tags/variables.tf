variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "env" {
  description = "환경 (dev 또는 prod)"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env는 dev 또는 prod만 허용됩니다."
  }
}

variable "owner" {
  description = "소유 팀 (devops, dev, readonly)"
  type        = string
  validation {
    condition     = contains(["devops", "dev", "readonly"], var.owner)
    error_message = "owner는 devops, dev, readonly만 허용됩니다."
  }
}
