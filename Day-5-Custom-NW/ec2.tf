# ---------------- EC2 INSTANCES ----------------
resource "aws_instance" "public_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_01.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  tags = { Name = "PublicServer" }
}

resource "aws_instance" "backend_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_03.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  tags = { Name = "BackendServer" }
}

resource "aws_instance" "frontend_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_05.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  tags = { Name = "FrontendServer" }
}
