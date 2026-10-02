
output "jwt_secret_id" {
  description = "AWS Secrets Manager ID for JWT secret"
  value       = aws_secretsmanager_secret.jwt.id
}

output "jwt_secret_arn" {
  description = "AWS Secrets Manager ARN for JWT secret"
  value       = aws_secretsmanager_secret.jwt.arn
}
