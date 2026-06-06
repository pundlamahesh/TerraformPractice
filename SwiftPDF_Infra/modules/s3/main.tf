#################################################
# Variables
#################################################

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}

#################################################
# S3 Bucket
#################################################

resource "aws_s3_bucket" "swiftpdf" {
  bucket = var.bucket_name

  force_destroy = false

  tags = merge(var.common_tags, {
    Name = var.bucket_name
  })
}

#################################################
# Versioning
#################################################

resource "aws_s3_bucket_versioning" "swiftpdf" {
  bucket = aws_s3_bucket.swiftpdf.id

  versioning_configuration {
    status = "Enabled"
  }
}

#################################################
# Server-Side Encryption
#################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "swiftpdf" {
  bucket = aws_s3_bucket.swiftpdf.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#################################################
# Block Public Access
#################################################

resource "aws_s3_bucket_public_access_block" "swiftpdf" {
  bucket = aws_s3_bucket.swiftpdf.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#################################################
# Ownership Controls
#################################################

resource "aws_s3_bucket_ownership_controls" "swiftpdf" {
  bucket = aws_s3_bucket.swiftpdf.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#################################################
# Outputs
#################################################

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.swiftpdf.bucket
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.swiftpdf.arn
}