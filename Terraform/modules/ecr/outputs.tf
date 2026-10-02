output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.shopsphere.name
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.shopsphere.arn
}

output "repository_url" {
  description = "URI used to push and pull container images"
  value       = aws_ecr_repository.shopsphere.repository_url
}

output "registry_id" {
  description = "AWS account ID that owns the ECR repository"
  value       = aws_ecr_repository.shopsphere.registry_id
}