module "rds" {
    source = "../Day-9-cust-RDS-module"
    vpc_cidr = "10.0.0.0/16"

subnets = {
  subnet1 = {
    cidr = "10.0.0.0/24"
    az   = "us-east-1a"
  }
  subnet2 = {
    cidr = "10.0.1.0/24"
    az   = "us-east-1b"
  }
}

db_identifier         = "rds-test"
db_name               = "mydb"
db_instance_class     = "db.t3.micro"
db_allocated_storage  = 10
db_username           = "admin"


backup_window      = "02:00-03:00"
maintenance_window = "sun:04:00-sun:05:00"

  
}