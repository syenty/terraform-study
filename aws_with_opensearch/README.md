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

OpenSearch가 Private 서브넷에 있어 외부에서 직접 접근이 불가능하다.
OpenSearch 도메인 엔드포인트는 VPC 내부 IP로 해석되기 때문에, VPC 밖(로컬 PC)에서는 도달할 수 없다.

### SSM 포트포워딩 원리

같은 VPC의 Private 서브넷에 접속용 EC2를 배치하고, SSM 포트포워딩으로 터널을 만들어 접근한다.

```
로컬 PC (localhost:9200)
    │
    │  SSM 터널 (AWS가 암호화)
    │
EC2 (VPC 안, Private 서브넷) ── 같은 VPC라서 통신 가능 ──→ OpenSearch:443
```

1. 로컬에서 `ssm_port_forward_command`를 실행하면 PC의 9200 포트가 열림
2. localhost:9200으로 들어온 요청이 SSM 터널을 타고 EC2로 전달
3. EC2가 OpenSearch 도메인:443으로 중계
4. 응답도 같은 경로로 돌아옴

EC2에 별도 설정은 필요 없고, SSM Agent가 자동으로 중계를 처리한다.

### 접근 조건

- IAM 자격증명(SSM 권한 포함)이 설정된 PC에서만 터널 생성 가능
- 퍼블릭하게 열리는 것이 아니라 IAM 인증된 사용자만 접근 가능

### 접속 방법

```bash
# 1. terraform apply 후 출력되는 ssm_port_forward_command를 그대로 실행
# 또는 직접 실행:
aws ssm start-session \
  --target <인스턴스-ID> \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters '{"host":["<opensearch-endpoint>"],"portNumber":["443"],"localPortNumber":["9200"]}' \
  --profile terraform-study --region ap-northeast-2

# 2. 브라우저에서 접근
# https://localhost:9200/_dashboards

# 3. 마스터 계정으로 로그인 (admin / 설정한 비밀번호)
```

### HTTPS 인증서 경고

브라우저에서 "이 연결은 안전하지 않습니다" 경고가 뜰 수 있다.
OpenSearch 인증서가 `vpc-xxx.es.amazonaws.com` 도메인용인데 `localhost`로 접속하기 때문에 발생하는 도메인 불일치 경고이다.
통신 전체가 SSM 터널(AWS 암호화) 안에서 이루어지므로 무시하고 진행해도 안전하다.

## 대시보드 테스트 (Dev Tools)

대시보드 접속 후 좌측 메뉴 → Dev Tools에서 실행한다.

### 1. 데이터 입력

```json
PUT /products/_doc/1
{"name": "삼성 갤럭시 버즈", "category": "이어폰", "price": 150000, "stock": 45}

PUT /products/_doc/2
{"name": "애플 에어팟 프로", "category": "이어폰", "price": 350000, "stock": 120}

PUT /products/_doc/3
{"name": "삼성 갤럭시 S25 케이스", "category": "케이스", "price": 25000, "stock": 300}

PUT /products/_doc/4
{"name": "소니 WH-1000XM5 헤드폰", "category": "헤드폰", "price": 450000, "stock": 30}

PUT /products/_doc/5
{"name": "삼성 갤럭시 워치7", "category": "웨어러블", "price": 320000, "stock": 80}
```

### 2. 텍스트 검색 — RDB와의 차이를 느낄 수 있는 핵심

```json
// "갤럭시"가 포함된 상품 검색 (1, 3, 5번 반환)
GET /products/_search
{"query": {"match": {"name": "갤럭시"}}}

// "삼성 케이스" 검색 — 두 단어를 분리해서 관련도 순 반환
GET /products/_search
{"query": {"match": {"name": "삼성 케이스"}}}
```

### 3. 조건 필터

```json
// 이어폰 카테고리에서 20만원 이하
GET /products/_search
{
  "query": {
    "bool": {
      "must": {"match": {"category": "이어폰"}},
      "filter": {"range": {"price": {"lte": 200000}}}
    }
  }
}
```

### 4. 집계 (Aggregation)

```json
// 카테고리별 평균 가격
GET /products/_search
{
  "size": 0,
  "aggs": {
    "category_avg_price": {
      "terms": {"field": "category.keyword"},
      "aggs": {
        "avg_price": {"avg": {"field": "price"}}
      }
    }
  }
}

// 전체 재고 합계
GET /products/_search
{
  "size": 0,
  "aggs": {
    "total_stock": {"sum": {"field": "stock"}}
  }
}
```

### 5. 인덱스 확인/삭제

```json
// 인덱스 목록 확인
GET /_cat/indices?v

// 테스트 후 정리
DELETE /products
```

### 6. 시각화 만들기

**인덱스 패턴 생성 (최초 1회):**

Management → Dashboards Management → Index patterns → Create index pattern → `products*` 입력

**시각화 생성:**

OpenSearch Dashboards → Visualize → Create Visualization에서 타입 선택 후 설정한다.

| 시각화 | Visualization Type | 설정 |
|--------|-------------------|------|
| 카테고리별 상품 수 | Pie Chart | Buckets → Terms → `category.keyword` |
| 상품별 가격 비교 | Vertical Bar | X축: Terms → `name.keyword`, Y축: Max → `price` |
| 가격대 분포 | Histogram | X축: Histogram → `price` (interval: 100000) |
| 카테고리별 평균 가격 | Horizontal Bar | X축: Terms → `category.keyword`, Y축: Average → `price` |
| 카테고리별 재고 현황 | Data Table | Buckets → Terms → `category.keyword`, Metrics → Sum → `stock` |

각 시각화에서 Metrics(Y축)와 Buckets(X축) 설정 후 ▶ Update 클릭, Save로 저장한다.

**대시보드 구성:**

1. Visualize에서 시각화 5개를 각각 만들고 저장
2. OpenSearch Dashboards → Dashboards → Create Dashboard
3. Add 버튼 → 저장한 시각화들을 선택하여 추가
4. 드래그로 레이아웃 배치 후 Save

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
