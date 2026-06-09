# Yêu cầu 3 - GitHub Actions CI/CD cho Vietnamese Legal Chatbot

Phần yêu cầu 3 đã được hoàn thành trong repository ứng dụng riêng:

```text
https://github.com/annx2005/vietnamese-legal-chatbot
```

Trong repo Lab 2, repository trên được nhúng dưới dạng git submodule tại:

```text
03-github-actions-chatbot-cicd/vietnamese-legal-chatbot
```

## Nội dung đã triển khai trong submodule

Ứng dụng `vietnamese-legal-chatbot` là hệ thống microservices gồm frontend, API router, các backend service, Docker, Helm chart, Terraform và GitHub Actions CI/CD.

Các workflow GitHub Actions chính nằm trong submodule:

```text
vietnamese-legal-chatbot/.github/workflows/deploy-backend.yml
vietnamese-legal-chatbot/.github/workflows/deploy-frontend.yml
vietnamese-legal-chatbot/.github/workflows/deploy-gke.yml
vietnamese-legal-chatbot/.github/workflows/sonarqube.yml
vietnamese-legal-chatbot/.github/workflows/trivy.yml
```

Các workflow này dùng để build, kiểm tra chất lượng mã nguồn, scan bảo mật và triển khai ứng dụng.

## Cách tải submodule sau khi clone repo Lab 2

Sau khi clone repository Lab 2, chạy:

```bash
git submodule update --init --recursive
```

Nếu muốn cập nhật submodule lên commit mới hơn từ repo `vietnamese-legal-chatbot`, chạy:

```bash
git submodule update --remote 03-github-actions-chatbot-cicd/vietnamese-legal-chatbot
git add 03-github-actions-chatbot-cicd/vietnamese-legal-chatbot
git commit -m "Update requirement 3 chatbot submodule"
```

## Cách xem và chạy phần yêu cầu 3

Vào thư mục submodule:

```bash
cd 03-github-actions-chatbot-cicd/vietnamese-legal-chatbot
```

Đọc hướng dẫn chi tiết trong README của ứng dụng:

```bash
less README.md
```

Chạy ứng dụng local bằng Docker Compose:

```bash
docker compose up --build
```

Các endpoint local chính:

```text
Chat:      http://localhost:5173/chat
Admin:     http://localhost:5173/admin
API:       http://localhost:8080
RAG docs:  http://localhost:8000/docs
Ingestion: http://localhost:8001/docs
```

## Ghi chú

Repo Lab 2 chỉ tham chiếu phần yêu cầu 3 bằng submodule để tránh copy toàn bộ source ứng dụng vào repo bài lab. Toàn bộ mã nguồn, Dockerfile, Helm chart, Terraform và GitHub Actions CI/CD của yêu cầu 3 được quản lý trong repository `annx2005/vietnamese-legal-chatbot`.
