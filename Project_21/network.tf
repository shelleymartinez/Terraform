#network.tf

#VPC
resource "aws_vpc" "vpc_block" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ECS_vpc_block"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "IG" {
  tags = {
    Name = "ECS_IG"
  }
  vpc_id = aws_vpc.vpc_block.id
}

#2 Public Subnets
resource "aws_subnet" "public_subnet1" {
  tags = {
    Name = "ECS_public_subnet1"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.public_subnet1
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "public_subnet2" {
  tags = {
    Name = "ECS_public_subnet2"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.public_subnet2
  availability_zone = "us-west-1b"
}

# 2 Private subnets
resource "aws_subnet" "private_subnet1" {
  tags = {
    Name = "ECS_private_subnet1"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.private_subnet1
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "private_subnet2" {
  tags = {
    Name = "ECS_private_subnet2"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.private_subnet2
  availability_zone = "us-west-1b"
}