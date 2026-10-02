output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.shopsphere.id
}


output "vpc_name" {
  description = "VPC name"
  value       = aws_vpc.shopsphere.tags["Name"]
}


output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}


output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}


output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = aws_subnet.database[*].id
}


output "management_subnet_ids" {
  description = "Management subnet IDs"
  value       = aws_subnet.management[*].id
}


output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.shopsphere.id
}


output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.shopsphere.id
}