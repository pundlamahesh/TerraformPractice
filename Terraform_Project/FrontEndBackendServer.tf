#Createbackendserver
resource "aws_instance" "backend_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_03.id
  vpc_security_group_ids = [aws_security_group.backend-server-sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  tags = { Name = "BackendServer" }
}
#Createfrontendserver
resource "aws_instance" "frontend_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_05.id
  vpc_security_group_ids = [aws_security_group.frontend-server-sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  tags = { Name = "FrontendServer" }
}