# ---------------- S3 ----------------
resource "aws_s3_bucket" "tf_state" {
  bucket = "mahesh-1608"

  tags = {
    Name = "terraform-state-bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}