# AWS Basic

## 개요

AWS 기본 인프라 구성입니다. Default VPC를 사용하여 최소한의 리소스로 EC2와 ALB를 구성합니다. Terraform 입문용 예제입니다.

## 구성 요소

- Default VPC, 서브넷 (자동 탐색)
- EC2 인스턴스 (퍼블릭 IP 할당)
- ALB + 타겟 그룹, HTTP 리스너
- 보안 그룹 (ALB, EC2)

## 접속 흐름

```
인터넷 → ALB (80) → EC2 (8080)
로컬 → EC2 (SSH)
```

## aws_customized_basic과의 차이

| | aws_basic | aws_customized_basic |
|---|---|---|
| VPC | Default VPC 사용 | 전용 VPC 신규 생성 |
| 서브넷 | 자동 탐색 | 퍼블릭/프라이빗 직접 구성 |
| EC2 접근 | 퍼블릭 IP 직접 SSH | Bastion 경유 |
| 이중화 | 없음 | ALB 기준 2개 AZ |
