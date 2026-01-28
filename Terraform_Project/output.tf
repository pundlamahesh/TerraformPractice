output "public_ec2_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "frontend_ec2_id" {
  value = aws_instance.frontend_ec2.id
}

output "backend_ec2_id" {
  value = aws_instance.backend_ec2.id
}
