resource "aws_vpc" "techno-vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "techno-public" {
  vpc_id                  = aws_vpc.techno-vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "techno-igw" {
  vpc_id = aws_vpc.techno-vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "techno-public-rt" {
  vpc_id = aws_vpc.techno-vpc.id

  tags = {
    Name = "dev-publiv-rt"
  }
}

resource "aws_route" "techno-route" {
  route_table_id         = aws_route_table.techno-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.techno-igw.id
}

resource "aws_route_table_association" "techno-rt-asc" {
  subnet_id      = aws_subnet.techno-public.id
  route_table_id = aws_route_table.techno-public-rt.id
}

resource "aws_security_group" "techno-sg" {
  name        = "dev-sg"
  description = "dev security group"
  vpc_id      = aws_vpc.techno-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}