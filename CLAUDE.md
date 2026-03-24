# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Standard Terraform workflow (run from within the `aws_basic/` directory):

```bash
terraform init       # Initialize and download providers
terraform validate   # Validate configuration syntax
terraform fmt        # Format code (run before committing)
terraform plan       # Preview changes
terraform apply      # Deploy infrastructure
terraform destroy    # Tear down infrastructure
```

## Architecture

This repository contains a single Terraform module in [aws_basic/](aws_basic/) that provisions an AWS application stack.

**Network topology:**
- Uses the account's default VPC and all its subnets (auto-discovered via `data "aws_vpc" "default"` and `data "aws_subnets" "default"`)
- ALB spans all default subnets; EC2 is placed in the first discovered subnet
- Security group chaining: ALB SG allows inbound HTTP/HTTPS from internet; EC2 SG only allows traffic sourced from the ALB SG

**TLS/DNS flow:**
- ACM certificate is issued for `${var.subdomain}.${var.domain_name}` using DNS validation via Route53
- `for_each` on `aws_route53_record.cert_validation` handles the dynamic validation records
- `create_before_destroy` lifecycle on the ACM cert prevents downtime on cert rotation
- HTTP listener issues a 301 redirect to HTTPS; HTTPS listener uses `ELBSecurityPolicy-TLS13-1-2-2021-06`
- Route53 A record (alias) points `${var.subdomain}.${var.domain_name}` to the ALB

**Resource naming:** All resources are prefixed with `var.project_name` (e.g., `${var.project_name}-alb`, `${var.project_name}-alb-sg`).

**Required inputs** (no defaults): `project_name`, `ami_id`, `key_name`, `domain_name`

**Optional inputs** (with defaults): `aws_region` (`ap-northeast-2`), `instance_type` (`t3.micro`), `subdomain` (`app`)

**Outputs:** `alb_dns_name`, `app_url`, `instance_id`, `instance_private_ip`

**Provider constraint:** AWS provider `~> 5.0` (5.x only, not 6.x). Terraform `>= 1.0`.
