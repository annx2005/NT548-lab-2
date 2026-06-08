output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "nat_gateway_id" {
  value = module.network.nat_gateway_id
}

output "public_ec2_security_group_id" {
  value = module.security_group.public_ec2_security_group_id
}

output "private_ec2_security_group_id" {
  value = module.security_group.private_ec2_security_group_id
}

output "public_instance_id" {
  value = module.ec2.public_instance_id
}

output "public_instance_public_ip" {
  value = module.ec2.public_instance_public_ip
}

output "private_instance_id" {
  value = module.ec2.private_instance_id
}

output "private_instance_private_ip" {
  value = module.ec2.private_instance_private_ip
}

