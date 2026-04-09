# -----------------------------------------------
# DevOps 그룹
# -----------------------------------------------

resource "aws_iam_group" "devops" {
  name = "${var.org}-devops"
}

resource "aws_iam_group_policy_attachment" "devops" {
  group      = aws_iam_group.devops.name
  policy_arn = aws_iam_policy.devops.arn
}

# -----------------------------------------------
# Dev 그룹
# -----------------------------------------------

resource "aws_iam_group" "dev" {
  name = "${var.org}-dev"
}

resource "aws_iam_group_policy_attachment" "dev" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.dev.arn
}

# -----------------------------------------------
# ReadOnly 그룹
# -----------------------------------------------

resource "aws_iam_group" "readonly" {
  name = "${var.org}-readonly"
}

resource "aws_iam_group_policy_attachment" "readonly" {
  group      = aws_iam_group.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
