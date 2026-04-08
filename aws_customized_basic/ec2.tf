# -----------------------------------------------
# Bastion Instance (Public Subnet)
# -----------------------------------------------

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    cat > /home/ec2-user/.ssh/terraform-study-key.pem << 'PRIVATEKEY'
    ${file(pathexpand(var.private_key_path))}
    PRIVATEKEY
    chmod 600 /home/ec2-user/.ssh/terraform-study-key.pem
    chown ec2-user:ec2-user /home/ec2-user/.ssh/terraform-study-key.pem

    cat > /home/ec2-user/.ssh/config << 'SSHCONFIG'
    Host 10.0.11.*
      StrictHostKeyChecking no
      IdentityFile ~/.ssh/terraform-study-key.pem
    Host 10.0.12.*
      StrictHostKeyChecking no
      IdentityFile ~/.ssh/terraform-study-key.pem
    SSHCONFIG
    chmod 600 /home/ec2-user/.ssh/config
    chown ec2-user:ec2-user /home/ec2-user/.ssh/config
  EOF

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-bastion-eip"
  }
}

# -----------------------------------------------
# App Instance (Private Subnet)
# -----------------------------------------------

resource "aws_instance" "app" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[count.index].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-app-${count.index + 1}"
  }
}
