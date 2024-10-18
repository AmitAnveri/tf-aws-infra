resource "aws_security_group" "db_security_group" {
  name        = "${var.vpc_name}_db_sg"
  vpc_id      = aws_vpc.main_vpc.id
  description = "Security group for the RDS database"

  ingress {
    description = "Allow PostgreSQL traffic from the application security group"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    source_security_group_id = aws_security_group.application_sg.id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_db_sg"
  }
}
