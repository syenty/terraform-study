# AWS OpenSearch

## 개요

VPC 내 Private 서브넷에 OpenSearch 도메인을 배치하고, SSM 포트포워딩을 통해 대시보드에 접근하는 구성입니다.

## 구성 요소

- VPC, 퍼블릭/프라이빗 서브넷, IGW, NAT Gateway
- OpenSearch 도메인 (Private 서브넷, 2AZ 분산)
- Fine-Grained Access Control (내부 사용자 DB)
- 전송 중/저장 시 암호화
- SSM 포트포워딩을 통한 대시보드 접근

## 아키텍처

```
Internet
    │
┌───┴───┐
│  IGW  │
└───┬───┘
    │
┌───┴──────────────────┐
│   Public Subnets     │
│   (NAT GW)           │
└───┬──────────────────┘
    │
┌───┴──────────────────┐
│   Private Subnets    │
│                      │
│  ┌────────────────┐  │
│  │  OpenSearch     │  │
│  │  (2AZ, 2노드)  │  │
│  └────────────────┘  │
└──────────────────────┘
```

## OpenSearch 대시보드 접근

OpenSearch가 Private 서브넷에 있어 직접 접근이 불가능하다.
SSM 포트포워딩으로 로컬에서 접근할 수 있다.

```bash
# 1. Private 서브넷의 EC2 인스턴스 ID 확인 (aws_with_asg 등에서 생성된 인스턴스)
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text \
  --profile terraform-study --region ap-northeast-2

# 2. SSM 포트포워딩 (OpenSearch 엔드포인트의 443 → 로컬 9200)
aws ssm start-session \
  --target <인스턴스-ID> \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters '{"host":["<opensearch-endpoint>"],"portNumber":["443"],"localPortNumber":["9200"]}' \
  --profile terraform-study --region ap-northeast-2

# 3. 브라우저에서 접근
# https://localhost:9200/_dashboards
```

## 실무 데이터 연동 사례

OpenSearch 자체는 데이터를 수집하지 않는다. 외부에서 데이터를 넣어주는 파이프라인이 필요하다.

### 1. 애플리케이션 검색 데이터 (상품, 콘텐츠 등)

```
앱 서버 → OpenSearch SDK/REST API로 직접 인덱싱/조회
```

- RDB에는 원본 데이터, OpenSearch에는 검색용 복사본
- 예: 쇼핑몰 상품 검색, 블로그 콘텐츠 검색

### 2. 애플리케이션 로그

```
EC2/ECS 앱 서버 → FluentBit / Filebeat (수집 에이전트) → OpenSearch
```

- 앱 서버에 로그 수집 에이전트를 설치하여 실시간 전송
- 대시보드에서 에러 로그 검색, 장애 원인 분석

### 3. ALB 액세스 로그

```
ALB → S3 버킷 → Lambda (트리거) → OpenSearch
```

- ALB 액세스 로그를 S3에 저장, Lambda가 자동으로 OpenSearch에 적재
- 요청량 추이, 응답 코드 분포, 느린 요청 분석

### 4. CloudWatch Logs

```
CloudWatch Logs → 구독 필터 (Subscription Filter) → OpenSearch
```

- CloudWatch에서 구독 필터 설정만 하면 연동 완료 (가장 간단한 방식)
- Lambda 실행 로그, VPC Flow Logs 등을 분석

### 5. 보안 이벤트 (SIEM)

```
CloudTrail / VPC Flow Logs / GuardDuty / WAF → OpenSearch
```

- 여러 보안 소스를 OpenSearch에 모아 통합 분석
- 비정상 API 호출 패턴 탐지, 위협 분석

## 과금 요소

- OpenSearch t3.small.search x2: ~$0.036/h x2
- NAT Gateway: ~$0.045/h
- EBS gp3 10GB x2: 미미

## 사전 조건

- `aws_foundation`이 먼저 apply되어 있어야 함
- `opensearch_master_password`를 환경변수로 설정:
  ```bash
  export TF_VAR_opensearch_master_password="YourPassword1!"
  ```
