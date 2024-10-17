# Define the security group for the application
resource "aws_security_group" "application_sg" {
  vpc_id = aws_vpc.main_vpc.id

  name        = "${var.vpc_name}_application_sg"
  description = "Security group for application"

  # Allow SSH (port 22) traffic from anywhere
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80) traffic from anywhere
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (port 443) traffic from anywhere
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow application traffic on the specified application port (e.g., port 8080)
  ingress {
    description = "Allow application traffic"
    from_port   = var.application_port
    to_port     = var.application_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all egress traffic (outbound)
  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1" # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_application_sg"
  }
}
