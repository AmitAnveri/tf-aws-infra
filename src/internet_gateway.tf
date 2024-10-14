resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.testing_bad

  tags = {
    Name = "${var.vpc_name}_igw"
  }
}
