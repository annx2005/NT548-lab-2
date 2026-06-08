data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name_prefix        = "nt548-lab2-ec2-"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "nt548-lab2-ec2-role"
  }
}

resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "nt548-lab2-ec2-"
  role        = aws_iam_role.ec2.name

  tags = {
    Name = "nt548-lab2-ec2-profile"
  }
}

#checkov:skip=CKV_AWS_88:Public EC2 is required by the lab as a bastion instance.
resource "aws_instance" "public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_ec2_security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  key_name                    = var.key_name
  monitoring                  = true
  ebs_optimized               = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "nt548-lab2-public-ec2"
  }
}

resource "aws_instance" "private" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.private_ec2_security_group_id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  key_name                    = var.key_name
  monitoring                  = true
  ebs_optimized               = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "nt548-lab2-private-ec2"
  }
}
