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

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_subnet" "magento2_1" {
  vpc_id            = aws_vpc.magento2.id
  cidr_block        = var.SUBNET_CIDR1
  availability_zone = var.az_1
  #associate_public_ip_address = "true"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "abadawy-dev"
  }
}
resource "aws_subnet" "magento2_2" {
  vpc_id            = aws_vpc.magento2.id
  cidr_block        = var.SUBNET_CIDR2
  availability_zone = var.az_2
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
    cidr_blocks = [var.VPC_CIDR, "169.132.90.0/23"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] ## 169.132.90.0/23 to be changed in terraform.tfvars
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
