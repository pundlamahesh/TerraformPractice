resource "aws_db_instance" "read_replica" {
  identifier = "rds-test-replica"

  # Source DB
  replicate_source_db = aws_db_instance.default.arn

  instance_class = "db.t3.micro"
  engine         = "mysql"

  # Use same subnet group
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  # Monitoring (optional but recommended)
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  # Maintenance window
  maintenance_window = "sun:05:00-sun:06:00"

  # Deletion protection (optional)
  deletion_protection = false

  # No backups required for read replicas
  backup_retention_period = 0

  tags = {
    Name = "rds-test-read-replica"
  }
  
}
