# AWS Customized Basic

## 개요

전용 VPC를 직접 구성하고 퍼블릭/프라이빗 서브넷을 분리한 실무에 가까운 기본 구성입니다. Bastion을 통해 프라이빗 서브넷의 EC2에 접근합니다.

## 구성 요소

- 전용 VPC (`10.0.0.0/16`)
- 퍼블릭 서브넷 2개 (ALB용, `ap-northeast-2a/2c`)
- 프라이빗 서브넷 2개 (App EC2용, `ap-northeast-2a/2c`)
- Internet Gateway, NAT Gateway
- Bastion EC2 (퍼블릭 서브넷, EIP 부착)
- App EC2 2대 (프라이빗 서브넷, AZ별 1대)
- ALB + 타겟 그룹, HTTP 리스너
- 보안 그룹 (ALB, Bastion, App EC2)

## 접속 흐름

```
인터넷 → ALB (80) → App EC2-1 (ap-northeast-2a)
                  → App EC2-2 (ap-northeast-2c)
로컬 → Bastion (SSH) → App EC2-1, EC2-2
App EC2 → 외부 (NAT Gateway 경유)
```
