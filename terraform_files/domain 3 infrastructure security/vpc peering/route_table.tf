resource "aws_route_table" "main_subnet1_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_vpc.peer_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  }

  tags = {
    Name = "main-subnet1-route-table"
  }
}

resource "aws_route_table" "main_subnet2_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_vpc.peer_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  }

  tags = {
    Name = "main-subnet2-route-table"
  }
}

resource "aws_route_table" "peer_subnet1_route_table" {
  vpc_id = aws_vpc.peer_vpc.id

  route {
    cidr_block = aws_vpc.main.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  }

  tags = {
    Name = "peer-subnet1-route-table"
  }
}

resource "aws_route_table" "peer_subnet2_route_table" {
  vpc_id = aws_vpc.peer_vpc.id

  route {
    cidr_block = aws_vpc.main.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  }

  tags = {
    Name = "peer-subnet2-route-table"
  }
}