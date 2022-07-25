#Two Tier Architecture in Terraform

#Define provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-1"
}

#VPC
resource "aws_vpc" "vpc_block" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc_block"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "ig" {
  tags = {
    Name = "ig"
  }
  vpc_id = aws_vpc.vpc_block.id
}

#2 Public Subnets
resource "aws_subnet" "public_subnet1" {
  tags = {
    Name = "public_subnet1"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.public_subnet1
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "public_subnet2" {
  tags = {
    Name = "public_subnet2"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.public_subnet2
  availability_zone = "us-west-1b"
}

# 2 Private subnets with RDS MySQL instance
resource "aws_subnet" "private_subnet1" {
  tags = {
    Name = "private_subnet1"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.private_subnet1
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "private_subnet2" {
  tags = {
    Name = "private_subnet2"
  }
  vpc_id            = aws_vpc.vpc_block.id
  cidr_block        = var.private_subnet2
  availability_zone = "us-west-1b"
}

#Create EC2 instance in publice subnet1
resource "aws_instance" "EC2-1" {
  ami                         = var.ec2_instance_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  count                       = 1
}

#Create EC2 instance in publice subnet2
resource "aws_instance" "EC2_2" {
  ami                         = var.ec2_instance_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet2.id
  associate_public_ip_address = true
  count                       = 1
}

#Create RDS instance
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "two_tier_db"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

#Elastic Load Balancer
resource "aws_lb" "LB" {
  name               = "two-tier-LB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}