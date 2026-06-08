resource "aws_security_group" "public_ec2" {
  name        = "nt548-lab2-public-ec2-sg"
  description = "Allow SSH to public EC2 only from the configured IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    description = "HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nt548-lab2-public-ec2-sg"
  }
}

resource "aws_security_group" "private_ec2" {
  name        = "nt548-lab2-private-ec2-sg"
  description = "Allow SSH to private EC2 only from public EC2 security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from public EC2 SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    description = "HTTP outbound through NAT"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS outbound through NAT"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nt548-lab2-private-ec2-sg"
  }
}

