cat > aws-network-baseline-terraform/README.md << 'EOF'
# AWS Network Baseline (Terraform)

This project provides a secure, multi-AZ AWS VPC baseline suitable for hosting web and application workloads. It’s designed as a reusable foundation that can be extended with compute, data, and platform services.

## Architecture (High Level)
- VPC with DNS support enabled
- Public subnets across multiple AZs (internet-facing)
- Private subnets across multiple AZs (workloads/datastores)
- Internet Gateway for inbound/outbound public traffic
- NAT Gateways for controlled outbound access from private subnets
- Route tables per tier (public/private)

## What This Demonstrates
- Terraform module organization (reusable network module + environment entrypoint)
- Multi-AZ subnetting and predictable CIDR planning
- Secure-by-default separation of public vs private tiers
- Tagging conventions for operational clarity

## How to Run (Dev Example)
From `terraform/envs/dev`:
1. `terraform init`
2. `terraform fmt -recursive`
3. `terraform validate`
4. `terraform plan -var-file=dev.tfvars`
5. `terraform apply -var-file=dev.tfvars`

## Security Notes
- Private subnets are isolated from direct internet ingress
- Outbound internet from private subnets is mediated via NAT
- IAM should follow least privilege for Terraform execution

## Next Improvements (Production Hardening)
- Remote state backend (S3 + DynamoDB locking)
- VPC Flow Logs + centralized logging
- VPC endpoints (S3, STS, etc.) to reduce NAT dependency
- Policy-as-code checks (tflint, tfsec/trivy, OPA)
EOF
