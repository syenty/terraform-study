# -----------------------------------------------
# Bastion Instance (Public Subnet)
# -----------------------------------------------

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

# -----------------------------------------------
# App Instance (Private Subnet)
# -----------------------------------------------

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-app"
  }
}
