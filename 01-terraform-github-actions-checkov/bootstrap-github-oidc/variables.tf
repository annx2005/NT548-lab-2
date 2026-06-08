variable "aws_region" {
  description = "AWS region used for the lab."
  type        = string
  default     = "ap-southeast-1"
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the deploy role, in owner/repo format."
  type        = string
  default     = "annx2005/NT548-lab-2"
}

variable "github_branch" {
  description = "GitHub branch allowed to deploy automatically."
  type        = string
  default     = "main"
}

variable "state_bucket_name" {
  description = "Optional S3 bucket name for Terraform state. Leave empty to use nt548-lab2-tfstate-ACCOUNT_ID."
  type        = string
  default     = ""
}

variable "role_name" {
  description = "IAM role name for GitHub Actions."
  type        = string
  default     = "nt548-lab2-github-actions-terraform"
}

