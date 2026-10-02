output "instance_name" {
  description = "RDS instance identifier"
  value       = aws_db_instance.postgres.identifier
}

output "instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.postgres.arn
}

output "endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "address" {
  description = "RDS hostname"
  value       = aws_db_instance.postgres.address
}

output "port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.postgres.port
}

output "database_name" {
  description = "Database name"
  value       = aws_db_instance.postgres.db_name
}

output "engine_version" {
  description = "PostgreSQL engine version"
  value       = aws_db_instance.postgres.engine_version
}

output "db_subnet_group_name" {
  description = "RDS DB subnet group name"
  value       = aws_db_subnet_group.shopsphere.name
}

output "security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "master_user_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret managed by RDS for the master credentials"
  value       = aws_db_instance.postgres.master_user_secret[0].secret_arn
  sensitive   = true
}

