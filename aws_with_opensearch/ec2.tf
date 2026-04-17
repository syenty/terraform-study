# -----------------------------------------------
# OpenSearch 접속용 EC2 (SSM 포트포워딩 전용)
# -----------------------------------------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "tunnel" {
  name        = "${var.project_name}-tunnel-sg"
  description = "SSM tunnel EC2 Security Group"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(module.tags.common_tags, {
    Name = "${var.project_name}-tunnel-sg"
  })
}

resource "aws_instance" "tunnel" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[0].id
  iam_instance_profile   = var.ec2_instance_profile_name
  vpc_security_group_ids = [aws_security_group.tunnel.id]

  tags = merge(module.tags.common_tags, {
    Name = "${var.project_name}-tunnel"
  })
}
