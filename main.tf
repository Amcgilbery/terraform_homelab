data "aws_availability_zones" "available" {}

resource "aws_vpc" "app" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "app"
  }
}

resource "aws_internet_gateway" "app_vpc_igw" {
  vpc_id = aws_vpc.app.id
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.app.id
  count = 2
  cidr_block = cidrsubnet(aws_vpc.app.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.app.id
  count = 2
  cidr_block = cidrsubnet(aws_vpc.app.cidr_block, 8, count.index + 3)

  # Corrected availability zone reference
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_security_group" "app_security_group" {
    name = "app_security_group"
    vpc_id = aws_vpc.app.id
}

resource "aws_vpc_security_group_ingress_rule" "app_web_in" {
  security_group_id = aws_security_group.app_security_group.id
  ip_protocol = "tcp"
  to_port = 80
  from_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_web_out" {
  security_group_id = aws_security_group.app_security_group.id
  ip_protocol = -1
  cidr_ipv4 = "0.0.0.0/0"
}