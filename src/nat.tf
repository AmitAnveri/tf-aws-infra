# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}_nat_eip"
  }
}

# Create a NAT Gateway in a public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id # Public subnet
  tags = {
    Name = "${var.vpc_name}_nat_gateway"
  }
}
