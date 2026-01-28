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
  vpc_security_group_ids = [aws_security_group.bastion-host.id]
  key_name = aws_key_pair.ec2_key.key_name
  tags = { Name = "BastionHost" }
}