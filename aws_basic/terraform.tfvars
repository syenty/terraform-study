project_name = "my-app"
aws_region   = "ap-northeast-2"

# EC2 설정
ami_id        = "ami-0c9c942bd7bf113a2" # Amazon Linux 2023 (ap-northeast-2)
instance_type = "t3.micro"
key_name      = "my-key-pair"

# 도메인 설정 (Route53에 등록된 도메인)
domain_name = "example.com"
subdomain   = "app"
