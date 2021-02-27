resource "aws_vpc" "magento2" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.magento2.id
  tags = {
    Name = "abadawy-dev"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.magento2.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_subnet" "magento2" {
  vpc_id            = aws_vpc.magento2.id
  cidr_block        = var.SUBNET_CIDR
  availability_zone = var.AVAIALBILITY_ZONE
  #associate_public_ip_address = "true"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "abadawy-dev"
  }
}


resource "aws_security_group" "magento2" {
  name   = "varnish_sg"
  vpc_id = aws_vpc.magento2.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [var.VPC_CIDR]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["169.132.90.0/23"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "abadawy-dev"
  }
}
