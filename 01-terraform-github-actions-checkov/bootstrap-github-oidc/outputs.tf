output "github_actions_role_arn" {
  description = "Use this value for the AWS_ROLE_TO_ASSUME GitHub Secret."
  value       = aws_iam_role.github_actions.arn
}

output "terraform_state_bucket" {
  description = "Use this value for the TF_STATE_BUCKET GitHub Secret."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "allowed_github_subject" {
  description = "GitHub OIDC subject allowed to assume the role."
  value       = local.github_subject
}

