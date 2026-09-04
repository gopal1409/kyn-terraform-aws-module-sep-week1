output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.this.cidr_block
}

output "subnet_ids" {
  description = "Subnet IDs"
  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id
  }
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}

output "route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}
