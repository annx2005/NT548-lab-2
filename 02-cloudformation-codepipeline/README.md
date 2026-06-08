# Yêu cầu 2 - CloudFormation, CodeBuild và CodePipeline

Thư mục này dùng lại các file CloudFormation từ repo Lab 1:

```text
https://github.com/annx2005/NT548-lab1/tree/main/cloudformation/stacks
```

Sau đó tự động hóa quy trình kiểm tra và triển khai bằng AWS CodeBuild và AWS CodePipeline, với source lấy từ AWS CodeCommit.

## Hạ tầng được triển khai

Các stack CloudFormation được lấy theo cấu trúc của Lab 1:

- `stacks/01-vpc.yaml`: tạo VPC.
- `stacks/02-network.yaml`: tạo public subnet, private subnet, Internet Gateway, NAT Gateway và route tables.
- `stacks/03-security-groups.yaml`: tạo Security Group cho public EC2 và private EC2.
- `stacks/04-ec2.yaml`: tạo public EC2 và private EC2.

Pipeline deploy tuần tự theo thứ tự:

```text
nt548-lab2-vpc
nt548-lab2-network
nt548-lab2-security-groups
nt548-lab2-ec2
```

## Cấu trúc thư mục

```text
02-cloudformation-codepipeline/
├── stacks/
│   ├── 01-vpc.yaml
│   ├── 02-network.yaml
│   ├── 03-security-groups.yaml
│   └── 04-ec2.yaml
├── templates/
│   └── pipeline.yml
├── .taskcat.yml
├── buildspec.yml
└── README.md
```

Trong đó:

- `stacks/*.yaml`: các CloudFormation stack từ Lab 1.
- `templates/pipeline.yml`: template tạo CodeCommit repository, CodeBuild project, CodePipeline, S3 artifact bucket và IAM roles.
- `buildspec.yml`: cấu hình CodeBuild để cài `cfn-lint`, `taskcat`, chạy lint và kiểm tra CloudFormation.
- `.taskcat.yml`: cấu hình Taskcat để lint 4 stack của Lab 1.

## Bước 1: Chuẩn bị giá trị đầu vào

Cần có:

- AWS CLI đã đăng nhập đúng account.
- EC2 Key Pair đã tồn tại trong region `ap-southeast-1`.
- IP public của máy bạn ở dạng CIDR `/32`.

Lấy IP public:

```bash
curl https://checkip.amazonaws.com
```

Nếu output là `1.2.3.4`, giá trị `MyIpCidr` sẽ là:

```text
1.2.3.4/32
```

## Bước 2: Kiểm tra local trước khi push

Nếu muốn kiểm tra trên máy local:

```bash
cd /path/to/NT548_lab_2
python3 -m pip install cfn-lint taskcat
cfn-lint -i W3005 -- \
  02-cloudformation-codepipeline/stacks/*.yaml \
  02-cloudformation-codepipeline/templates/pipeline.yml
taskcat lint -i 02-cloudformation-codepipeline/.taskcat.yml -p .
```

`W3005` được ignore vì file `02-network.yaml` của Lab 1 có `DependsOn: NatGateway` dư, trong khi dependency này đã được CloudFormation tự suy ra từ `NatGatewayId: !Ref NatGateway`. Đây là warning lint, không phải lỗi triển khai.

## Bước 3: Tạo stack CodePipeline

Chạy lệnh sau để tạo CodeCommit repository, CodeBuild project và CodePipeline:

```bash
aws cloudformation deploy \
  --template-file 02-cloudformation-codepipeline/templates/pipeline.yml \
  --stack-name nt548-lab2-cloudformation-pipeline \
  --region ap-southeast-1 \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    MyIpCidr=YOUR_PUBLIC_IP/32 \
    KeyName=YOUR_EC2_KEY_PAIR
```

Ví dụ:

```bash
aws cloudformation deploy \
  --template-file 02-cloudformation-codepipeline/templates/pipeline.yml \
  --stack-name nt548-lab2-cloudformation-pipeline \
  --region ap-southeast-1 \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    MyIpCidr=1.2.3.4/32 \
    KeyName=nt548-lab1-key
```

Sau khi deploy xong, lấy clone URL của CodeCommit:

```bash
aws cloudformation describe-stacks \
  --stack-name nt548-lab2-cloudformation-pipeline \
  --region ap-southeast-1 \
  --query "Stacks[0].Outputs"
```

## Bước 4: Push mã nguồn lên CodeCommit

Thêm remote CodeCommit bằng clone URL lấy từ output `RepositoryCloneUrlHttp` hoặc `RepositoryCloneUrlSsh`:

```bash
git remote add codecommit CODECOMMIT_CLONE_URL
git push codecommit main
```

Mặc định pipeline đọc source từ branch `main`.

Nếu bạn chỉ push riêng nội dung thư mục `02-cloudformation-codepipeline` vào CodeCommit thay vì push cả repo Lab 2, cần deploy pipeline với các path ngắn hơn:

```bash
aws cloudformation deploy \
  --template-file 02-cloudformation-codepipeline/templates/pipeline.yml \
  --stack-name nt548-lab2-cloudformation-pipeline \
  --region ap-southeast-1 \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    MyIpCidr=YOUR_PUBLIC_IP/32 \
    KeyName=YOUR_EC2_KEY_PAIR \
    BuildSpecPath=buildspec.yml \
    VpcTemplatePath=SourceArtifact::stacks/01-vpc.yaml \
    NetworkTemplatePath=SourceArtifact::stacks/02-network.yaml \
    SecurityGroupsTemplatePath=SourceArtifact::stacks/03-security-groups.yaml \
    Ec2TemplatePath=SourceArtifact::stacks/04-ec2.yaml
```

## Pipeline tự động hóa những gì?

Sau mỗi lần push vào CodeCommit branch `main`, CodePipeline chạy:

```text
Source: lấy source từ AWS CodeCommit
Build : CodeBuild cài cfn-lint và Taskcat
        cfn-lint stacks/*.yaml và templates/pipeline.yml
        taskcat lint để kiểm tra 4 stack
Deploy: CloudFormation deploy tuần tự VPC -> Network -> Security Groups -> EC2
```

## Xem kết quả

Kiểm tra pipeline:

```bash
aws codepipeline get-pipeline-state \
  --name nt548-lab2-cloudformation-pipeline \
  --region ap-southeast-1
```

Kiểm tra output của stack EC2:

```bash
aws cloudformation describe-stacks \
  --stack-name nt548-lab2-ec2 \
  --region ap-southeast-1 \
  --query "Stacks[0].Outputs"
```

Output quan trọng:

```text
PublicInstancePublicIp
PrivateInstancePrivateIp
```

## Xóa hạ tầng

Xóa các stack theo thứ tự ngược lại:

```bash
aws cloudformation delete-stack --stack-name nt548-lab2-ec2 --region ap-southeast-1
aws cloudformation delete-stack --stack-name nt548-lab2-security-groups --region ap-southeast-1
aws cloudformation delete-stack --stack-name nt548-lab2-network --region ap-southeast-1
aws cloudformation delete-stack --stack-name nt548-lab2-vpc --region ap-southeast-1
aws cloudformation delete-stack --stack-name nt548-lab2-cloudformation-pipeline --region ap-southeast-1
```

Lưu ý: NAT Gateway và EC2 có thể phát sinh chi phí khi stack đang tồn tại.
