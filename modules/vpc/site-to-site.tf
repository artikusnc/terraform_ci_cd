#use the aws provider and find the default profile in the aws credentials file
provider "aws" {
  region = "us-east-1"
  profile = "default"
}

#find the latest AWS Linux AMI
#data "aws_ssm_parameter" "linux" {
#  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
#}

#we will use the default vpc (172.31.0.0/16)
#data "aws_vpc" "default" {
#    default = true
#}

#defining a subnet in the default vpc to place my Linux EC2
data "aws_subnet" "default" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1a"
    default_for_az = true
}

#create a security group to allow all inbound from local AWS CIDR and on-premise CIDR of 192.168.0.0/16; also include all outbound traffic to anywhere
resource "aws_security_group" "allowIn" {
  name        = "allow_inbound"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.default.cidr_block, "192.168.0.0/16"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Linux creation in the default VPC and subnet defined earlier, tied to security group created earlier, and outputting the private IP address of the EC2 after creation
resource "aws_instance" "awslinux01" {
    ami = "ami-0eb11ab33f229b26c"
    instance_type = "t2.micro"
    tags = {
        Name = "awslinux"
    }
    subnet_id = data.aws_subnet.default.id
    vpc_security_group_ids = [aws_security_group.allowIn.id]

}

output "AWSLinuxPrivateIP" {
    value = aws_instance.awslinux01.private_ip
}

#This IP address will be the public IP of the router/firewall on-premise
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = "80.156.239.10"
  type       = "ipsec.1"

  tags = {
    Name = "OneFootball Berlin office"
  }
}

#Virtual Private Gateway creation and attachment to AWS VPC; Route propagation enabled
resource "aws_vpn_gateway" "vpngw" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "AWS VGW - Site-to-site Berlin"
  }
}

resource "aws_vpn_gateway_attachment" "vpngw_attachment" {
  vpc_id         = data.aws_vpc.default.id
  vpn_gateway_id = aws_vpn_gateway.vpngw.id
}

resource "aws_vpn_gateway_route_propagation" "routepropagation" {
  vpn_gateway_id = aws_vpn_gateway.vpngw.id
  route_table_id = data.aws_vpc.default.main_route_table_id
}

#Creation of site to site VPN in AWS using the AWS Virtual Private Gateway, the Customer Gateway of the on-premise router/firewall, and a predefined pre-shared key for the tunnel
resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpngw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
  tunnel1_preshared_key = "ewdsd13232refsdfsdsg344"
}

#create static route to the on-premise network on the AWS VPN side
resource "aws_vpn_connection_route" "onpremNetwork" {
  destination_cidr_block = "10.100.130.0/23"
  vpn_connection_id      = aws_vpn_connection.vpn.id
}

#output of Tunnel 1 IP address
output "AWStunnel1IP" {
  value = aws_vpn_connection.vpn.tunnel1_address
}

#output of Tunnel 2 IP address
output "AWStunnel2IP" {
  value = aws_vpn_connection.vpn.tunnel2_address
}