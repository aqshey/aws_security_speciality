
resource "aws_subnet" "peer_subnet1" {
  vpc_id     = aws_vpc.peer_vpc.id
  cidr_block = "10.0.1.0/24" # This CIDR block provides 256 IP addresses

  tags = {
    Name = "peer-subnet1"
  }
}

resource "aws_subnet" "peer_subnet2" {
  vpc_id     = aws_vpc.peer_vpc.id
  cidr_block = "10.0.2.0/24" # This CIDR block provides 256 IP addresses

  tags = {
    Name = "peer-subnet2"
  }
}