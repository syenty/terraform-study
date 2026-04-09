# -----------------------------------------------
# EC2 SSM Role
# 모든 EC2 인스턴스에 공통 적용
# -----------------------------------------------

resource "aws_iam_role" "ec2_ssm" {
  name        = "${var.org}-ec2-ssm-role"
  description = "SSM access role for EC2 instances"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.org}-ec2-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.org}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}

# -----------------------------------------------
# CloudWatch Agent Role
# EC2에서 메트릭/로그를 CloudWatch로 전송
# -----------------------------------------------

resource "aws_iam_role" "cloudwatch_agent" {
  name        = "${var.org}-cloudwatch-agent-role"
  description = "CloudWatch Agent role for EC2 instances"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.org}-cloudwatch-agent-role"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.cloudwatch_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cloudwatch_agent" {
  name = "${var.org}-cloudwatch-agent-profile"
  role = aws_iam_role.cloudwatch_agent.name
}

# -----------------------------------------------
# ECS Task Execution Role
# ECS Fargate 태스크 실행 시 필요
# -----------------------------------------------

resource "aws_iam_role" "ecs_task_execution" {
  name        = "${var.org}-ecs-task-execution-role"
  description = "ECS task execution role for Fargate"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.org}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
