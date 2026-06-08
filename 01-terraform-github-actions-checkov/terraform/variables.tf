variable "aws_region" {
  description = "AWS region used for the lab."
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability Zone used by both lab subnets."
  type        = string
  default     = "ap-southeast-1a"
}

variable "my_ip_cidr" {
  description = "Your public IP CIDR allowed to SSH to the public EC2 instance."
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0))
    error_message = "my_ip_cidr must be a valid CIDR block, for example 1.2.3.4/32."
  }
}

variable "ami_id" {
  description = "Optional explicit AMI ID for the EC2 instances. Leave empty to resolve Amazon Linux 2 from SSM. Legacy resolve:ssm: values are also supported."
  type        = string
  default     = ""
}

variable "ami_ssm_parameter" {
  description = "SSM public parameter used to resolve the latest Amazon Linux 2 AMI when ami_id is empty."
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-default-hvm-x86_64-gp2"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair in the selected AWS region."
  type        = string
}
