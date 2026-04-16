# AWS Auto Scaling Group

## 개요

EC2 단일 인스턴스 대신 Auto Scaling Group(ASG)을 사용하여 트래픽에 따라 EC2 인스턴스를 자동으로 증감하는 구성입니다.

## 구성 요소

- VPC, 퍼블릭/프라이빗 서브넷, IGW, NAT Gateway
- Launch Template (AMI, 인스턴스 타입, 보안 그룹 등 정의)
- Auto Scaling Group (최소/최대/원하는 인스턴스 수 관리)
- Scaling Policy (CPU 사용률 기반 자동 증감)
- ALB + 타겟 그룹 (ASG와 연동)
- SSM을 통한 EC2 접근 (Bastion 없이 Instance Profile 사용)

## SSM을 통한 Private EC2 접근

Private 서브넷의 EC2는 Public IP가 없지만 SSM Session Manager로 접근할 수 있다.

**동작 원리:**

1. EC2에 `sdt-ec2-ssm-profile` (Instance Profile)이 부착되어 있음
2. 해당 Profile의 Role에 `AmazonSSMManagedInstanceCore` 정책이 연결됨
3. EC2의 SSM Agent가 NAT Gateway를 통해 SSM 엔드포인트에 아웃바운드 통신
4. 로컬에서 `aws ssm start-session`으로 접속 (인바운드 포트 오픈 불필요)
   예시) aws ssm start-session --target i-0b6cb12f59be2402f --profile terraform-study --region ap-northeast-2

**SSH와의 차이:**

| | SSH | SSM Session Manager |
|---|---|---|
| 접속 방식 | 클라이언트 → EC2 22번 포트 직접 연결 | 클라이언트 → SSM 서비스 ← EC2 Agent (아웃바운드) |
| 포트 오픈 | 인바운드 22 필요 | 인바운드 포트 불필요 |
| 인증 | SSH 키 페어 | IAM 권한 |
| Public IP | 필요 (또는 Bastion 경유) | 불필요 |
| 접속 기록 | 별도 설정 필요 | CloudTrail에 자동 기록 |

```
로컬 PC → AWS SSM 서비스 ← EC2 SSM Agent (NAT GW 경유)
```

**접속 후 사용자:**

- SSM 접속 시 기본 사용자는 `ssm-user`
- `ec2-user`로 전환: `sudo su - ec2-user`

**사전 조건:**

- `aws_foundation`이 먼저 apply되어 Instance Profile이 존재해야 함
- 로컬에 AWS CLI 및 Session Manager 플러그인 설치 필요
  - `brew install awscli`
  - `brew install --cask session-manager-plugin`

## aws_customized_basic과의 차이

|           | aws_customized_basic | aws_with_asg              |
| --------- | -------------------- | ------------------------- |
| App 서버  | EC2 고정 2대         | ASG로 자동 증감           |
| 배포 방식 | 인스턴스 직접 관리   | Launch Template으로 관리  |
| 장애 대응 | 수동                 | 비정상 인스턴스 자동 교체 |
