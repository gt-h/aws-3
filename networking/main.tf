data "aws_availability_zones" "availabile" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.client_name}_main_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.client_name}_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.client_name}_public_rt"
  }
}

resource "aws_default_route_table" "privat_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  route {
    # count = var.privat_subnets_count
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.private_gateway_id[0]
  }
  tags = {
    Name = "${var.client_name}_privat_rt"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = var.public_subnets_count
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_subnets_prefix)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.availabile.names[count.index]
  tags = {
    Name = "${var.client_name}_public_subnet_${count.index}"
  }
}

resource "aws_subnet" "privat_subnets" {
  count             = var.privat_subnets_count
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.privat_subnets_prefix)
  availability_zone = data.aws_availability_zones.availabile.names[count.index]
  tags = {
    Name = "${var.client_name}_privat_subnet_${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnets_count
  subnet_id      = aws_subnet.public_subnets.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "privat" {
  count          = var.privat_subnets_count
  subnet_id      = aws_subnet.privat_subnets.*.id[count.index]
  route_table_id = aws_default_route_table.privat_rt.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.client_name}_default"
  }
}
