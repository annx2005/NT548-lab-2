# Yêu cầu 1 - Terraform, GitHub Actions và Checkov

Thư mục này triển khai lại hạ tầng AWS của Lab 1 bằng Terraform, sau đó tự động hóa quy trình kiểm tra và triển khai bằng GitHub Actions.

## Hạ tầng được triển khai

Terraform sẽ tạo các tài nguyên AWS sau:

- VPC.
- Public subnet và private subnet.
- Internet Gateway.
- NAT Gateway.
- Public route table và private route table.
- Security Group cho public EC2.
- Security Group cho private EC2.
- Public EC2 instance.
- Private EC2 instance.
- IAM instance profile tối thiểu cho EC2.

## Cấu trúc thư mục

```text
01-terraform-github-actions-checkov/
├── bootstrap-github-oidc/
├── terraform/
└── .checkov.yml
```

Trong đó:

- `bootstrap-github-oidc`: tạo S3 bucket lưu Terraform state, GitHub OIDC Provider và IAM Role cho GitHub Actions.
- `terraform`: mã Terraform chính để tạo VPC, route table, NAT Gateway, EC2 và Security Group.
- `.checkov.yml`: cấu hình Checkov.

Workflow GitHub Actions nằm tại:

```text
.github/workflows/requirement-1-terraform.yml
```

## Bước 1: Chạy bootstrap AWS cho GitHub Actions

GitHub Actions cần có IAM Role để đăng nhập AWS. Vì vậy cần chạy bootstrap local một lần trước.

Chạy lệnh:

```bash
cd 01-terraform-github-actions-checkov/bootstrap-github-oidc
terraform init
terraform plan
terraform apply
```

Sau khi apply xong, lấy hai output:

```bash
terraform output github_actions_role_arn
terraform output terraform_state_bucket
```

Ví dụ output:

```text
github_actions_role_arn = "arn:aws:iam::814845346103:role/nt548-lab2-github-actions-terraform"
terraform_state_bucket  = "nt548-lab2-tfstate-814845346103"
```

Khi nhập vào GitHub Secrets thì không nhập dấu ngoặc kép.

## Bước 2: Tạo GitHub Secrets

Vào repo GitHub:

```text
Settings -> Secrets and variables -> Actions -> New repository secret
```

Tạo các secret sau:

```text
AWS_ROLE_TO_ASSUME = arn:aws:iam::814845346103:role/nt548-lab2-github-actions-terraform
TF_STATE_BUCKET    = nt548-lab2-tfstate-814845346103
MY_IP_CIDR         = IP_PUBLIC_CỦA_BẠN/32
EC2_KEY_NAME       = TÊN_EC2_KEY_PAIR
```

Giải thích:

- `AWS_ROLE_TO_ASSUME`: ARN của IAM Role mà GitHub Actions sẽ assume để đăng nhập AWS.
- `TF_STATE_BUCKET`: tên S3 bucket dùng để lưu Terraform state.
- `MY_IP_CIDR`: IP public của máy bạn, ví dụ `1.2.3.4/32`.
- `EC2_KEY_NAME`: tên EC2 Key Pair đã tạo trong region `ap-southeast-1`.
- AMI mặc định được lấy từ SSM Parameter `/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-default-hvm-x86_64-gp2`. Nếu file `terraform.tfvars` cũ còn dùng `resolve:ssm:...`, Terraform cũng sẽ tự chuyển chuỗi đó thành AMI ID thật trước khi tạo EC2.

Lấy IP public:

```bash
curl https://checkip.amazonaws.com
```

Nếu kết quả là `1.2.3.4`, secret `MY_IP_CIDR` sẽ là:

```text
1.2.3.4/32
```

## Bước 3: Kiểm tra Terraform local

Nếu muốn kiểm tra mã Terraform trên máy trước khi push:

```bash
cd 01-terraform-github-actions-checkov/terraform
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

Nếu muốn chạy Checkov local:

```bash
cd ..
checkov -d terraform --config-file .checkov.yml
```

## Bước 4: Deploy tự động bằng GitHub Actions

Sau khi đã tạo đủ GitHub Secrets, chỉ cần push code lên branch `main`:

```bash
git add .
git commit -m "Complete requirement 1 with Terraform and GitHub Actions"
git push origin main
```

GitHub Actions sẽ tự động chạy:

```text
terraform fmt
terraform init
terraform validate
checkov
terraform plan
terraform apply -auto-approve
```

Pull request chỉ chạy kiểm tra `fmt`, `validate` và `checkov`, không deploy hạ tầng AWS.

## Cấu hình bảo mật đã bổ sung

So với Lab 1, phần Terraform đã bổ sung một số cấu hình để vượt qua Checkov và tăng tính an toàn:

- EC2 bật IMDSv2.
- Root volume của EC2 được mã hóa.
- EC2 bật detailed monitoring.
- EC2 có IAM instance profile tối thiểu.
- Default Security Group của VPC không mở ingress/egress.
- Security Group egress chỉ mở HTTP và HTTPS.
- S3 bucket lưu Terraform state có versioning, encryption và block public access.

## Xóa hạ tầng

Nếu muốn xóa hạ tầng chính:

```bash
cd 01-terraform-github-actions-checkov/terraform
terraform init \
  -backend-config="bucket=nt548-lab2-tfstate-814845346103" \
  -backend-config="region=ap-southeast-1"
terraform destroy
```

Sau khi đã xóa hạ tầng chính, nếu muốn xóa cả phần bootstrap:

```bash
cd ../bootstrap-github-oidc
terraform destroy
```

Lưu ý: chỉ xóa bootstrap sau khi không còn cần GitHub Actions deploy nữa.
