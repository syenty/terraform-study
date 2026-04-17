# Terraform Study

AWS 인프라를 단계별로 구성해보며 Terraform을 학습하는 프로젝트입니다.

## 디렉토리 구성

| 디렉토리 | 설명 | 상태 |
|----------|------|------|
| [aws_foundation](aws_foundation/) | IAM 사용자, 그룹, 역할, 정책, 비밀번호 정책 등 계정 공통 설정 | 완성 |
| [aws_basic](aws_basic/) | Default VPC + EC2 + ALB + ACM + Route53 기본 구성 | 완성 |
| [aws_customized_basic](aws_customized_basic/) | 커스텀 VPC + EC2 + ALB + ACM 구성 | 완성 |
| [aws_with_asg](aws_with_asg/) | ASG + Launch Template + ALB + Scaling Policy + SSM 접근 | 완성 |
| [aws_with_opensearch](aws_with_opensearch/) | OpenSearch 도메인 (Private 서브넷, 2AZ) + SSM 포트포워딩 접근 | 완성 |
| [aws_with_cdn](aws_with_cdn/) | CloudFront CDN 구성 | 미구현 |
| [aws_with_ecs](aws_with_ecs/) | ECS 컨테이너 구성 | 미구현 |
| [aws_modular](aws_modular/) | 모듈화된 인프라 구성 | 미구현 |
| [modules](modules/) | 재사용 공통 모듈 (tags) | 완성 |

## 의존 관계

`aws_foundation`은 다른 모듈에서 사용하는 IAM 리소스를 관리하므로 먼저 apply해야 한다.

```
aws_foundation (IAM, Instance Profile)
    │
    ├── aws_with_asg (EC2 Instance Profile 참조)
    └── aws_with_opensearch (EC2 Instance Profile 참조)
```

## 시작하기

환경 세팅은 [SETUP.md](SETUP.md) 참고.
