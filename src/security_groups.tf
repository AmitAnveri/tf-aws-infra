resource "aws_security_group" "application_sg" {
  vpc_id = aws_vpc.main_vpc.id

  name        = "${var.vpc_name}_application_sg"
  description = "Security group for application"

  # Allow port 22 traffic from the load balancer security group
  ingress {
    description     = "Allow SSH from Load Balancer SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  # Allow application traffic on the specified application port from the load balancer security group
  ingress {
    description     = "Allow application traffic from Load Balancer SG"
    from_port       = var.application_port
    to_port         = var.application_port
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  # Allow all egress traffic (outbound)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_application_sg"
  }
}
