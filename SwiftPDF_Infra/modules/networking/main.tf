#################################################
# Variables
#################################################

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
}

variable "availability_zone" {
  description = "Availability Zone for subnet"
  type        = string
}

#################################################
# VPC
#################################################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-vpc"
  })
}

#################################################
# Public Subnet
#################################################

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-public-subnet"
  })
}

#################################################
# Internet Gateway
#################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-igw"
  })
}

#################################################
# Route Table
#################################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-public-route-table"
  })
}

#################################################
# Default Internet Route
#################################################

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#################################################
# Route Table Association
#################################################

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#################################################
# Security Group
#################################################

resource "aws_security_group" "public" {
  name        = "${var.environment}-swiftpdf-sg"
  description = "Security Group for SwiftPDF EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH Access"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All Outbound"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-security-group"
  })
}

#################################################
# Outputs
#################################################

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.public.id
}