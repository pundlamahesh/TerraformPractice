output "vpc_id" {
  value       = module.networking.vpc_id
  description = "ID of the created VPC"
}

output "subnet_id" {
  value       = module.networking.subnet_id
  description = "ID of the public subnet"
}

output "security_group_id" {
  value       = module.networking.security_group_id
  description = "ID of the public security group"
}

output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "Public IP address of the EC2 instance"
}

output "ec2_public_dns" {
  value       = module.ec2.public_dns
  description = "Public DNS name of the EC2 instance"
}

output "elastic_ip" {
  value       = module.ec2.elastic_ip
  description = "Elastic IP allocated to the EC2 instance"
}

output "s3_bucket_name" {
  value       = module.s3.bucket_name
  description = "Name of the S3 bucket"
}

output "s3_bucket_arn" {
  value       = module.s3.bucket_arn
  description = "ARN of the S3 bucket"
}
