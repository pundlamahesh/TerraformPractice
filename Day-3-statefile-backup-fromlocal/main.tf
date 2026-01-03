resource "aws_instance" "name" {
    ami="ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    tags = {
      Name = "test"
    }
   
}
resource "aws_s3_bucket" "name" {
  bucket = "mahesh-1608"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.name.id
  versioning_configuration {
    status = "Enabled"
  }
}