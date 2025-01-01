# vpc peering

resource "aws_vpc_peering_connection" "peering_connection" {
  provider = aws.vpc_peering_connection
  vpc_id = aws_vpc.main.id
  peer_vpc_id = aws_vpc.peer_vpc.id

  auto_accept = true
  tags = {
    Name = "vpc-peering"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24" # This CIDR block provides 256 IP addresses

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_vpc" "peer_vpc" {
  cidr_block = "10.0.1.0/24" # This CIDR block provides 256 IP addresses

  tags = {
    Name = "peer-vpc"
  }
}
