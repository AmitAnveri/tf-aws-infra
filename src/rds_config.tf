# RDS Parameter Group
resource "aws_db_parameter_group" "rds_pg" {
  name        = "${var.vpc_name}rdspg"
  family      = var.family
  description = "Custom parameter group for RDS instance"

  tags = {
    Name = "${var.vpc_name}_rds_pg"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.vpc_name}_rds_subnet_group"
  subnet_ids  = aws_subnet.private_subnets[*].id
  description = "RDS Subnet Group for private subnets"

  tags = {
    Name = "${var.vpc_name}_rds_subnet_group"
  }
}

# RDS Instance
resource "aws_db_instance" "rds_instance" {
  identifier             = var.db_name
  instance_class         = var.instance_class
  allocated_storage      = 20
  engine                 = var.dbengine
  engine_version         = var.engine_version
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.rds_pg.name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  publicly_accessible    = false
  multi_az               = false
  skip_final_snapshot    = true

  tags = {
    Name = "${var.vpc_name}_rds_instance"
  }
}

