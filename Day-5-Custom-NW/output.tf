output "vpc_id" {
  value = aws_vpc.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "public_subnet_01_id" {
  value = aws_subnet.public_01.id
}

output "public_subnet_02_id" {
  value = aws_subnet.public_02.id
}

output "private_subnet_03_id" {
  value = aws_subnet.private_03.id
}

output "private_subnet_05_id" {
  value = aws_subnet.private_05.id
}

output "db_subnet_07_id" {
  value = aws_subnet.db_07.id
}

output "db_subnet_08_id" {
  value = aws_subnet.db_08.id
}

output "nat_eip_id" {
  value = aws_eip.nat_eip.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "public_assoc_01_id" {
  value = aws_route_table_association.public_assoc_01.id
}

output "public_assoc_02_id" {
  value = aws_route_table_association.public_assoc_02.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}

output "private_assoc_03_id" {
  value = aws_route_table_association.private_assoc_03.id
}

output "private_assoc_05_id" {
  value = aws_route_table_association.private_assoc_05.id
}

output "private_assoc_07_id" {
  value = aws_route_table_association.private_assoc_07.id
}

output "private_assoc_08_id" {
  value = aws_route_table_association.private_assoc_08.id
}

output "web_security_group_id" {
  value = aws_security_group.web_sg.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds-sg.id
}

output "tls_public_key_openssh" {
  value = tls_private_key.ec2_key.public_key_openssh
}

output "aws_key_pair_name" {
  value = aws_key_pair.ec2_key.key_name
}

output "private_key_file_path" {
  value = local_file.private_key_pem.filename
}

output "public_ec2_id" {
  value = aws_instance.public_ec2.id
}

output "public_ec2_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "backend_ec2_id" {
  value = aws_instance.backend_ec2.id
}

output "frontend_ec2_id" {
  value = aws_instance.frontend_ec2.id
}

output "s3_bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.name
}
