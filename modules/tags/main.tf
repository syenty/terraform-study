# -----------------------------------------------
# 태그 키 정의
# -----------------------------------------------

locals {
  tag_keys = {
    project    = "Project"
    env        = "Env"
    owner      = "Owner"
    managed_by = "ManagedBy"
  }
}

# -----------------------------------------------
# 공통 태그
# -----------------------------------------------

locals {
  common_tags = {
    "${local.tag_keys.project}"    = var.project
    "${local.tag_keys.env}"        = var.env
    "${local.tag_keys.owner}"      = var.owner
    "${local.tag_keys.managed_by}" = "terraform"
  }
}
