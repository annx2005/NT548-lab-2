# Bootstrap GitHub OIDC for Terraform CI/CD

Thu muc nay tao cac tai nguyen AWS can co truoc khi GitHub Actions co the tu deploy Terraform:

- S3 bucket luu Terraform state.
- GitHub Actions OIDC Identity Provider.
- IAM Role cho repo `annx2005/NT548-lab-2` assume role tu branch `main`.
- IAM policy cho phep role deploy ha tang lab 2 va truy cap S3 backend.

Can chay bootstrap local mot lan bang AWS credentials co quyen IAM/S3:

```bash
cd 01-terraform-github-actions-checkov/bootstrap-github-oidc
terraform init
terraform plan
terraform apply
```

Sau khi apply, lay output:

```bash
terraform output github_actions_role_arn
terraform output terraform_state_bucket
```

Tao GitHub Secrets trong repo `annx2005/NT548-lab-2`:

- `AWS_ROLE_TO_ASSUME`: gia tri cua `github_actions_role_arn`.
- `TF_STATE_BUCKET`: gia tri cua `terraform_state_bucket`.
- `MY_IP_CIDR`: IP public cua ban dang CIDR, vi du `1.2.3.4/32`.
- `EC2_KEY_NAME`: ten EC2 Key Pair da tao trong `ap-southeast-1`.

Neu AWS account da co OIDC provider `token.actions.githubusercontent.com`, import vao state truoc khi apply:

```bash
terraform import aws_iam_openid_connect_provider.github arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com
```

