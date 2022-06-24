resource "aws_vpc" "obligatorio-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "obligatorio-vpc"
  }
}
resource "aws_subnet" "obligatorio-subnet-public2" {
  vpc_id     = aws_vpc.obligatorio-vpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "obligatorio-subnet-public2"
  }
}
resource "aws_subnet" "obligatorio-subnet-public1" {
  vpc_id     = aws_vpc.obligatorio-vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "obligatorio-subnet-public1"
  }
}
resource "aws_subnet" "obligatorio-subnet-private2" {
  vpc_id     = aws_vpc.obligatorio-vpc.id
  cidr_block = "10.0.144.0/20"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "obligatorio-subnet-private2"
  }
}
resource "aws_subnet" "obligatorio-subnet-private1" {
  vpc_id     = aws_vpc.obligatorio-vpc.id
  cidr_block = "10.0.128.0/20"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "obligatorio-subnet-private1"
  }
}
resource "aws_internet_gateway" "obligatorio-igw" {
  vpc_id = aws_vpc.obligatorio-vpc.id

  tags = {
    Name = "obligatorio-igw"
  }
}
resource "aws_route_table" "obligatorio-public" {
  vpc_id = aws_vpc.obligatorio-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obligatorio-igw.id
  }

  tags = {
    Name = "obligatorio-public"
  }
}
resource "aws_route_table" "obligatorio-private1" {
  vpc_id = aws_vpc.obligatorio-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obligatorio-igw.id
  }

  tags = {
    Name = "obligatorio-private1"
  }
}
resource "aws_route_table" "obligatorio-private2" {
  vpc_id = aws_vpc.obligatorio-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obligatorio-igw.id
  }

  tags = {
    Name = "obligatorio-private2"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.obligatorio-subnet-private1.id
  route_table_id = aws_route_table.obligatorio-private1.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.obligatorio-subnet-private2.id
  route_table_id = aws_route_table.obligatorio-private2.id
}
