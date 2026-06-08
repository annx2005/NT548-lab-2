# NT548 Lab 2

Dự án này thực hiện Lab 2 với nội dung: quản lý và triển khai hạ tầng AWS và ứng dụng microservices bằng Terraform, CloudFormation, GitHub Actions, AWS CodePipeline và Jenkins.

## Cấu trúc thư mục

```text
.
├── 01-terraform-github-actions-checkov/
├── 02-cloudformation-codepipeline/
├── 03-jenkins-microservices-cicd/
└── .github/workflows/
```

Ý nghĩa từng phần:

- `01-terraform-github-actions-checkov`: triển khai hạ tầng AWS bằng Terraform, tự động hóa bằng GitHub Actions và kiểm tra bảo mật bằng Checkov.
- `02-cloudformation-codepipeline`: dành cho phần CloudFormation, CodeBuild và CodePipeline.
- `03-jenkins-microservices-cicd`: dành cho phần Jenkins CI/CD cho ứng dụng microservices.

Hiện tại phần đã hoàn thành là **yêu cầu 1**.

## Yêu cầu trước khi chạy

Cần chuẩn bị:

- Tài khoản AWS có quyền tạo IAM, S3, VPC, EC2, NAT Gateway và Security Group.
- Đã cài Terraform.
- Đã cài AWS CLI và cấu hình credentials local.
- Đã tạo EC2 Key Pair trong region `ap-southeast-1`.
- Repo GitHub: `annx2005/NT548-lab-2`.

Kiểm tra nhanh:

```bash
terraform version
aws sts get-caller-identity
```

## Cách chạy yêu cầu 1

Đọc hướng dẫn chi tiết tại:

```text
01-terraform-github-actions-checkov/README.md
```

Tóm tắt quy trình:

1. Chạy bootstrap Terraform để tạo S3 bucket lưu state, GitHub OIDC Provider và IAM Role cho GitHub Actions.
2. Lấy output từ bootstrap và tạo GitHub Secrets.
3. Push code lên branch `main`.
4. GitHub Actions tự động chạy `terraform plan` và `terraform apply`.

## Repo lab 1 tham khảo

Phần Terraform của yêu cầu 1 được xây dựng dựa trên hạ tầng của repo lab 1:

```text
https://github.com/annx2005/NT548-lab1
```

