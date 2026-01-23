resource "aws_instance" "name" {
    ami = "ami-07ff62358b87c7116"
    instance_type = "t2.micro"
    tags = {
      Name = "dev"
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

#terraform apply -target=aws_s3_bucket.name  to apply specific resource
#terraform destroy -target=aws_s3_bucket.name