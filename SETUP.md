# Terraform 실행 환경 세팅

## 1. Terraform 설치

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# 설치 확인
terraform -version
```

## 2. AWS 자격증명 설정

`~/.aws/credentials` 파일에 아래 내용 추가:

```ini
[terraform-study]
aws_access_key_id = 액세스키
aws_secret_access_key = 시크릿키
```

> 액세스 키는 AWS Console → IAM → 사용자 → 보안 자격 증명 탭 → 액세스 키 만들기에서 발급

## 3. 자격증명 확인

```bash
aws sts get-caller-identity --profile terraform-study
```

## 4. Terraform 실행

각 디렉토리의 `provider` 블록에 `profile = "terraform-study"`가 설정되어 있으므로 별도 환경변수 없이 바로 실행 가능합니다.

```bash
cd aws_basic/   # 또는 다른 디렉토리

terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## 참고

- 새 디렉토리 추가 시 `provider` 블록에 `profile = "terraform-study"` 반드시 포함
- `terraform.tfvars`에 필수 변수(`project_name`, `ami_id`, `key_name`, `domain_name`) 입력 필요
