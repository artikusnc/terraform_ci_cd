resource "aws_vpc" "ccVPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name    = "Sergio_Test_VPC"
    Project = "TF Demo Sergio test"
  }
}

resource "aws_internet_gateway" "ccIGW" {
  vpc_id = aws_vpc.ccVPC.id
  tags = {
    Name    = "ccIGW"
    Project = "TF Demo Sergio"
  }
}

resource "aws_eip" "ccNatGatewayEIP1" {
  tags = {
    Name    = "ccNatGatewayEIP1"
    Project = "TF Demo Sergio"
  }
}
resource "aws_nat_gateway" "ccNatGateway1" {
  allocation_id = aws_eip.ccNatGatewayEIP1.id
  subnet_id     = aws_subnet.ccPublicSubnet1.id
  tags = {
    Name    = "ccNatGateway1"
    Project = "TF Demo Sergio"
  }
}
resource "aws_subnet" "ccPublicSubnet1" {
  vpc_id            = aws_vpc.ccVPC.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "ccPublicSubnet1"
    Project = "TF Demo Sergio"
  }
}

resource "aws_eip" "ccNatGatewayEIP2" {
  tags = {
    Name    = "ccNatGatewayEIP2"
    Project = "TF Demo Sergio"
  }
}
resource "aws_nat_gateway" "ccNatGateway2" {
  allocation_id = aws_eip.ccNatGatewayEIP2.id
  subnet_id     = aws_subnet.ccPublicSubnet1.id
  tags = {
    Name    = "ccNatGateway2"
    Project = "TF Demo Sergio"
  }
}
resource "aws_subnet" "ccPublicSubnet2" {
  vpc_id            = aws_vpc.ccVPC.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "ccPublicSubnet2"
    Project = "TF Demo Sergio"
  }
}

resource "aws_subnet" "ccPrivateSubnet1" {
  vpc_id            = aws_vpc.ccVPC.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "ccPrivateSubnet1"
    Project = "TF Demo Sergio"
  }
}
resource "aws_subnet" "ccPrivateSubnet2" {
  vpc_id            = aws_vpc.ccVPC.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "ccPrivateSubnet2"
    Project = "TF Demo Sergio"
  }
}

resource "aws_route_table" "ccPublicRT" {
  vpc_id = aws_vpc.ccVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ccIGW.id
  }
  tags = {
    Name    = "ccPublicRT"
    Project = "TF Demo Sergio"
  }
}
resource "aws_route_table" "ccPrivateRT1" {
  vpc_id = aws_vpc.ccVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ccNatGateway1.id
  }
  tags = {
    Name    = "ccPrivateRT1"
    Project = "TF Demo Sergio"
  }
}
resource "aws_route_table" "ccPrivateRT2" {
  vpc_id = aws_vpc.ccVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ccNatGateway2.id
  }
  tags = {
    Name    = "ccPrivateRT2"
    Project = "TF Demo Sergio"
  }
}

resource "aws_route_table_association" "ccPublicRTassociation1" {
  subnet_id      = aws_subnet.ccPublicSubnet1.id
  route_table_id = aws_route_table.ccPublicRT.id
}
resource "aws_route_table_association" "ccPublicRTassociation2" {
  subnet_id      = aws_subnet.ccPublicSubnet2.id
  route_table_id = aws_route_table.ccPublicRT.id
}
resource "aws_route_table_association" "ccPrivateRTassociation1" {
  subnet_id      = aws_subnet.ccPrivateSubnet1.id
  route_table_id = aws_route_table.ccPrivateRT1.id
}
resource "aws_route_table_association" "ccPrivateRTassociation2" {
  subnet_id      = aws_subnet.ccPrivateSubnet2.id
  route_table_id = aws_route_table.ccPrivateRT2.id
}