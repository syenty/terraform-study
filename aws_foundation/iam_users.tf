# -----------------------------------------------
# IAM Users
# 사용자 추가 시 locals의 members에 추가
# -----------------------------------------------

locals {
  members = {
    # 형식: "username" = "그룹명"
    "devops-user"   = "devops"
    "dev-user"      = "dev"
    "readonly-user" = "readonly"
  }
}

resource "aws_iam_user" "members" {
  for_each = local.members
  name     = each.key

  tags = {
    Name = each.key
  }
}

resource "aws_iam_user_group_membership" "members" {
  for_each = local.members
  user     = aws_iam_user.members[each.key].name
  groups   = ["${var.org}-${each.value}"]
}
