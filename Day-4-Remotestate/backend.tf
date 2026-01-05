terraform {
  backend "s3" {
    bucket = "mahesh-1608"
    key = "da-4/terraform.tfstate"
    region = "us-east-1"
    #enable s3 native locking
    use_lockfile = true
  }
}