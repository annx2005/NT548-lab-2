variable "public_subnet_id" {
  description = "Public subnet ID."
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID."
  type        = string
}

variable "public_ec2_security_group_id" {
  description = "Security group ID for the public EC2 instance."
  type        = string
}

variable "private_ec2_security_group_id" {
  description = "Security group ID for the private EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 Key Pair."
  type        = string
}

