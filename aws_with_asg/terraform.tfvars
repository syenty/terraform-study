project_name = "my-app"
aws_region   = "ap-northeast-2"

# VPC
vpc_cidr = "10.0.0.0/16"

# EC2 설정
ami_id        = "ami-00b3401e969d06397" # Amazon Linux 2023 kernel-6.1 x86_64 (ap-northeast-2)
instance_type = "t3.micro"

# ASG 설정
asg_min_size         = 1
asg_max_size         = 4
asg_desired_capacity = 2

# Scaling 임계값
scale_out_cpu_threshold = 70
scale_in_cpu_threshold  = 30
