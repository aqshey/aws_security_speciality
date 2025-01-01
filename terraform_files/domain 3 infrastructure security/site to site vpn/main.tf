#site to site vpn

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "vpn-gw"
  }
}
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = "1.2.3.4"
    type       = "ipsec.1"
    tags = {
    Name = "cgw"
    environment = "dev"
    }
}
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.cgw.id
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "vpn-connection"
  }
}
resource "aws_vpn_connection_route" "vpn_route" {
  destination_cidr_block = "10.0.0.212/32"
    vpn_connection_id      = aws_vpn_connection.vpn_connection.id
}


