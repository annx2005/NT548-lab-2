# Bootstrap GitHub OIDC cho Terraform CI/CD

Thư mục này dùng để tạo các tài nguyên AWS cần thiết trước khi GitHub Actions có thể tự động deploy Terraform.

## Tài nguyên được tạo

Terraform trong thư mục này sẽ tạo:

- S3 bucket lưu Terraform state.
- GitHub Actions OIDC Identity Provider.
- IAM Role cho repo `annx2005/NT548-lab-2`.
- Trust policy cho phép branch `main` của repo assume role.
- IAM policy cho phép GitHub Actions deploy hạ tầng Lab 2.

## Vì sao cần bootstrap?

GitHub Actions muốn chạy Terraform trên AWS thì phải có quyền đăng nhập AWS.

Dự án này dùng GitHub OIDC thay vì lưu access key dài hạn. Vì vậy cần tạo IAM Role và OIDC Provider trước. Sau khi bootstrap xong, workflow GitHub Actions sẽ dùng role này để đăng nhập AWS tự động.

## Cách chạy

Đảm bảo máy local đã đăng nhập AWS CLI bằng tài khoản có quyền IAM và S3:

```bash
aws sts get-caller-identity
```

Chạy bootstrap:

```bash
cd 01-terraform-github-actions-checkov/bootstrap-github-oidc
terraform init
terraform plan
terraform apply
```

## Lấy output

Sau khi apply thành công, chạy:

```bash
terraform output github_actions_role_arn
terraform output terraform_state_bucket
```

Ví dụ:

```text
"arn:aws:iam::814845346103:role/nt548-lab2-github-actions-terraform"
"nt548-lab2-tfstate-814845346103"
```

Ý nghĩa:

- Giá trị đầu tiên là ARN của IAM Role cho GitHub Actions.
- Giá trị thứ hai là tên S3 bucket lưu Terraform state.

## Tạo GitHub Secrets

Vào repo `annx2005/NT548-lab-2` trên GitHub:

```text
Settings -> Secrets and variables -> Actions -> New repository secret
```

Tạo:

```text
AWS_ROLE_TO_ASSUME = arn:aws:iam::814845346103:role/nt548-lab2-github-actions-terraform
TF_STATE_BUCKET    = nt548-lab2-tfstate-814845346103
MY_IP_CIDR         = IP_PUBLIC_CỦA_BẠN/32
EC2_KEY_NAME       = TÊN_EC2_KEY_PAIR
```

Không nhập dấu ngoặc kép khi tạo secret.

## Trường hợp AWS account đã có GitHub OIDC Provider

Nếu tài khoản AWS đã có OIDC Provider `token.actions.githubusercontent.com`, Terraform có thể báo lỗi tài nguyên đã tồn tại.

Khi đó import tài nguyên vào state:

```bash
terraform import aws_iam_openid_connect_provider.github arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com
```

Sau đó chạy lại:

```bash
terraform plan
terraform apply
```

