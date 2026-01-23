variable "ingress_rules" {
  type = map(list(string))
  default = {
    22   = ["10.0.0.0/16"]
    80   = ["0.0.0.0/0"]
    443  = ["0.0.0.0/0"]
    8080 = ["192.168.1.0/24"]
    9000 = ["192.168.2.0/24"]
    3000 = ["10.10.0.0/16"]
    8081 = ["172.16.0.0/16"]
    8082 = ["172.20.0.0/16"]
  }
}

resource "aws_security_group" "devops_project_mahesh_differentSG" {
  name        = "devops-project-Mahesh_differentSG"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = "inbound rules"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-Mahesh"
  }
}
