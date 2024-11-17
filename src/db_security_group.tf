resource "aws_security_group" "db_security_group" {
  name        = "${var.vpc_name}_db_sg"
  description = "Security group for the RDS database instance"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}_db_sg"
  }
}

# Ingress rule to allow traffic from the application security group on the PostgreSQL port (5432)
resource "aws_security_group_rule" "db_ingress_rule" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_security_group.id
  source_security_group_id = aws_security_group.application_sg.id
}

# New rule to allow traffic from Lambda security group
resource "aws_security_group_rule" "db_ingress_from_lambda" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_security_group.id
  source_security_group_id = aws_security_group.lambda_sg.id
}
