// VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

// subnet
resource "aws_subnet" "private_1a_aws_batch" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.az_a
  tags = {
    Name = "private 1a app 1"
  }
}

resource "aws_subnet" "private_1a_vpc_endpoint" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = local.az_a
  tags = {
    Name = "private 1a vpc endpoint"
  }
}

resource "aws_subnet" "private_1c_aws_batch" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = local.az_c
  tags = {
    Name = "private 1c app 2"
  }
}

resource "aws_subnet" "private_1c_vpc_endpoint" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = local.az_c
  tags = {
    Name = "private 1c vpc endpoint"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "VPC Endpoint S3"
  }
}

resource "aws_route_table_association" "private" {
  for_each = [
    aws_subnet.private_1a_aws_batch.id,
    aws_subnet.private_1c_aws_batch.id,
  ]

  subnet_id      = each.key
  route_table_id = aws_route_table.private.id
}

