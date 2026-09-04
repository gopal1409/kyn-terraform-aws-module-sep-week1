resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )
}

resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id = aws_vpc.this.id

  cidr_block = each.value.cidr_block

  availability_zone = each.value.availability_zone

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-${each.key}"
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-rt"
    }
  )
}

resource "aws_route" "internet" {
  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.this

  subnet_id = each.value.id

  route_table_id = aws_route_table.public.id
}
