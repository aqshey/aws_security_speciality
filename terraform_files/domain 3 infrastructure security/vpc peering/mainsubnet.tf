resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24" # This CIDR block provides 256 IP addresses

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24" # This CIDR block provides 256 IP addresses

  tags = {
    Name = "subnet2"
  }
}