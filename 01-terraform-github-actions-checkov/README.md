# Requirement 1 - Terraform, GitHub Actions, Checkov

Thu muc nay trien khai lai ha tang AWS cua lab 1 bang Terraform:

- VPC
- Public/private subnets
- Internet Gateway
- NAT Gateway
- Public/private route tables
- Security groups
- Public/private EC2 instances

## Cau truc

```text
terraform/
  main.tf
  provider.tf
  variables.tf
  outputs.tf
  terraform.tfvars.example
  modules/
    vpc/
    network/
    security_group/
    ec2/
```

Workflow GitHub Actions nam tai:

```text
.github/workflows/requirement-1-terraform.yml
```

Bootstrap AWS OIDC/IAM cho GitHub Actions nam tai:

```text
bootstrap-github-oidc/
```

## Chay local

```bash
cd 01-terraform-github-actions-checkov/terraform
cp terraform.tfvars.example terraform.tfvars
```

Sua cac gia tri bat buoc:

- `my_ip_cidr`: IP public cua may ban, vi du `1.2.3.4/32`.
- `key_name`: ten EC2 Key Pair da tao trong region `ap-southeast-1`.

Kiem tra va deploy:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
terraform plan
terraform apply
```

Neu muon dung S3 backend nhu workflow, chay bootstrap truoc de tao S3 bucket va IAM role:

```bash
cd ../bootstrap-github-oidc
terraform init
terraform apply
```

## Checkov

Chay Checkov local:

```bash
checkov -d terraform --config-file .checkov.yml
```

Mot so cau hinh bao mat da bo sung so voi lab 1:

- EC2 bat IMDSv2.
- Root volume EC2 duoc encrypt.
- EC2 bat detailed monitoring.
- EC2 co IAM instance profile toi thieu.
- Default security group cua VPC bi khoa ingress/egress.
- Egress security group gioi han HTTP/HTTPS thay vi mo tat ca protocol/port.

## GitHub Actions

Workflow tu dong chay khi push/pull request co thay doi trong phan 1:

- `terraform fmt/init/validate` cho `bootstrap-github-oidc`
- `terraform fmt -check`
- `terraform init -backend=false`
- `terraform validate`
- `checkov`

Khi push vao branch `main`, workflow se tu dong:

- Cau hinh AWS credentials bang GitHub OIDC.
- Init Terraform voi S3 backend.
- Chay `terraform plan`.
- Chay `terraform apply -auto-approve`.

Pull request chi chay validate va Checkov, khong deploy ha tang AWS.

Can cau hinh GitHub Secrets:

- `AWS_ROLE_TO_ASSUME`: lay tu output `github_actions_role_arn` cua `bootstrap-github-oidc`.
- `TF_STATE_BUCKET`: lay tu output `terraform_state_bucket` cua `bootstrap-github-oidc`.
- `MY_IP_CIDR`: IP public dang CIDR, vi du `1.2.3.4/32`.
- `EC2_KEY_NAME`: ten EC2 Key Pair.
