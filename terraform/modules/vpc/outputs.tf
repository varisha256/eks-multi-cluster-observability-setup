
output "vpc_id" { value = aws_vpc.this.id }
# output "public_subnets" { value = aws_subnet.public[*].id }
# output "private_subnets" { value = aws_subnet.private[*].id }

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_platform_subnet_ids" {
  description = "IDs of private platform subnets"
  value       = aws_subnet.private_platform[*].id
}

output "private_workload_subnet_ids" {
  description = "IDs of private workload subnets"
  value       = aws_subnet.private_workload[*].id
}
