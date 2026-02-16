
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  default = "ami-0fa3fe0fa7920f68e"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "keypair01"
}

