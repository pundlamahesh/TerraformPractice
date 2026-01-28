
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  default = "ami-0fa3fe0fa7920f68e"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "keypair01"
}

variable "key_path" {
  default = "C:/Terraformpractice/keypair01.pem"
}
variable "rds-password" {
    description = "rds password"
    type = string
    default = "Cloud123"
  
}
variable "rds-username" {
    description = "rds username"
    type = string
    default = "admin"
  
}