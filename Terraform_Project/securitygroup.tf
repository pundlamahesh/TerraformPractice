# ---------------- SECURITY GROUPS ----------------
resource "aws_security_group" "bastion-host" {
  name   = "appserver-SG"
  description = "Allow inbound traffic from ALB"
  vpc_id = aws_vpc.main.id
  depends_on = [ aws_vpc.main ]

 dynamic "ingress" {
  for_each = [22, 80]
  content {
    description = "Allow traffic from web layer"
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-host-server-sg"
  }
}

# frontend server sg
resource "aws_security_group" "frontend-server-sg" {
  name        = "frontend-server-sg"
  description = "Allow inbound traffic "
  vpc_id      = aws_vpc.main.id
  depends_on = [ aws_vpc.main]

 dynamic "ingress" {
  for_each = {
    http = 80
    ssh  = 22
  }
  content {
    description = ingress.key
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-server-sg"
  }

}

#  backend-server-sg

resource "aws_security_group" "backend-server-sg" {
  name        = "backend-server-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id
  depends_on = [ aws_vpc.main]

 dynamic "ingress" {
  for_each = {
    http = 80
    ssh  = 22
  }
  content {
    description = ingress.key
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-server-sg"
  }
}


# database security group
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Allow inbound "
  vpc_id      = aws_vpc.main.id
  depends_on = [ aws_vpc.main ]

 ingress {
    description     = "mysql/aroura"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
 }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }

}