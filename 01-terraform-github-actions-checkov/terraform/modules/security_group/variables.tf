variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "my_ip_cidr" {
  description = "Public IP CIDR allowed to SSH to the public EC2 instance."
  type        = string
}

