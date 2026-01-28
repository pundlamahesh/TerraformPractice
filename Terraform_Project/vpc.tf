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
#Attaching Route tables public subnets
resource "aws_route_table_association" "public_assoc_01" {
  subnet_id      = aws_subnet.public_01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_02" {
  subnet_id      = aws_subnet.public_02.id
  route_table_id = aws_route_table.public_rt.id
}

#Creating Route tables private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "RT_PRIVATE_01" }
}

#Attaching Route tables private subnets
resource "aws_route_table_association" "private_assoc_03" {
  subnet_id      = aws_subnet.private_03.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_05" {
  subnet_id      = aws_subnet.private_05.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_07" {
  subnet_id      = aws_subnet.db_07.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_08" {
  subnet_id      = aws_subnet.db_08.id
  route_table_id = aws_route_table.private_rt.id
}
# ---------------- RDS SUBNET GROUP ----------------
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group-01"
  subnet_ids = [aws_subnet.db_07.id, aws_subnet.db_08.id]
}
