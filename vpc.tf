# VPC - Subnet - IGW - Routes - Security Group - EIP
resource "aws_vpc" "prod_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Env  = var.infra_env
    Name = "${var.infra_name}-vpc"
  }
}

# subnet
resource "aws_subnet" "prod_public_subnet_1a" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Env  = var.infra_env
    Name = "${var.infra_name}-public-1a"
  }
}

resource "aws_subnet" "prod_private_subnet_1b" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Env  = var.infra_env
    Name = "${var.infra_name}-private-1b"
  }
}

# igw
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Env  = var.infra_env
    Name = "${var.infra_name}-igw"
  }
}

resource "aws_route_table" "prod_public_route" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.prod_igw.id
  }

  tags = {
    Env  = var.infra_env
    Name = "${var.infra_name}-public-route"
  }
}

resource "aws_route_table_association" "prod_public_route_1a" {
  subnet_id      = aws_subnet.prod_public_subnet_1a.id
  route_table_id = aws_route_table.prod_public_route.id
}

resource "aws_security_group" "prod_public_ssh_sg" {
  vpc_id = aws_vpc.prod_vpc.id

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Env  = var.infra_env
    Name = "${var.infra_name}-public-ssh-sg"
  }
}

resource "aws_eip" "prod_public_eip" {
  vpc = true
}