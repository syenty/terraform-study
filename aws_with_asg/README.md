# AWS Auto Scaling Group

## 개요

EC2 단일 인스턴스 대신 Auto Scaling Group(ASG)을 사용하여 트래픽에 따라 EC2 인스턴스를 자동으로 증감하는 구성입니다.

## 구성 요소

- VPC, 퍼블릭/프라이빗 서브넷, IGW, NAT Gateway
- Launch Template (AMI, 인스턴스 타입, 보안 그룹 등 정의)
- Auto Scaling Group (최소/최대/원하는 인스턴스 수 관리)
- Scaling Policy (CPU 사용률 기반 자동 증감)
- ALB + 타겟 그룹 (ASG와 연동)
- Bastion (SSH 접근용)

## aws_customized_basic과의 차이

| | aws_customized_basic | aws_with_asg |
|---|---|---|
| App 서버 | EC2 고정 2대 | ASG로 자동 증감 |
| 배포 방식 | 인스턴스 직접 관리 | Launch Template으로 관리 |
| 장애 대응 | 수동 | 비정상 인스턴스 자동 교체 |
