locals {
  common_tags = {
    Project     = "SwiftPDF"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "networking" {
  source = "./modules/networking"

  environment       = var.environment
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  ssh_allowed_cidr  = var.ssh_allowed_cidr

  common_tags = local.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  environment = var.environment
  subnet_id   = module.networking.subnet_id

  security_group_id = module.networking.security_group_id

  instance_type = var.instance_type
  key_name      = var.key_name
  ami_id        = var.ami_id
  bucket_arn    = module.s3.bucket_arn

  common_tags = local.common_tags
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
  common_tags = local.common_tags
}