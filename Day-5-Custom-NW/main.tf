data "aws_availability_zones" "available" {}

# ---------------- VPC ----------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_MAHESH_01"
  }
}

# ---------------- IGW ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "IGW_01" }
}

# ---------------- PUBLIC SUBNETS ----------------
resource "aws_subnet" "public_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/28"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "SUBNET01_PUBLIC" }
}

resource "aws_subnet" "public_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.16/28"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = { Name = "SUBNET02_PUBLIC" }
}

# ---------------- PRIVATE SUBNETS ----------------
resource "aws_subnet" "private_03" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.32/28"
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = { Name = "SUBNET03_PRIVATE" }
}

resource "aws_subnet" "private_05" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.64/28"
  availability_zone = data.aws_availability_zones.available.names[4]
  tags = { Name = "SUBNET05_PRIVATE" }
}

# ---------------- DB SUBNETS ----------------
resource "aws_subnet" "db_07" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.96/28"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "DB_SUBNET07_PRIVATE" }
}

resource "aws_subnet" "db_08" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.112/28"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = { Name = "DB_SUBNET08_PRIVATE" }
}

# ---------------- NAT GATEWAY ----------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_01.id
  tags = { Name = "NAT_GW_01" }
}

# ---------------- ROUTE TABLES ----------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "RT_01" }
}

resource "aws_route_table_association" "public_assoc_01" {
  subnet_id      = aws_subnet.public_01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_02" {
  subnet_id      = aws_subnet.public_02.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "RT_PRIVATE_01" }
}

resource "aws_route_table_association" "private_assoc_03" {
  subnet_id      = aws_subnet.private_03.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_05" {
  subnet_id      = aws_subnet.private_05.id
  route_table_id = aws_route_table.private_rt.id
}

# ---------------- SECURITY GROUPS ----------------
resource "aws_security_group" "web_sg" {
  name   = "demo-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#-------------------KEYPAIR Creation and download--------------
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "keypair01"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  filename        = "C:/TerraformPractice/keypair01.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400"
}


# ---------------- EC2 INSTANCES ----------------
resource "aws_instance" "public_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_01.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  tags = { Name = "PublicServer" }
}

resource "aws_instance" "backend_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_03.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  tags = { Name = "BackendServer" }
}

resource "aws_instance" "frontend_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_05.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  tags = { Name = "FrontendServer" }
}

# ---------------- S3 ----------------
resource "aws_s3_bucket" "bucket" {
  bucket = "mahesh-1608"
}

# ---------------- RDS SUBNET GROUP ----------------
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group-01"
  subnet_ids = [aws_subnet.db_07.id, aws_subnet.db_08.id]
}
