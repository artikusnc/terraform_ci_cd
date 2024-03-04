# Create Customer Gateway (GW)
resource "aws_customer_gateway" "aws-of-cgw" {
  bgp_asn     = 65000
  device_name = "aws-of-cgw"
  ip_address  = local.of_router_ip
  type        = "ipsec.1"
  tags = {
    Name = "aws-of-cgw"
  }
}
#Create Private Gateway (GW)
resource "aws_vpn_gateway" "aws-of-pgw" {
  vpc_id = local.vpc_id

  tags = {
    Name = "aws-of-pgw"
  }
}

# Private GW attachment to MGM VPC
resource "aws_vpn_gateway_attachment" "aws-of-pgw-attachment" {
  vpc_id         = local.vpc_id
  vpn_gateway_id = aws_vpn_gateway.aws-of-pgw.id
  depends_on = [
    aws_vpn_gateway.aws-of-pgw
  ]
}

# Site-to-site VPN
resource "aws_vpn_connection" "aws-of-s2s" {
  customer_gateway_id = aws_customer_gateway.aws-of-cgw.id
  vpn_gateway_id      = aws_vpn_gateway.aws-of-pgw.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "aws-of-s2s"
  }
  depends_on = [
    aws_vpn_gateway_attachment.aws-of-pgw-attachment,
    aws_customer_gateway.aws-of-cgw
  ]
}