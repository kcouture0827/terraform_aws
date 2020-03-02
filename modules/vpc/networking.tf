# VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = "main"
  }
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "public"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "private"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# EIP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway (in public subnet)
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on = [aws_internet_gateway.igw]
}

# Custom route table with route to internet gateway
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "custom"
  }
}

# Associate public subnet to custom route table
resource "aws_route_table_association" "public_subnet_to_custom_route_table" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.custom_route_table.id
}

# Adopt Default Route Table
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "default"
  }
}

# Associate private subnet to default route table
resource "aws_route_table_association" "private_subnet_to_default_route_table" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_default_route_table.default_route_table.id
}

# Adopt Default NACL and set default rules
resource "aws_default_network_acl" "default_nacl" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

