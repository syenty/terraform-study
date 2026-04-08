# AWS ECS Fargate

## 개요

EC2 대신 컨테이너로 애플리케이션을 실행하는 구성입니다. Fargate를 사용하면 서버 관리 없이 컨테이너를 실행할 수 있습니다.

## 구성 요소

- VPC, 퍼블릭/프라이빗 서브넷, IGW, NAT Gateway
- ECS Cluster
- ECS Task Definition (컨테이너 스펙 정의)
- ECS Service (태스크 실행 및 유지 관리)
- ECR (컨테이너 이미지 저장소)
- ALB + 타겟 그룹 (ECS Service와 연동)
- IAM Role (ECS Task 실행 권한)

## aws_customized_basic과의 차이

| | aws_customized_basic | aws_with_ecs |
|---|---|---|
| 실행 단위 | EC2 인스턴스 | 컨테이너 |
| 서버 관리 | 직접 관리 | Fargate (불필요) |
| 배포 방식 | SSH 접속 후 수동 | 이미지 교체로 배포 |
| 확장성 | ASG 필요 | 태스크 수 조정으로 간단 |
