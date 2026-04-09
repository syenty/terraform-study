# AWS Foundation

## 개요

IAM 권한 체계를 관리하는 기반 구성입니다. 인프라 디렉토리와 별도로 관리하며 모든 리소스는 무료입니다.

## 네이밍 규칙

조직 약어(`sdt`)를 접두사로 사용합니다.

```
sdt-devops-policy
sdt-dev-policy
sdt-devops
sdt-dev
sdt-readonly
sdt-ec2-ssm-role
sdt-ec2-ssm-profile
```

## IAM 그룹

| 그룹 | 대상 | 주요 권한 |
|------|------|-----------|
| `sdt-devops` | 인프라 관리자 | EC2, VPC, ALB, RDS, IAM Role 등 인프라 전체 |
| `sdt-dev` | 개발자 | SSM 접속 (Env=dev, Owner=dev 태그 인스턴스만), CloudWatch, S3, ECR |
| `sdt-readonly` | 읽기 전용 | 모든 리소스 조회만 가능 |

## IAM Role

| Role | 용도 |
|------|------|
| `sdt-ec2-ssm-role` | EC2 인스턴스용 SSM 접근 공통 Role |

## 사용자 관리

`iam_users.tf`의 `members`에 추가/제거 후 `terraform apply`:

```hcl
members = {
  # 형식: "username" = "그룹명"
  "hong-gildong" = "dev"
  "kim-cheolsu"  = "devops"
}
```

- 콘솔 액세스, 액세스 키, MFA는 AWS Console에서 별도 설정
- 사용자 제거 시 `members`에서 삭제 후 `terraform apply`

## 태그 체계

`modules/tags`에서 공통 태그를 관리합니다:

| 태그 키 | 용도 |
|---------|------|
| `Project` | 비용 추적 |
| `Env` | 접근 제어 (`dev`, `prod`) |
| `Owner` | 접근 제어 (`devops`, `dev`, `readonly`) |
| `ManagedBy` | 관리 주체 (`terraform`) |

## 파일 구조

```
aws_foundation/
├── versions.tf       # provider 설정
├── variables.tf      # 변수 (aws_region, project_name, org)
├── terraform.tfvars  # 변수 값
├── locals.tf         # tags 모듈 참조
├── iam_policies.tf   # DevOps, Dev 커스텀 정책
├── iam_groups.tf     # IAM 그룹 및 정책 연결
├── iam_roles.tf      # 공통 IAM Role (EC2 SSM)
├── iam_users.tf      # IAM 사용자 관리
└── outputs.tf
```
