output "vpc_id" {
  description = "ShopSphere VPC ID"
  value       = module.network.vpc_id
}

output "vpc_name" {
  description = "ShopSphere VPC name"
  value       = module.network.vpc_name
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = module.network.database_subnet_ids
}

output "management_subnet_ids" {
  description = "Management subnet IDs"
  value       = module.network.management_subnet_ids
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.endpoint
  sensitive   = true
}

output "rds_master_user_secret_arn" {
  description = "ARN of the RDS-managed master credentials secret"
  value       = module.rds.master_user_secret_arn
  sensitive   = true
}

output "s3_bucket_name" {
  description = "Application S3 bucket name"
  value       = module.s3.bucket_name
}

output "bastion_private_ip" {
  description = "Bastion private IP"
  value       = module.bastion.bastion_private_ip
}
output "cloudwatch_log_group" {
  description = "Application CloudWatch log group"
  value       = module.logging.log_group_name
}

output "monitoring_sns_topic_arn" {
  description = "Monitoring SNS topic ARN"
  value       = module.monitoring.sns_topic_arn
}

output "jwt_secret_arn" {
  description = "JWT secret Secrets Manager ARN"
  value       = module.secrets_manager.jwt_secret_arn
}

output "alb_security_group_id" {
  description = "Security group ID used by the ShopSphere application load balancer"
  value       = module.loadbalancer.security_group_id
}