#################################################
# Variables
#################################################

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance launch"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}

variable "bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

#################################################
# IAM Role
#################################################

resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-swiftpdf-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-ec2-role"
  })
}



#################################################
# SSM Policy Attachment
#################################################

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "s3_access" {
  name = "${var.environment}-swiftpdf-s3-access"

  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "BucketAccess"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          var.bucket_arn
        ]
      },
      {
        Sid    = "ObjectAccess"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}
#################################################
# Instance Profile
#################################################

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.environment}-swiftpdf-instance-profile"
  role = aws_iam_role.ec2_role.name
}

#################################################
# EC2 Instance
#################################################

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  key_name = var.key_name

  associate_public_ip_address = true
  monitoring                  = true

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-instance"
  })
}

#################################################
# Elastic IP
#################################################

resource "aws_eip" "public" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-swiftpdf-eip"
  })
}

#################################################
# Elastic IP Association
#################################################

resource "aws_eip_association" "public" {
  instance_id   = aws_instance.app.id
  allocation_id = aws_eip.public.id
}

#################################################
# Outputs
#################################################

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Elastic IP Address"
  value       = aws_eip.public.public_ip
}

output "public_dns" {
  description = "EC2 Public DNS"
  value       = aws_instance.app.public_dns
}

output "elastic_ip" {
  description = "Elastic IP"
  value       = aws_eip.public.public_ip
}