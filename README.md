# NT548 Lab 2

Dự án này thực hiện Lab 2 với nội dung: quản lý và triển khai hạ tầng AWS và ứng dụng microservices bằng Terraform, CloudFormation, GitHub Actions và AWS CodePipeline.

## Cấu trúc thư mục

```text
.
├── 01-terraform-github-actions-checkov/
├── 02-cloudformation-codepipeline/
├── 03-github-actions-chatbot-cicd/
└── .github/workflows/
```

Ý nghĩa từng phần:

- `01-terraform-github-actions-checkov`: triển khai hạ tầng AWS bằng Terraform, tự động hóa bằng GitHub Actions và kiểm tra bảo mật bằng Checkov.
- `02-cloudformation-codepipeline`: triển khai hạ tầng AWS bằng CloudFormation, kiểm tra bằng CodeBuild với `cfn-lint` và Taskcat, tự động deploy bằng CodePipeline từ CodeCommit.
- `03-github-actions-chatbot-cicd`: tham chiếu yêu cầu 3 đã hoàn thành trong repo `annx2005/vietnamese-legal-chatbot` bằng git submodule.

Hiện tại phần đã hoàn thành là **yêu cầu 1**, **yêu cầu 2** và **yêu cầu 3**.

## Yêu cầu trước khi chạy

Cần chuẩn bị:

- Tài khoản AWS có quyền tạo IAM, S3, VPC, EC2, NAT Gateway và Security Group.
- Đã cài Terraform.
- Đã cài AWS CLI và cấu hình credentials local.
- Đã tạo EC2 Key Pair trong region `ap-southeast-1`.
- Repo GitHub: `annx2005/NT548-lab-2`.
- Với yêu cầu 2, tài khoản AWS cần dùng được CodeCommit, CodeBuild, CodePipeline và CloudFormation.
- Với yêu cầu 3, cần tải submodule `annx2005/vietnamese-legal-chatbot`.

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

## Cách chạy yêu cầu 2

Đọc hướng dẫn chi tiết tại:

```text
02-cloudformation-codepipeline/README.md
```

Tóm tắt quy trình:

1. Deploy stack `02-cloudformation-codepipeline/templates/pipeline.yml` để tạo CodeCommit repository, CodeBuild project, CodePipeline, S3 artifact bucket và IAM roles.
2. Push source code lên CodeCommit branch `main`.
3. CodePipeline tự động chạy Source -> Build -> Deploy.
4. CodeBuild chạy `cfn-lint` và `taskcat lint`.
5. CloudFormation deploy tuần tự 4 stack lấy từ repo Lab 1: VPC, network, security groups và EC2.

## Cách xem yêu cầu 3

Đọc hướng dẫn tại:

```text
03-github-actions-chatbot-cicd/README.md
```

Yêu cầu 3 đã được hoàn thành trong repo:

```text
https://github.com/annx2005/vietnamese-legal-chatbot
```

Repo này được nhúng vào Lab 2 dưới dạng git submodule. Sau khi clone repo Lab 2, tải submodule bằng lệnh:

```bash
git submodule update --init --recursive
```

Các workflow GitHub Actions, Dockerfile, Helm chart, Terraform và mã nguồn microservices nằm trong thư mục:

```text
03-github-actions-chatbot-cicd/vietnamese-legal-chatbot
```

## Repo lab 1 tham khảo

Phần Terraform của yêu cầu 1 được xây dựng dựa trên hạ tầng của repo lab 1:

```text
https://github.com/annx2005/NT548-lab1
```
