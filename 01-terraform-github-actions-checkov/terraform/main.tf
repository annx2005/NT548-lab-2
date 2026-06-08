module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "network" {
  source              = "./modules/network"
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "security_group" {
  source     = "./modules/security_group"
  vpc_id     = module.vpc.vpc_id
  my_ip_cidr = var.my_ip_cidr
}

module "ec2" {
  source                        = "./modules/ec2"
  public_subnet_id              = module.network.public_subnet_id
  private_subnet_id             = module.network.private_subnet_id
  public_ec2_security_group_id  = module.security_group.public_ec2_security_group_id
  private_ec2_security_group_id = module.security_group.private_ec2_security_group_id
  ami_id                        = var.ami_id
  instance_type                 = var.instance_type
  key_name                      = var.key_name
}

