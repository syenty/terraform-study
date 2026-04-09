# -----------------------------------------------
# IAM 계정 비밀번호 정책
# AWS 기본값과 동일한 설정
# -----------------------------------------------

resource "aws_iam_account_password_policy" "main" {
  minimum_password_length        = 8
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
}
