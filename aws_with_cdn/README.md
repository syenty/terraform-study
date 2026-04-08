# AWS S3 + CloudFront CDN

## 개요

정적 파일(HTML, CSS, JS, 이미지 등)을 S3에 저장하고 CloudFront를 통해 글로벌 CDN으로 배포하는 구성입니다. 프론트엔드 배포에 주로 사용됩니다.

## 구성 요소

- S3 버킷 (정적 파일 저장, 퍼블릭 직접 접근 차단)
- CloudFront Distribution (CDN, HTTPS, 캐싱)
- Origin Access Control (S3 → CloudFront 전용 접근 제어)
- Route53 (도메인 연결, 선택적)

## 특징

- EC2 없이 서버리스로 프론트엔드 배포
- CloudFront 엣지 로케이션을 통한 글로벌 낮은 레이턴시
- S3에 직접 접근 불가, CloudFront 경유만 허용
