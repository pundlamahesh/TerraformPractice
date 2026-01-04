terraform {
  backend "s3" {
    bucket = "mahesh-1608"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}