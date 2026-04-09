# -----------------------------------------------
# DevOps 커스텀 정책
# -----------------------------------------------

resource "aws_iam_policy" "devops" {
  name        = "${var.project_name}-devops-policy"
  description = "인프라 관리자 권한 (EC2, VPC, ALB, CloudWatch 등)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "InfraManagement"
        Effect = "Allow"
        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "logs:*",
          "s3:*",
          "ecr:*",
          "ecs:*",
          "rds:*",
          "ssm:*",
          "acm:*",
          "route53:*",
          "cloudfront:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMRoleManagement"
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:PassRole",
          "iam:GetInstanceProfile",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:ListRoles",
          "iam:ListInstanceProfiles"
        ]
        Resource = "*"
      }
    ]
  })
}

# -----------------------------------------------
# Dev 커스텀 정책
# -----------------------------------------------

resource "aws_iam_policy" "dev" {
  name        = "${var.project_name}-dev-policy"
  description = "개발자 권한 (SSM 접속, 로그 조회, S3, ECR)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SSMAccess"
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:TerminateSession",
          "ssm:ResumeSession",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceInformation",
          "ssmmessages:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "EC2ReadOnly"
        Effect = "Allow"
        Action = [
          "ec2:Describe*"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Sid    = "ECRAccess"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]
        Resource = "*"
      }
    ]
  })
}
