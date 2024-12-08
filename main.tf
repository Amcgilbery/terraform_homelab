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