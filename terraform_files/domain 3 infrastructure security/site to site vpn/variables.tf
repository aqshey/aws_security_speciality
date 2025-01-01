variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "customer_gateway_ip" {
  description = "The IP address of the customer gateway"
  type        = string
}

variable "bgp_asn" {
  description = "The BGP ASN for the customer gateway"
  type        = number
}

variable "destination_cidr_block" {
  description = "The destination CIDR block for the VPN connection route"
  type        = string
}