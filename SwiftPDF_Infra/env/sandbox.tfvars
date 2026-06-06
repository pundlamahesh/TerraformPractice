environment = "sandbox"
aws_region  = "us-east-1"

vpc_cidr    = "10.10.0.0/16"
subnet_cidr = "10.10.1.0/24"

instance_type = "t3.micro"
key_name      = "swiftpdf-sandbox-key"
ami_id        = "ami-091138d0f0d41ff90"

ssh_allowed_cidr = "49.207.197.179/32"

bucket_name = "swiftpdf-sandbox-storage"