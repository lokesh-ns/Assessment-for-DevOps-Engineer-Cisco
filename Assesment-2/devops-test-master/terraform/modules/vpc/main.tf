resource "aws_vpc" "mindmeld_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mindmeld_vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.mindmeld_vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-public-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.mindmeld_vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-public-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.mindmeld_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "${var.project}-${var.environment}-private-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.mindmeld_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "${var.project}-${var.environment}-private-2"
  }
}

resource "aws_eip" "elastic_ip_1" {
  domain = "vpc"
  tags   = { Name = "${var.project}-${var.environment}-eip-1" }
}

resource "aws_eip" "elastic_ip_2" {
  domain = "vpc"
  tags   = { Name = "${var.project}-${var.environment}-eip-2" }
}

resource "aws_nat_gateway" "public_nat_1" {
  allocation_id = aws_eip.elastic_ip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.gw]

  tags = { Name = "${var.project}-${var.environment}-nat-1" }
}

resource "aws_nat_gateway" "public_nat_2" {
  allocation_id = aws_eip.elastic_ip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
  depends_on    = [aws_internet_gateway.gw]

  tags = { Name = "${var.project}-${var.environment}-nat-2" }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.mindmeld_vpc.id
  tags   = { Name = "${var.project}-${var.environment}-public-rt" }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.mindmeld_vpc.id
  tags   = { Name = "${var.project}-${var.environment}-private-rt-1" }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.mindmeld_vpc.id
  tags   = { Name = "${var.project}-${var.environment}-private-rt-2" }
}

resource "aws_route" "private_route_1" {
  route_table_id         = aws_route_table.private_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_nat_1.id
}

resource "aws_route" "private_route_2" {
  route_table_id         = aws_route_table.private_route_table_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_nat_2.id
}

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}