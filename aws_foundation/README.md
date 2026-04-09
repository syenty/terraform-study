# AWS Foundation

## 개요

IAM 권한 체계 및 공통 태그 정책을 관리하는 기반 구성입니다. 인프라 디렉토리와 별도로 관리합니다.

## 구성 요소

### IAM 그룹

| 그룹 | 대상 | 주요 권한 |
|------|------|-----------|
| devops | 인프라 관리자 | EC2, VPC, ALB, RDS, IAM Role 등 인프라 전체 |
| dev | 개발자 | SSM 접속, CloudWatch 조회, S3, ECR |
| readonly | 읽기 전용 | 모든 리소스 조회만 가능 |

## 파일 구조

```
aws_foundation/
├── versions.tf       # provider 설정
├── variables.tf      # 변수
├── terraform.tfvars  # 변수 값
├── iam_policies.tf   # 커스텀 IAM 정책
├── iam_groups.tf     # IAM 그룹 및 정책 연결
└── outputs.tf
```

## 사용자 그룹 추가 방법

AWS Console → IAM → 사용자 → 해당 사용자 → 그룹 추가
