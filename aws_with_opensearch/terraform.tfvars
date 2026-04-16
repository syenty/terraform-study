project_name = "my-app"
aws_region   = "ap-northeast-2"

# 태그 설정
env   = "dev"
owner = "devops"

# aws_foundation에서 생성된 Instance Profile
ec2_instance_profile_name = "sdt-ec2-ssm-profile"

# VPC
vpc_cidr = "10.0.0.0/16"

# OpenSearch 설정
opensearch_engine_version = "OpenSearch_2.13"
opensearch_instance_type  = "t3.small.search"
opensearch_instance_count = 2
opensearch_volume_size    = 10
opensearch_master_user    = "admin"
# opensearch_master_password는 apply 시 입력 또는 환경변수로 전달
# export TF_VAR_opensearch_master_password="YourPassword1!"
