data "aws_region" "current" {}
data "aws_availability_zone" "available" {}

resource "aws_vpc" "app"{
    cidr_block = "172.16.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "app"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.app.id
    count = 3
    cidr_block = cidrsubnet(aws_vpc.app.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zone.available.names[count.index]
    tags = {
      Name = "public-subnet-${count-index}"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.app.id
    count = 3
    cidr_block = cidrsubnet(aws_vpc.app.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zone.available.names[count.index]
    tags = {
      Name = "private-subnet-${count-index}"
    }
}