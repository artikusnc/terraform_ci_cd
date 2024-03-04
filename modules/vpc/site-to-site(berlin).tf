provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  # Outras configurações da VPC
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  # Outras configurações da sub-rede
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = "80.156.239.10"  # Endereço IP público do Fortinet Firewall
  type       = "ipsec.1"
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = aws_customer_gateway.cgw.id
  vpn_gateway_id     = aws_vpn_gateway.vgw.id
  type               = "ipsec.1"

  tunnel1 {
    pre_shared_key = "VWXacKvfA^dHvWtLy6$tu8#PSyR*qM"
    tunnel_inside_cidr = aws_subnet.subnet.cidr_block
    tunnel_outside_address = "80.156.239.10"  # Endereço IP público do Fortinet Firewall
  }

  tags = {
    Name = "Fortinet VPN Connection OF Berlin Office"
  }
}
