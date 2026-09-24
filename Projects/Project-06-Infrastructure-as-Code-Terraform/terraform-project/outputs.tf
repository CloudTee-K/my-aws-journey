output "vpc_id" {
  description = "ID of the Project 06 VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}
output "ec2_instance_id" {
  description = "ID of the EC2 web server"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 web server"
  value       = module.ec2.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the PostgreSQL database"
  value       = module.rds.db_endpoint
}