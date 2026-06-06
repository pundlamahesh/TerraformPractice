environment       = "prod"
aws_region        = "us-west-2"
availability_zone = "us-west-2a"

vpc_cidr    = "10.20.0.0/16"
subnet_cidr = "10.20.1.0/24"

instance_type    = "t3.medium"
key_name         = "swiftpdf-prod-key"
ami_id           = "ami-0d13e2317a7e75c95"
ssh_allowed_cidr = "49.207.197.179/32"

bucket_name = "swiftpdf-prod-storage"